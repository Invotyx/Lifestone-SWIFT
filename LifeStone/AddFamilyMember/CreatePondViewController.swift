//
//  CreatePondViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 27/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage

class CreatePondViewController: UIViewController {

    var base64str = ""
    var pickerController = UIImagePickerController()
    var dob = ""
    var depature = ""
    var flgd = false
    @IBOutlet weak var vwheight: NSLayoutConstraint!
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lbldob: UILabel!
    @IBOutlet weak var lbldeparture: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var btndep: UIButton!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var btnheight: NSLayoutConstraint!
    @IBOutlet weak var `switch`: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if flgedittree{
            `switch`.isHidden = false
            vwheight.constant = 50
            btnheight.constant = 31
            txtfname.text = datatosnd.f_name
            txtlname.text = datatosnd.l_name
            txtEmail.text = datatosnd.email
            txtAbout.text = datatosnd.about
            
            
            var  arr = datatosnd.dob.split(separator: "-")
            var arr1 = arr.reversed()
            var finalstr = ""
            for (i,item)  in arr1.enumerated(){
                if i == arr1.count-1{
                    finalstr = finalstr+"\(item)"
                }else{
                     finalstr = finalstr+"\(item)-"
                }
            }
            lbldob.text = finalstr
            dob = finalstr
            
            arr = datatosnd.departure_date.split(separator: "-")
            arr1 = arr.reversed()
            finalstr = ""
            for (i,item)  in arr1.enumerated(){
                if i == arr1.count-1{
                    finalstr = finalstr+"\(item)"
                }else{
                    finalstr = finalstr+"\(item)-"
                }
            }
            lbldeparture.text = finalstr
            depature = finalstr
           self.img.sd_setImage(with: URL(string:  datatosnd.image.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
            self.base64str = ConvertImageToBase64String(img: self.img.image!)
            
            if datatosnd.departure_date == ""{
                btndep.isUserInteractionEnabled = false
            }else{
                btndep.isUserInteractionEnabled = true
            }
            
        }else{
             `switch`.isHidden = true
             btnheight.constant = 0
            vwheight.constant = 0
            if flgAlive{
                btndep.isUserInteractionEnabled = false
            }else{
                btndep.isUserInteractionEnabled = true
            }
        }
        
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        dtp.maximumDate = Date()
    }
    
    @objc func tap(){
         self.view.endEditing(true)
    }
    
    @IBAction func btnAlive(_ sender: UISwitch) {
        if datatosnd.is_alive == 1{
            datatosnd.is_alive = 0
        }else{
            datatosnd.is_alive = 1
        }
    }
    
 
    @IBAction func btndob(_ sender: UIButton) {
        self.view.endEditing(true)
        animatecenter(VC: self, Popview: popup)
        flgd = false
    }
    @IBAction func btnDeparture(_ sender: UIButton) {
        self.view.endEditing(true)
        animatecenter(VC: self, Popview: popup)
        flgd = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        if flgd{
            let format1 = DateFormatter()
            format1.dateFormat = "dd-MM-yyyy"
            format1.timeZone = TimeZone.current
            depature = format1.string(from: dtp.date)
            lbldeparture.text = depature
        }else{
            let format1 = DateFormatter()
            format1.dateFormat = "dd-MM-yyyy"
            format1.timeZone = TimeZone.current
            dob = format1.string(from: dtp.date)
            lbldob.text = dob
        }
        dtp.date = Date()
        popup.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        popup.isHidden = true
    }
    
    @IBAction func tapphoto(_ sender: UITapGestureRecognizer){
        tapUserPhoto()
    }
    
    @IBAction func btnAddPond(_ sender: UIButton) {
        if flgedittree{
            UpdatePond()
        }else{
             CreatePond()
        }
    }
    
}

////// Image selection //////////
extension CreatePondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    //////////////////////// UpdatePond Function ?????????/
    func UpdatePond()  {
        
        if base64str == ""
        {
            
            return
        }
        
        if txtfname.text! == ""{
            return
        }
        if txtlname.text! == ""{
            return
        }
        if txtEmail.text! == ""{
            return
        }
        if dob == ""{
            return
        }
        
        
        if txtAbout.text! == ""{
            return
        }
        
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/tree/update"
        let parameter = ["individual_id":"\(datatosnd.id)",
            "f_name":"\(txtfname.text!)",
            "l_name":"\(txtlname.text!)",
            "gender":"",
            "dob":"\(dob)",
            "is_alive":"\(datatosnd.is_alive)",
            "about":"\(txtAbout.text!)",
            "departue_date":"\(depature)",
            "image": "data:image/png;base64,\(base64str)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameter, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
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
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
    }
    
    //////////////////////// CreatePond Function ?????????/
    func CreatePond()  {
        
        if base64str == ""
        {
            alert3(view: self, msg: "Upload Image")
            return
        }
        
        if txtfname.text! == ""
        {
            alert3(view: self, msg: "first name required!")
            return
        }
        if txtlname.text! == ""
        {
            alert3(view: self, msg: "last name required!")
            return
        }
        if txtEmail.text! == ""{
            alert3(view: self, msg: "Email required!")
            return
        }
        if dob == ""{
            alert3(view: self, msg: "Select date of birth")
            return
        }
        
        if txtAbout.text! == ""{
            alert3(view: self, msg: "Some thing about this person required!")
            return
        }
        
        
        var a = -1
        if flgAlive{
            a = 1
        }else{
            a = 0
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/tree/add"
        let parameter = ["referral_id":"\(datatosnd.id)",
                         "f_name":"\(txtfname.text!)",
                         "l_name":"\(txtlname.text!)",
                         "gender":"",
                         "dob":"\(dob)",
                         "email": "\(txtEmail.text!)",
                         "role_id":"\(seleRelation.id)",
                         "is_alive":"\(a)",
                         "about":"\(txtAbout.text!)",
                         "departue_date":"\(depature)",
                         "image": "data:image/png;base64,\(base64str)"]
          let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameter, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
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
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
    }
    
    
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
        DispatchQueue.main.async {
            var imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            imageView = self.resizeImage(image: imageView!, targetSize: CGSize(width: 500, height: 500))
            self.img.contentMode = .scaleAspectFill
            self.img.image = imageView!
            self.base64str = ConvertImageToBase64String(img: self.img.image!)
            self.dismiss(animated:true, completion: nil)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        ScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero //UIEdgeInsetsZero
        ScrollView.contentInset = contentInset
    }
    
}



