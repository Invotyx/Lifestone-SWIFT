//
//  SignUpViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 16/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var Semail = ""
var Spass = ""
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignUpViewController: UIViewController,UITextFieldDelegate {

    var flgpass = true
    var flgcnfrm = true
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtconfirmpass: UITextField!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var lblm: UILabel!
    @IBOutlet weak var lblp: UILabel!
    @IBOutlet weak var lblcn: UILabel!
    
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var vw6: UIView!
    @IBOutlet weak var vvw7: UIView!
    
    @IBOutlet weak var btnsi: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    btnsi.underline()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        resetAll()
        txtconfirmpass.placeholder = "Confirm Password"
             txtpassword.placeholder = "Password"
             txtemail.placeholder = "Email"
    }

    
    @IBAction func btnshowpass(_ sender: UIButton) {
        if flgpass{
            btn1.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            txtpassword.isSecureTextEntry = false
            flgpass = false
        }else{
            btn1.setImage(#imageLiteral(resourceName: "eyehide"), for: .normal)
            txtpassword.isSecureTextEntry = true
            flgpass = true
        }
    }
    
    @IBAction func btnShowCnfrm(_ sender: UIButton) {
        if flgcnfrm{
            btn2.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            txtconfirmpass.isSecureTextEntry = false
            flgcnfrm = false
        }else{
            btn2.setImage(#imageLiteral(resourceName: "eyehide"), for: .normal)
            txtconfirmpass.isSecureTextEntry = true
            flgcnfrm = true
        }
    }
    
    @IBAction func btnCross(_ sender: UIButton) {
        goback()
    }
    
    @IBAction func btnsignin(_ sender: UIButton) {
        goback()
    }
    
    func goback()
    {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func txtmail(_ sender: UITextField) {
        txtpassword.becomeFirstResponder()
    }
    
    @IBAction func txtpass(_ sender: UITextField) {
        txtconfirmpass.becomeFirstResponder()
    }
    
    @IBAction func txtconfirm(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSignup(_ sender: UIButton) {
        CreateNewUser()
    }
    
}






extension SignUpViewController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtemail{
            vw2.layer.borderColor = UIColor.white.cgColor
            lblm.textColor = UIColor.white
            textField.placeholder = ""
            self.lblm.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblm.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblm.alpha = 0.6
                self.vw5.alpha = 1
                self.lblm.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtpassword{
            vw3.layer.borderColor = UIColor.white.cgColor
            lblp.textColor = UIColor.white
            textField.placeholder = ""
            self.lblp.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblp.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblp.alpha = 0.6
                self.vw6.alpha = 1
                self.lblp.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtconfirmpass{
            vw4.layer.borderColor = UIColor.white.cgColor
            lblcn.textColor = UIColor.white
            textField.placeholder = ""
            self.lblcn.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblcn.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblcn.alpha = 0.6
                self.vvw7.alpha = 1
                self.lblcn.transform = .identity
            }) { (true) in
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField == txtemail{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
            vw2.layer.borderColor = UIColor.black.cgColor
            lblm.textColor = UIColor.black
        }
        if textField == txtpassword{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
            vw3.layer.borderColor = UIColor.black.cgColor
            lblp.textColor = UIColor.black
        }
        if textField == txtconfirmpass{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
            vw4.layer.borderColor = UIColor.black.cgColor
            lblcn.textColor = UIColor.black
        }
        self.vw5.alpha = 0
        self.vw6.alpha = 0
        self.lblm.alpha = 0
        self.lblp.alpha = 0
        self.vvw7.alpha = 0
        self.lblcn.alpha = 0
    }
    
    func resetAll(){
        self.vw2.alpha = 1
        self.vw3.alpha = 1
        self.vw4.alpha = 1
        self.vw5.alpha = 0
        self.vw6.alpha = 0
        self.lblm.alpha = 0
        self.lblp.alpha = 0
        self.vvw7.alpha = 0
        self.lblcn.alpha = 0
        txtconfirmpass.text = ""
        txtpassword.text = ""
        txtemail.text = ""
    }
}









extension SignUpViewController{
    //////////////////////// UserLogin Function ?????????/
    func CreateNewUser()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let email = txtemail.text!
        let password = txtpassword.text!
        Semail = txtemail.text!
        Spass = txtpassword.text!
        let phn_no = txtconfirmpass.text!
        if email == ""{
            SVProgressHUD.dismiss()
            let message = "User email required"
            alert3(view: self, msg: message)
        }
        else if password == ""{
            SVProgressHUD.dismiss()
            let message = "Password required"
            alert3(view: self, msg: message)
        }
        else if phn_no != password{
            SVProgressHUD.dismiss()
            let message = "Password does not matched"
            alert3(view: self, msg: message)
        }
        else{
            let flg = email.isValidEmail()
            
            if flg {
                
                let urlstring = AppDelegate.baseurl+"api/signup"
                let parameters = [
                    "email":"\(String(describing: email))",
                    "password":"\(String(describing: password))"
                ]
                
                let headers = ["Accept":"application/json"]
                Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                    : JSONEncoding.default,headers: headers).responseJSON { response in
                        switch response.result {
                        case .success:
                            let json = JSON(response.result.value!)
                            let dic = json.dictionaryValue
                            print(dic)
                            let success = dic["success"]?.boolValue ?? false
                            if success {
                               
                                let data = dic["data"]?.dictionaryValue ?? [:]
                                let user = data["user"]?.dictionaryValue ?? [:]
                                AppDelegate.personalInfo.token = data["token"]?.stringValue ?? ""
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
                                AppDelegate.personalInfo.lifestones_count = String(user["lifestones_count"]?.int ?? 0)
                                AppDelegate.personalInfo.charities_count = String(user["charities_count"]?.int ?? 0)
                                AppDelegate.personalInfo.subscription = user["subscription"]?.stringValue ?? ""
                                AppDelegate.personalInfo.created_at = user["created_at"]?.stringValue ?? ""
                                AppDelegate.personalInfo.display_image = user["display_image"]?.stringValue ?? ""
                                
                                Save_UD(info: AppDelegate.personalInfo)
                                self.performSegue(withIdentifier: "verify", sender: nil)
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
            }
            else{
                SVProgressHUD.dismiss()
                let message = "Please enter valid email"
                alert3(view: self, msg: message)
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
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
