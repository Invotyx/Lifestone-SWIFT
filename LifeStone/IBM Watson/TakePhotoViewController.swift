//
//  ViewController.swift
//  ObjectRecognation
//
//  Created by Wajih Invotyx on 20/11/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

var cntr = 0
var flg = false


import UIKit
import AVKit
import Vision
import MobileCoreServices
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos
import MLKit

class TakePhotoViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{

    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var lblname: UILabel!
    
//    lazy var vision = Vision.vision()
//    var textRecognizer: VisionTextRecognizer?
    
    let textRecognizer = TextRecognizer.textRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        vw.layer.addSublayer(previewlayer)
        previewlayer.frame = vw.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        captureSession.addOutput(dataOutput)
        
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        searchtxt = ""
        cntr = 0
        flg = false
    }
    
    @IBAction func btnReset(_ sender: UIButton) {
        searchtxt = ""
        cntr = 0
        flg = false
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
      
        DispatchQueue.main.async {
            cntr += 1
            if cntr != 50{
                return
            }
            if searchtxt == ""{
                cntr = 0
                flg = false
            }
            if flg{
                flg = true
                return
            }
            let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
            var image : UIImage = self.convert(cmage: ciimage)
            image = image.fixImageOrientation()!
//            let str = self.detectText(image: image)
            if image.imageAsset == nil{
                alert3(view: self, msg: "Some thing wrong with image")
                return
            }
            self.detectText(image: image) { (res) in
                self.lblname.text = res
                searchtxt = res

                DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                    if searchtxt==""{
                        return
                    }
                    flgsearch = true
                    let message = "Scanned text: "+searchtxt+"\nDo you want to search this text?"
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        self.performSegue(withIdentifier: "search", sender: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
                        searchtxt = ""
                        self.lblname.text = ""
                        cntr = 0
                        flg = false
//                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    })

            }
        }
    }
 
    // Convert CIImage to CGImage
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
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


extension UIImage {
    
    
    func fixImageOrientation() -> UIImage? {
        var fixedImage = self
        //check current orientation of original image
        switch self.imageOrientation {
        case .down:
            fixedImage = imageRotatedByDegrees(oldImage: self, deg: -180)
            break
        case .left:
            fixedImage = imageRotatedByDegrees(oldImage: self, deg: -90)
            break
        case .right:
            fixedImage = imageRotatedByDegrees(oldImage: self, deg: 90)
            break
        case .up:
            fixedImage = imageRotatedByDegrees(oldImage: self, deg: 90)
             break
        case .upMirrored:

            break
        case .downMirrored:

            break
        case .leftMirrored:

            break
        case .rightMirrored:

            break
        @unknown default:
            print("some thing went wrong")
        }

        return fixedImage
    }

    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        let size = oldImage.size

        UIGraphicsBeginImageContext(size)

        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)

        bitmap.draw(oldImage.cgImage!, in: CGRect(origin: origin, size: size))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
