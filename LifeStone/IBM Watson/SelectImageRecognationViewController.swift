//
//  SelectImageRecognationViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 01/10/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var flgsearch = false
var searchtxt = ""
import UIKit
import Vision
import SVProgressHUD
import Alamofire
import SwiftyJSON
//import VisualRecognition
import MobileCoreServices
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos
import MLKit

class SelectImageRecognationViewController: UIViewController {

    @IBOutlet weak var btnse: UITapGestureRecognizer!
    var pickerController = UIImagePickerController()

//    lazy var vision = Vision.vision()
//    var textRecognizer: VisionTextRecognizer?
    let textRecognizer = TextRecognizer.textRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationChanged(){
        let deviceOrientation = UIDevice.current.orientation
        if deviceOrientation == UIDeviceOrientation.portraitUpsideDown {
        }
        else if deviceOrientation == UIDeviceOrientation.portrait {
        }
        else if deviceOrientation == UIDeviceOrientation.landscapeLeft {
        }
        else if deviceOrientation == UIDeviceOrientation.landscapeRight {
        }
    }
    
    @IBAction func btnScanImage(_ sender: UITapGestureRecognizer) {
        self.openCamera()
//        tapUserPhoto()
    }
    @IBAction func btnSearchLifeStone(_ sender: UITapGestureRecognizer) {
        flgsearch = true
//        search
        self.performSegue(withIdentifier: "search", sender: nil)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension SelectImageRecognationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        self.performSegue(withIdentifier: "goimg", sender: nil)
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
 
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //obtaining saving path
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagePath = documentsPath?.appendingPathComponent("image.jpg")
        // extract image from the picker and save it
        if var pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                pickedImage = pickedImage.fixImageOrientation()!
                let imageData = pickedImage.jpegData(compressionQuality: 0.75)
                try! imageData?.write(to: imagePath!)
                self.detectText(image: pickedImage) { (res) in

                    searchtxt = res
                    self.btnSearchLifeStone(self.btnse)
                    
                }
            }
        }
         dismiss(animated:true, completion: nil)
    }

}

extension SelectImageRecognationViewController{

    func detectText(image:UIImage,
    callback: @escaping (_ text: String) -> Void){
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
          guard error == nil, let result = result else {
            // Error handling
            callback("")
            return
          }
          // Recognized text
            print(result.text)
            print(result.blocks)
            callback(result.text)
        }
    }

}

