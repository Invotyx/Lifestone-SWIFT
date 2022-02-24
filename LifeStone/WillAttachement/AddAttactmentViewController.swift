//
//  AddAttactmentViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import AVKit
import AVFoundation
import PDFKit
import MobileCoreServices
import SwiftyCam

class AddAttactmentViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var flgaudio = false
    var doc = PDFDocument()
    var imgFlg = false
    var imgView: String = ""
    
    var imagesArr: [UIImage] = []
    var VideosArr: [URL] = []
    var imgthumb: [UIImage] = []
    
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSelectVideo(_ sender: UIButton) {
        let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.performSegue(withIdentifier: "rec", sender: nil)
//            let VC = RecordVideoViewController()
//            self.present(VC, animated: true, completion: nil)
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            self.btnSelectVideo_Action()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("user cancel")
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        imgFlg = true
        tapUserPhoto()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnAddDoc(_ sender: UIButton) {
        flgaudio = false
        attachDocument()
    }
    
    @IBAction func btnAudio(_ sender: UIButton) {
        flgaudio = true
        attachDocument()
        
    }
}
  //////// pdf icould /////
extension AddAttactmentViewController: UIDocumentPickerDelegate {
    
    private func attachDocument() {
//        let types = ["kUTTypePDF", "kUTTypeText", "kUTTypeRTF", "kUTTypeSpreadsheet"]
        let types = ["com.adobe.pdf","public.composite-content", "public.data", "public.audio"]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        if #available(iOS 11.0, *) {
            importMenu.allowsMultipleSelection = false
        }
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true)
    }
   
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("url = \(urls)")
       
        if PDFDocument(url: urls[0]) != nil {
            if flgaudio{
                alert3(view: self, msg: "something went wrong")
                return
            }
             SVProgressHUD.show(withStatus: "Uploading...")
            let myurl = AppDelegate.baseurl+"api/will/attachment"
            let para = [
                "type[]":"document",
                "will_id":"\(willId)",
                "thumbnail[]":""
            ]
            self.uploadDocument(inputUrl: myurl, parameters: para, pdfData: urls[0])
        }else{
            let str = "\(urls[0])"
             if str.contains("mp3") {
                print("exists")
              SVProgressHUD.show(withStatus: "Uploading...")
                let myurl = AppDelegate.baseurl+"api/will/attachment"
                let para = [
                    "type[]":"audio",
                    "will_id":"\(willId)",
                    "thumbnail[]":""
                ]
                self.uploadAudio(inputUrl: myurl, parameters: para, pdfData: urls[0])
            }else{
                 alert3(view: self, msg: "something went wrong")
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AddAttactmentViewController: TatsiPickerViewControllerDelegate {
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset]) {
        pickerViewController.dismiss(animated: true, completion: nil)
        print("Assets \(assets)")
        if self.imgFlg{
            DispatchQueue.main.async {
                for item in assets{
                    self.imagesArr.append(self.getUIImage(asset: item)!)
                }
                let myurl = AppDelegate.baseurl+"api/will/attachment"
                let para = [
                    "will_id":"\(willId))"
                ]
                if self.imagesArr.count == 0{
                    return
                }
                SVProgressHUD.show(withStatus: "Uploading...")
                self.uploadImageData(inputUrl: myurl, parameters: para, imageFile: self.imagesArr) { (sec) in
                    print(sec)
                }
            }
        }else{
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: "Compressing...")
                self.VideosArr.removeAll()
                self.imgthumb.removeAll()
                if assets.count == 0{
                    return
                }
                self.StartComp(assets: assets, count: 0)
            }
        }
    }
    
    func StartComp(assets:  [PHAsset],count:Int){
        if assets.count == count{
            // upload
            SVProgressHUD.dismiss()
            SVProgressHUD.show(withStatus: "Uploading...")
            let myurl = AppDelegate.baseurl+"api/will/attachment"
            let para = [
                "will_id":"\(willId)"
            ]
            self.uploadVideo(inputUrl: myurl, parameters: para, imageFile: self.imgthumb, videoUrl: self.VideosArr)
            return
        }
        assets[count].getURL(completionHandler: { (res) in
            print(res!)
            self.compressvideo(res: res!, completion: { (resFlag) in
                if resFlag{
                    self.StartComp(assets: assets, count: count+1)
                }
                else{
                    self.StartComp(assets: assets, count: count+1)
                }
            })
        })
        
    }
    
    func generateThumbnail(for asset:AVAsset) -> UIImage? {
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2)
        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        if img != nil {
            let frameImg  = UIImage(cgImage: img!)
            return frameImg
        }
        return nil
    }
    
    func compressvideo(res: URL, completion: @escaping (Bool) -> ()){
        let asset = AVAsset(url: res)
        guard let img = self.generateThumbnail(for: asset) else {
            print("Error: Thumbnail can be generated.")
            return
        }
        print("Image Size: \(img.size)")
        imgthumb.append(img)
        guard let data = NSData(contentsOf: (res)) else {
            return
        }
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        self.compressVideo(inputURL: (res), outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            switch session.status {
            case .unknown:
                completion(false)
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                self.VideosArr.append(compressedURL)
                completion(true)
            case .failed:
                completion(false)
                break
            case .cancelled:
                completion(false)
                break
            @unknown default:
                completion(false)
                break
            }
        }
    }
    
}

///////////////////// image and video handling /////

extension AddAttactmentViewController{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated:true, completion: nil)
        DispatchQueue.main.async {
            let myurl = AppDelegate.baseurl+"api/will/attachment"
            let para = [
                "will_id":"\(willId))"
            ]
//            if self.imagesArr.count == 0{
//                return
//            }
            SVProgressHUD.show(withStatus: "Uploading...")
            self.uploadImageData(inputUrl: myurl, parameters: para, imageFile: [imageView!]) { (sec) in
                print(sec)
            }
        }
        
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    func tapUserPhoto(){
        
        let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.openCamera()
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("user cancel")
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePickerController.delegate = self
            self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            imagePickerController.allowsEditing = true
            self .present(self.imagePickerController, animated: true, completion: nil)
        }
        else {
            let message = "There is some thing wrong with camera"
            alert(view: self, msg: message)
            
        }
    }
    
    
    
    func openGallary() {
        var config = TatsiConfig.default
        config.showCameraOption = true
        config.supportedMediaTypes = [.image]
        config.firstView = .userLibrary
        config.maxNumberOfSelections = 10
        self.imgFlg = true
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    func btnSelectVideo_Action() {
        var config = TatsiConfig.default
        config.showCameraOption = true
        config.supportedMediaTypes = [.video]
        config.firstView = .userLibrary
        config.maxNumberOfSelections = 10
        self.imgFlg = false
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
   
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
}






//////////////// Api  calls //////////

extension AddAttactmentViewController{
    
    /////////////// upload [image] /////////////////////////
    
    func uploadImageData(inputUrl:String,parameters:[String:Any],imageFile : [UIImage],completion:@escaping(_:Any)->Void) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for imageDataa in imageFile {
                let imageData = imageDataa.jpegData(compressionQuality: 0.5)
//                let img = imageDataa.ResizeImageOriginalSize(targetSize: CGSize(width: 100, height: 100))
                let imageDataTumb = imageDataa.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageData!, withName: "file[]", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
                multipartFormData.append("image".data(using: .utf8)!, withName: "type[]")
                multipartFormData.append(imageDataTumb!, withName: "thumbnail[]", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            }
            
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.int ?? 0
                        if success == 1 {
                            let user = dic["user"]?.dictionaryValue ?? [:]
                            print(user)
                            AppDelegate.personalInfo.profileImage = user["profile_image"]?.stringValue ?? ""
                            Save_UD(info: AppDelegate.personalInfo)
                            self.GetUserWillDetails()
                        }
                        else{
                            SVProgressHUD.dismiss()
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                    if let JSON = response.result.value {
                        completion(JSON)
                    }
                    else{
                        // completion(nilValue)
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    
    ///////////// Upload Video ///////////////////////
    
    func uploadVideo(inputUrl:String,parameters:[String:Any],imageFile : [UIImage] ,videoUrl:[URL]){
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for item in videoUrl{
                multipartFormData.append(item, withName: "file[]", fileName: "Video\(arc4random_uniform(100)).mp4", mimeType: "video/mp4")
                multipartFormData.append("video".data(using: .utf8)!, withName: "type[]")
            }
            
            for imageDataa in imageFile {
//                let img = imageDataa.ResizeImageOriginalSize(targetSize: CGSize(width: 100, height: 100))
                let imageDataTumb = imageDataa.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageDataTumb!, withName: "thumbnail[]", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            }
          
            
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploding")
                })
                upload.responseJSON { response in
                    
                    print("done")
                    
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.boolValue ?? false
                        if success {
                            self.GetUserWillDetails()
                            SVProgressHUD.dismiss()
                        }
                        else{
                            SVProgressHUD.dismiss()
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                }
            case .failure(let encodingError):
                print("failed")
                print(encodingError)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    /////////////////// Upload document /////////////
    func uploadAudio(inputUrl:String,parameters:[String:Any],pdfData : URL){
        let data = try? Data(contentsOf: pdfData)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data!, withName: "file[]", fileName: "Audio\(arc4random_uniform(100)).mp3", mimeType:"mp3")
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploding")
                })
                upload.responseJSON { response in
                    
                    print("done")
                    
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.boolValue ?? false
                        if success {
                            SVProgressHUD.dismiss()
                            self.GetUserWillDetails()
                        }
                        else{
                            SVProgressHUD.dismiss()
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                }
            case .failure(let encodingError):
                print("failed")
                print(encodingError)
                SVProgressHUD.dismiss()
            }
        }
    }
    
   
/////////////////// Upload document /////////////
    func uploadDocument(inputUrl:String,parameters:[String:Any],pdfData : URL){
        let data = try? Data(contentsOf: pdfData)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data!, withName: "file[]", fileName: "pdfDocuments\(arc4random_uniform(100)).pdf", mimeType:"application/pdf")
             for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploding")
                })
                upload.responseJSON { response in
                    
                    print("done")
                    
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.boolValue ?? false
                        if success {
                            SVProgressHUD.dismiss()
                            self.GetUserWillDetails()
                        }
                        else{
                            SVProgressHUD.dismiss()
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                }
            case .failure(let encodingError):
                print("failed")
                print(encodingError)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    
    func GetSaveDoc(){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/attachment"
        let para = [
            "type":"document",
            "will_id":"\(willId)",
            "file":"\(doc)",
            "thumbnail":""
        ]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                      
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.GetUserWillDetails()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    
    func GetUserWillDetails(){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/detail"
        let para = ["ls_id":"\(objtofollow.id)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        arrFiles.removeAll()
                        arrAttactment.removeAll()
                        SVProgressHUD.dismiss()
                        let data = dic["data"]?.dictionary ?? [:]
                        
                        let arrAttachments = data["attachments"]?.array ?? []
                        for item in arrAttachments{
                            let lbj = Attachment()
                            lbj.id = item["id"].int ?? 0
                            lbj.type = item["type"].string ?? ""
                            lbj.imageURL = item["image_url"].string ?? ""
                            lbj.thumbURL = item["thumb_url"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            if lbj.type == "image" ||  lbj.type == "video" ||  lbj.type == "audio"{
                                arrAttactment.append(lbj)
                            }
                            if  lbj.type == "document"{
                                arrFiles.append(lbj)
                            }
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        objMedia.reloadData()
//                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }

    
}



