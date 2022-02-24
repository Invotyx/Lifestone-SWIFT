//
//  ContactUsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 28/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage
class ContactUsViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate  {
    
    @IBOutlet weak var txtname: WajihTextField!
    @IBOutlet weak var txtemail: WajihTextField!
    @IBOutlet weak var txtmessage: UITextView!
    @IBOutlet weak var txtabout: WajihTextField!
    
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblmessage: UILabel!
    @IBOutlet weak var lblabout: UILabel!
    
    @IBOutlet weak var vwname: UIView!
    @IBOutlet weak var vwemail: UIView!
    @IBOutlet weak var vwmessage: UIView!
    @IBOutlet weak var vwabout: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resetBorder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnsend(_ sender: UIButton) {
        if txtname.text == ""{
            return
        }
        if txtemail.text == ""{
            return
        }
        if txtmessage.text == ""{
            return
        }
        if txtabout.text == ""{
            return
        }
        if txtmessage.text == "Type your message"{
            return
        }
        let flgvalid = txtemail.text?.isValidEmail()
        if !flgvalid!{
            return
        }
        Send()
    }
    @IBAction func btnback(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetBorder(){
        
        vwname.alpha = 0
        vwemail.alpha = 0
        vwmessage.alpha = 0
         vwabout.alpha = 0
        
        lblname.alpha = 0
        lblemail.alpha = 0
        lblmessage.alpha = 0
        lblabout.alpha = 0
        
        vwname.layer.borderColor = UIColor.black.cgColor
        vwemail.layer.borderColor = UIColor.black.cgColor
        vwmessage.layer.borderColor = UIColor.black.cgColor
        vwabout.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField == txtmessage{
            print(textField.text ?? "")
//            textField.textColor = UIColor.black
            if textField.text != "Type your message"{
                txtmessage.text = textField.text
            }
            else{
                txtmessage.text = ""
            }
            vwmessage.layer.borderColor = UIColor.white.cgColor
            lblmessage.textColor = UIColor.white
            self.lblmessage.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblmessage.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblmessage.alpha = 1
                self.vwmessage.alpha = 1
                self.lblmessage.transform = .identity
            }) { (true) in
            }
        }
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtmessage{
            if textView.text != ""{
                txtmessage.text = textView.text
            }
            else{
                txtmessage.text = "Type your message"
            }
        }
      resetBorder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtname{
            vwname.layer.borderColor = UIColor.white.cgColor
            lblname.textColor = UIColor.white
            
            textField.placeholder = ""
            self.lblname.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblname.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblname.alpha = 1
                self.vwname.alpha = 1
                self.lblname.transform = .identity
            }) { (true) in
            }
        }
        
        if textField == txtemail{
            vwemail.layer.borderColor = UIColor.white.cgColor
            lblemail.textColor = UIColor.white
            
            textField.placeholder = ""
            self.lblemail.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblemail.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblemail.alpha = 1
                self.vwemail.alpha = 1
                self.lblemail.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtabout{
            vwabout.layer.borderColor = UIColor.white.cgColor
            lblabout.textColor = UIColor.white
            
            textField.placeholder = ""
            self.lblabout.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblabout.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblabout.alpha = 1
                self.vwabout.alpha = 1
                self.lblabout.transform = .identity
            }) { (true) in
            }
        }
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtname{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Type your name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtabout{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "About",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtemail{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Type you E-mail address",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
      
        resetBorder()
    }
  
    //////////////////////// Send Function ?????????/
    func Send()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/contact"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        let parameters = ["name":"\(txtname.text!)",
                          "email":"\(txtemail.text!)",
                          "subject":"\(txtabout.text!)",
                          "text":"\(txtmessage.text!)"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
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
    
}
