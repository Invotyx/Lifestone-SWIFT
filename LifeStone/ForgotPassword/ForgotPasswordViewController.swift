//
//  ForgotPasswordViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var lblmail: UILabel!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var Blurview: UIVisualEffectView!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      UserLoad()
    }
    
    func UserLoad(){
        vw1.layer.cornerRadius = 25
        vw1.layer.borderWidth = 0.8
        vw1.layer.borderColor = UIColor.black.cgColor
        Blurview.isHidden = true
        
        self.vw2.alpha = 0
        self.lblmail.alpha = 0
    }
  
    @IBAction func btnCross(_ sender: UIButton) {
        goback()
    }
    @IBAction func btnsend(_ sender: UIButton) {
        userforgot()
    }
    
    func goback(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnok(_ sender: UIButton) {
        popup.isHidden = true
        Blurview.isHidden = true
    }
    
    @IBAction func tapgest(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
}







extension ForgotPasswordViewController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtemail{
            textField.placeholder = ""
            vw1.layer.borderColor = UIColor.white.cgColor
            lblmail.textColor = UIColor.white
            self.lblmail.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblmail.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblmail.alpha = 0.6
                self.vw2.alpha = 1
                self.lblmail.transform = .identity
            }) { (true) in
            }
            
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtemail{
            vw1.layer.borderColor = UIColor.black.cgColor
            lblmail.textColor = UIColor.black
            self.vw2.alpha = 0
            self.lblmail.alpha = 0
            if textField.text == ""{
                //                txtemail.placeholder = "Email"
                textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        
    }
    
    
    ///////////////////////// UserLogin Function ?????????/
    func userforgot()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        
        let email = txtemail.text!
        
        if email == "" {
            SVProgressHUD.dismiss()
            let message = "Email required"
            alert(view: self, msg: message)
            
        }
        else{
            let flg = email.isValidEmail()
            
            if flg  {
                
                let urlstring = AppDelegate.baseurl+"api/forgot/password"
                let parameters = [
                    "email":"\(String(describing: email))"
                ]
                
                Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                    : JSONEncoding.default,headers: nil).responseJSON { response in
                        switch response.result {
                        case .success:
                            let json = JSON(response.result.value!)
                            let dic = json.dictionaryValue
                            print(dic)
                            let success = dic["success"]?.boolValue ?? false
                            if success == true {
                                let data = dic["data"]?.dictionaryValue ?? [:]
                                let user = data["user"]?.dictionaryValue ?? [:]
                                print(data)
                                print(user)
                                SVProgressHUD.dismiss()
                                //                                let message = dic["message"]?.stringValue ?? ""
                                //                                alert3(view: self, msg: message)
                                self.Blurview.isHidden = false
                                animatecenter(VC: self, Popview: self.popup)
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
                let message = "Please enter vaild email"
                alert3(view: self, msg: message)
            }
        }
    }
}
