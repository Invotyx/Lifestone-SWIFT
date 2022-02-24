//
//  RecordVideoViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 23/10/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SwiftyCam
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AVKit
import AVFoundation

class RecordVideoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    @IBOutlet weak var captureButton    : SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton : UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    
    var VideosArr: [URL] = []
    var imgthumb: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 50.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: .normal)
        captureButton.buttonEnabled = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
//        let newVC = PhotoViewController(image: photo)
//        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
//        let newVC = VideoViewController(videoURL: url)
//        self.present(newVC, animated: true, completion: nil)
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Compressing...")
            self.VideosArr.removeAll()
            self.imgthumb.removeAll()
            if url.absoluteString == ""{
                return
            }
            self.StartComp(assets: [url], count: 0)
        }
    }
    
    func StartComp(assets:  [URL],count:Int){
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
        //        assets[count].getURL(completionHandler: { (res) in
        //            print(res!)
            self.compressvideo(res: assets[count], completion: { (resFlag) in
            if resFlag{
                self.StartComp(assets: assets, count: count+1)
                }
            else{
                self.StartComp(assets: assets, count: count+1)
                }
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
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        //flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
}


// UI Animations
extension RecordVideoViewController {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func toggleFlashAnimation() {
        //flashEnabled = !flashEnabled
        if flashMode == .auto{
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
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
                            self.dismiss(animated: true, completion: nil)
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

