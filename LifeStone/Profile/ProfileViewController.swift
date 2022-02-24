//
//  ProfileViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 25/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtdob: UITextField!
    @IBOutlet weak var txtgender: UITextField!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    var depature = ""
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UserLoad()
        UserApear()
        dtp.maximumDate = Date()
        blurview.isHidden = true
        
    }
    
    func UserLoad(){
        vw2.setGradientBorder(Rect: CGRect(x: 2, y: 2, width: 95, height: 95), cornerRadius: 50, width: 3, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
    }
    
    func UserApear(){
        txtfname.text = AppDelegate.personalInfo.firstName.capitalized
        txtlname.text = AppDelegate.personalInfo.lastName.capitalized
        txtgender.text = AppDelegate.personalInfo.gender.capitalized
        txtdob.text = AppDelegate.personalInfo.dob
        userimage.sd_setImage(with: URL(string: AppDelegate.personalInfo.profileImage), placeholderImage: UIImage(named: "user"))
    }
    
    @IBAction func btndob(_ sender: UIButton) {
        self.view.endEditing(true)
        animatecenter(VC: self, Popview: popup)
        blurview.isHidden = false
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        let format1 = DateFormatter()
        format1.dateFormat = "dd-MM-yyyy"
        format1.timeZone = TimeZone.current
        depature = format1.string(from: dtp.date)
        txtdob.text = depature
        dtp.date = Date()
        blurview.isHidden = true
        popup.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        blurview.isHidden = true
        popup.isHidden = true
    }

    @IBAction func btnUpdate(_ sender: UIButton) {
        updateProfile()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func txtfirst(_ sender: Any) {
        txtlname.becomeFirstResponder()
    }
    @IBAction func txtLast(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func txtdate(_ sender: Any) {
        txtgender.becomeFirstResponder()
    }
    
    @IBAction func gender(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func genderTaped(_ sender: UITapGestureRecognizer) {
        showAlert(sender: sender)
    }
    
    @IBAction func btnUserTapedPhoto(_ sender: UIButton) {
        tapUserPhoto()
    }
    
}


extension ProfileViewController{
    
    func showAlert(sender: AnyObject) {
        let alert = UIAlertController(title: "Gender", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.txtgender.text = "Male"
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.txtgender.text = "Female"
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            self.txtgender.text = "Other"
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    ///////////////////////// updateProfile Function ?????????/
    func updateProfile()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        
        let last_name = txtlname.text!
        let gender = txtgender.text!
        let first_name = txtfname.text!
        let dob = txtdob.text!
        if first_name == ""{
            SVProgressHUD.dismiss()
            let message = "First name required"
            alert3(view: self, msg: message)
        }
        else if last_name == "" {
            SVProgressHUD.dismiss()
            let message = "Last name required"
            alert3(view: self, msg: message)
        }
        else if dob == ""{
            SVProgressHUD.dismiss()
            let message = "Date of birth required"
            alert3(view: self, msg: message)
        }
        else if gender == ""{
            SVProgressHUD.dismiss()
            let message = "Gender required"
            alert3(view: self, msg: message)
        }
        else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if dateFormatter.date(from: dob) != nil {
                print("date is valid")
            }
            else {
                SVProgressHUD.dismiss()
                let message = "Date of birth with invalid format"
                alert3(view: self, msg: message)
                return
            }
            let urlstring = AppDelegate.baseurl+"api/profile/update"
            let parameters = [
                "last_name":"\(last_name)",
                "gender":"\(gender)",
                "first_name":"\(first_name)",
                "dob":"\(dob)"
            ]
            let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
            Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                : JSONEncoding.default,headers: headers).responseJSON { response in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.boolValue ?? false
                        if success {
                            let user = dic["user"]?.dictionaryValue ?? [:]
                            print(AppDelegate.personalInfo.token)
                            print(user)
                            AppDelegate.personalInfo.id = String(user["id"]?.int ?? 0)
                            AppDelegate.personalInfo.email = user["email"]?.stringValue ?? ""
                            AppDelegate.personalInfo.phoneNumber = user["phone_number"]?.stringValue ?? ""
                            AppDelegate.personalInfo.firstName = user["first_name"]?.stringValue ?? ""
                            AppDelegate.personalInfo.lastName = user["last_name"]?.stringValue ?? ""
                            AppDelegate.personalInfo.dob = user["dob"]?.stringValue ?? ""
                            AppDelegate.personalInfo.status = user["status"]?.stringValue ?? ""
                            AppDelegate.personalInfo.city = user["city"]?.stringValue ?? ""
                            AppDelegate.personalInfo.gender = user["gender"]?.stringValue ?? ""
                            AppDelegate.personalInfo.profileImage = user["profile_image"]?.stringValue ?? ""
                            Save_UD(info: AppDelegate.personalInfo)
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        else{
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
        }
    }

}




extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //// user tapped to change photo//////
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
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerController.SourceType.camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else {
            let message = "There is some thing wrong with camera"
            alert(view: self, msg: message)
            
        }
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userimage.contentMode = .scaleAspectFill
        userimage.image = imageView!
        dismiss(animated:true, completion: nil)
        //        let Userimage = imageView!
        let myurl = AppDelegate.baseurl+"api/profile/image"
        let para = [
            "user_id":"\(AppDelegate.personalInfo.id))"
            //"profile_image" : "\(Userimage)"
        ]
        self.uploadImageData(inputUrl: myurl, parameters: para, imageName: "profile_image", imageFile: imageView!) { (sec) in
            print(sec)
        }
        
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    /////////////// upload image /////////////////////////
    
    func uploadImageData(inputUrl:String,parameters:[String:Any],imageName: String,imageFile : UIImage,completion:@escaping(_:Any)->Void) {
        //        let imageData = UIImageJPEGRepresentation(imageFile , 0.5)
        let imageData = imageFile.jpegData(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: imageName, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
//            for key in parameters.keys{
//                let name = String(key)
//                if let val = parameters[name] as? String{
//                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
//                }
//            }
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    SVProgressHUD.dismiss()
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
                        }
                        else{
                            let message = dic["message"]?.stringValue ?? ""
                            alert(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                            self.userimage.sd_setImage(with: URL(string: AppDelegate.personalInfo.profileImage), placeholderImage: UIImage(named: "user"))
                        }
                    case .failure(let error):
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


}
