//
//  FollwerMediaViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//



class UserSendData{
    var image:UIImage
    var thum:UIImage
    init()
    {
        self.image = UIImage()
        self.thum = UIImage()
    }
    init(image:UIImage,thum:UIImage)
    {
        self.image = image
        self.thum = thum
    }
}

class UserData {
    var id, lsID, userID: Int
    var type: String
    var imageURL: String
    var thumbURL: String
    var ischk: Bool
    var created_at: String
 
    init() {
        self.id = 0
        self.lsID = 0
        self.userID = 0
        self.type = ""
        self.imageURL = ""
        self.thumbURL = ""
        self.created_at = ""
        self.ischk = false
    }
    init(id: Int, lsID: Int, userID: Int, type: String, imageURL: String, thumbURL: String,ischk: Bool,created_at: String) {
        self.id = id
        self.lsID = lsID
        self.userID = userID
        self.type = type
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.ischk = ischk
        self.created_at = created_at
    }
}

var MoveobjUserData = UserData()
var Listimages: [UserData]  = []
var ListVideos: [UserData] = []

import UIKit
import MobileCoreServices
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

class MediaViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

   
    var imageArray:[UserSendData] = []
    private var videoView: VideoView?
    
    var imgFlg = false
    var videoUrl: String?
    var imgView: String = ""
    var imagePickerController = UIImagePickerController()
    var videoURL : NSURL?
    var imagesArr: [UIImage] = []
    var VideosArr: [URL] = []
     var imgthumb: [UIImage] = []
    
    var flgselectAll = false
    var flgedit = false
    
    @IBOutlet weak var colvwimages: UICollectionView!
    @IBOutlet weak var colvwvideos: UICollectionView!
    @IBOutlet weak var btnimg: UIButton!
    @IBOutlet weak var btnvideo: UIButton!
    @IBOutlet weak var lblvd: UILabel!
    @IBOutlet weak var imgheight: NSLayoutConstraint!
    @IBOutlet weak var videoheight: NSLayoutConstraint!
    @IBOutlet weak var lblimg: UILabel!
    
    @IBOutlet weak var btedit: UIButton!
    @IBOutlet weak var btselectAll: UIButton!
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var vwheight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          GetData()
          userLoad()
        objMyMedia = self
        changeStatus()
        
        if UserTapped == UserRoleKey.Follow.rawValue{
            btedit.isHidden = true
        }else{
            btedit.isHidden = false
        }
       
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        UserDeleteMedia()
    }
    
    @IBAction func btnedit(_ sender: UIButton) {
        if self.flgedit{
            flgedit = false 
            btedit.setTitle("EDIT", for: .normal)
            for item in Listimages{
                item.ischk = false
            }
            for item in ListVideos{
                item.ischk = false
            }
            colvwimages.reloadData()
            colvwvideos.reloadData()
        }else{
            flgedit = true
            btedit.setTitle("CANCEL", for: .normal)
        }
        changeStatus()
    }
    
    
    @IBAction func btnSelectAll(_ sender: UIButton) {
        if flgselectAll{
            btselectAll.setTitle("SELECT ALL", for: .normal)
            for item in Listimages{
                item.ischk = false
            }
            for item in ListVideos{
                item.ischk = false
            }
            btedit.setTitle("EDIT", for: .normal)
            flgedit = false
            flgselectAll = false
        }else{
            btselectAll.setTitle("DESELECT ALL", for: .normal)
            for item in Listimages{
                item.ischk = true
            }
            for item in ListVideos{
                item.ischk = true
            }
            btedit.setTitle("CANCEL", for: .normal)
            flgedit = true
            flgselectAll = true
           
        }
        colvwimages.reloadData()
        colvwvideos.reloadData()
        changeStatus()
    }
    
    func changeStatus(){
        if self.flgedit{
            UIView.animate(withDuration: 0.3) {
                self.vwheight.constant  = 55
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.vwheight.constant  = 0
            }
        }
        colvwimages.layoutIfNeeded()
        colvwvideos.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      self.showHide()
    }
    
    @IBAction func btnSelectVideo(_ sender: UIButton) {
//        imgFlg = false
//        btnSelectVideo_Action()
        let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.performSegue(withIdentifier: "rec", sender: nil)
            //            let VC = RecordVideoViewController()
            //            self.present(VC, animated: true, completion: nil)
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            self.imgFlg = false
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
    
    func showHide(){
        if Listimages.count == 0{
            self.lblimg.isHidden = false
            self.imgheight.constant = 50
        }else{
            if Listimages.count == 1 || Listimages.count == 2 || Listimages.count == 3{
                self.imgheight.constant = 150
            }else if Listimages.count == 3 || Listimages.count == 4 || Listimages.count == 5 {
                self.imgheight.constant = 260
            }else{
                self.imgheight.constant = 350
            }
            self.lblimg.isHidden = true
            
        }
        if ListVideos.count == 0{
            self.lblvd.isHidden = false
            self.videoheight.constant = 50
        }else{
            self.lblvd.isHidden = true
            self.videoheight.constant = 350
        }
        self.colvwvideos.layoutIfNeeded()
        self.colvwimages.layoutIfNeeded()
    }
    
    func userLoad(){
        if UserTapped == UserRoleKey.Follow.rawValue{
            btnimg.isHidden = true
            btnvideo.isHidden = true
        }else{
            btnimg.isHidden = false
            btnvideo.isHidden = false
        }
    }
 
}

extension MediaViewController: TatsiPickerViewControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated:true, completion: nil)
        DispatchQueue.main.async {
            let myurl = AppDelegate.baseurl+"api/lifestone/media"
            let para = [
                "ls_id":"\(objtofollow.id))"
            ]
            if imageView?.imageAsset == nil{
                alert3(view: self, msg: "Some thing wrong with image")
                return
            }
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
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset]) {
        imagesArr.removeAll()
        pickerViewController.dismiss(animated: true, completion: nil)
        print("Assets \(assets)")
         if self.imgFlg{
        DispatchQueue.main.async {
            for item in assets{
                self.imagesArr.append(self.getUIImage(asset: item)!)
            }
            let myurl = AppDelegate.baseurl+"api/lifestone/media"
            let para = [
                "ls_id":"\(objtofollow.id))"
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
            let myurl = AppDelegate.baseurl+"api/lifestone/media"
            let para = [
                "ls_id":"\(objtofollow.id)"
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

extension MediaViewController{

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
        config.maxNumberOfSelections = 5
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
        config.maxNumberOfSelections = 5
        self.imgFlg = false
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
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

////////////// Api calls ////////

extension MediaViewController{
    
    //////////////////////// GetData Function ?????????/
    func GetData()  {
        ListVideos.removeAll()
        Listimages.removeAll()
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/media/list"
        let parameters = [
            "ls_id":"\(objtofollow.id)"
        ]
        let headers = ["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
                        let arr = dic["message"]?.array ?? []
                        
                        for item in arr{
                            let obj = UserData()
                            obj.id = item["id"].int ?? 0
                            obj.imageURL = item["image_url"].string ?? ""
                            obj.lsID = item["ls_id"].int ?? 0
                            obj.thumbURL = item["thumb_url"].string ?? ""
                            obj.userID = item["user_id"].int ?? 0
                            obj.type = item["type"].string ?? ""
                            obj.created_at = item["created_at"].string ?? ""
                            if obj.type == "image"{
                                Listimages.append(obj)
                            }else{
                                ListVideos.append(obj)
                            }
                        }
                        SVProgressHUD.dismiss()
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        if Listimages.count>0 || ListVideos.count>0{
                            if UserTapped == UserRoleKey.Follow.rawValue{
                                self.btedit.isHidden = true
                            }else{
                                self.btedit.isHidden = false
                            }
                        }else{
                            self.btedit.isHidden = true
                        }
                        self.showHide()
                        self.colvwimages.reloadData()
                        self.colvwvideos.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
    }
    
    /////////////// upload [image] /////////////////////////
    
    func uploadImageData(inputUrl:String,parameters:[String:Any],imageFile : [UIImage],completion:@escaping(_:Any)->Void) {
        Alamofire.upload(multipartFormData:
            { (multipartFormData) in
            for imageDataa in imageFile
            {
                let imageData = imageDataa.jpegData(compressionQuality: 0.5)
//                let img = imageDataa.ResizeImageOriginalSize(targetSize: CGSize(width: 500, height: 500))
                let imageDataTumb = imageDataa.jpegData(compressionQuality: 1)
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
                            self.GetData()
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
//        let imageData = imageFile.jpegData(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for imageDataa in imageFile {
//                let imageData = imageDataa.jpegData(compressionQuality: 0.5)
//                let img = imageDataa.ResizeImageOriginalSize(targetSize: CGSize(width: 100, height: 100))
                let imageDataTumb = imageDataa.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageDataTumb!, withName: "thumbnail[]", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            }
            for item in videoUrl{
                multipartFormData.append("video".data(using: .utf8)!, withName: "type[]")
                multipartFormData.append(item, withName: "file[]", fileName: "Video\(arc4random_uniform(100)).mp4", mimeType: "mp4")
            }
            
//            multipartFormData.append(videoUrl, withName: "file", fileName: "Video\(arc4random_uniform(100)).mp4", mimeType: "mp4")
//            multipartFormData.append(imageData!, withName: "thumbnail", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            
            
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
                            self.GetData()
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
    
    func UserDeleteMedia(){
        
        var UserMedia: [Int] = []
        for item in Listimages {
            if item.ischk{
                UserMedia.append(item.id)
            }
        }
        for item in ListVideos {
            if item.ischk{
                UserMedia.append(item.id)
            }
        }
        if UserMedia.count == 0{
            alert3(view: self, msg: "No Item Selected to be deleted!")
            return
        }
        SVProgressHUD.show(withStatus: "Deleting...")
        let urlstring = AppDelegate.baseurl+"api/lifestone/media/delete"
        let parameters = [
            "ls_attachment":UserMedia
            ] as [String : Any]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
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
                        var temp:[UserData] = []
                        for item in Listimages{
                            if !item.ischk{
                                temp.append(item)
                            }
                        }
                        Listimages.removeAll()
                        for item in temp{
                            Listimages.append(item)
                        }
                        
                        var temp1:[UserData] = []
                        for item in ListVideos{
                            if !item.ischk{
                                temp1.append(item)
                            }
                        }
                        ListVideos.removeAll()
                        for item in temp1{
                            ListVideos.append(item)
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.btnedit(self.btedit)
                        self.changeStatus()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
  
}


extension MediaViewController{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.showHide()
        if collectionView == colvwimages{
            return Listimages.count
        }else{
            return ListVideos.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colvwimages{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! MediaImagesCollectionViewCell
           cell.img.sd_setImage(with: URL(string: Listimages[indexPath.row].imageURL.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
            cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
            
            if Listimages[indexPath.row].ischk{
                cell.chkimg.image = #imageLiteral(resourceName: "UnRbtn")
            }else{
                cell.chkimg.image = nil
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! MediaImagesCollectionViewCell
           cell.img.sd_setImage(with: URL(string: ListVideos[indexPath.row].thumbURL.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
            
            
            
            cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
            if ListVideos[indexPath.row].ischk{
                cell.chkimg.image = #imageLiteral(resourceName: "UnRbtn")
            }else{
                cell.chkimg.image = nil
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == colvwimages{
            if Listimages.count == 1 || Listimages.count == 2 || Listimages.count == 3{
                let cellSize = CGSize(width: ((collectionView.bounds.width/2-10)-(13.7 * 10)/2), height: 120)
                return cellSize
            }else if Listimages.count == 3 || Listimages.count == 4 || Listimages.count == 5{
                let cellSize = CGSize(width: ((collectionView.bounds.width/2-10)-(13.7 * 10)/2), height: 120)
                return cellSize
            }else{
                let cellSize = CGSize(width: ((collectionView.bounds.width/2-10)-(13.7 * 10)/2), height: ((collectionView.bounds.height/2)-(13.7 * 10)/2))
                return cellSize
            }
        }else{
            let cellSize = CGSize(width: ((collectionView.bounds.width/2-10)-(13.7 * 10)/2), height: ((collectionView.bounds.height/2)-(13.7 * 10)/2))
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        if collectionView == self.colvwimages{
            
            if flgedit{
                if Listimages[indexPath.row].ischk{
                    Listimages[indexPath.row].ischk = false
                }else{
                    Listimages[indexPath.row].ischk = true
                }
                self.colvwimages.reloadData()
            }else{
                MoveobjUserData = Listimages[indexPath.row]
                objdetailsFollow.movtoImageCmnt()
            }
        }
        if collectionView == self.colvwvideos{
            if flgedit{
                if ListVideos[indexPath.row].ischk{
                    ListVideos[indexPath.row].ischk = false
                }else{
                    ListVideos[indexPath.row].ischk = true
                }
                self.colvwvideos.reloadData()
            }else{
                MoveobjUserData = ListVideos[indexPath.row]
                objdetailsFollow.movtoImageCmnt()
            }
        }
    }
    
}


extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
