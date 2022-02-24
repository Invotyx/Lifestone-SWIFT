//
//  VerifyAccountViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 16/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class VerifyAccountViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var btnRe: UIButton!
    @IBOutlet weak var t4: UITextField!
    @IBOutlet weak var t3: UITextField!
    @IBOutlet weak var t2: UITextField!
    @IBOutlet weak var t1: UITextField!
    @IBOutlet weak var viewbtm: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnRe.underline()
    }
    @IBAction func btnCross(_ sender: UIButton) {
        goback()
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func goback()
    {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnverify(_ sender: UIButton) {
        verify()
    }
    @IBAction func btnResend(_ sender: UIButton) {
        CreateNewUser()
    }
    
}




extension VerifyAccountViewController{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.textAlignment = .center
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed\(String(describing: textField.text?.count))")
            if textField.text?.count == 1{
                DispatchQueue.main.async {
                    self.MangeTxt(feild: textField)
                }
            }
            return true
        }
        if (textField.text?.count)! >= 1{
            textField.text = ""
            DispatchQueue.main.async {
                self.MangeTxtF(feild: textField)
                
            }
            return true
        }
        else{
            if textField.text?.count == 0{
                DispatchQueue.main.async {
                    self.MangeTxtF(feild: textField)
                }
            }
        }
        
        return true
    }
    
    func MangeTxt(feild:UITextField)  {
        feild.textAlignment = .center
        switch feild {
        case t1:
            print("df")
        case t2:
            print("df")
            t1.becomeFirstResponder()
        case t3:
            print("df")
            t2.becomeFirstResponder()
        case t4:
            print("df")
            t3.becomeFirstResponder()
        default:
            print("df")
            self.view.endEditing(true)
        }
    }
    
    func MangeTxtF(feild:UITextField)  {
        feild.textAlignment = .center
        switch feild {
        case t1:
            print("df")
            t2.becomeFirstResponder()
            t2.text = ""
        case t2:
            print("df")
            t3.becomeFirstResponder()
            t3.text = ""
        case t3:
            print("df")
            t4.becomeFirstResponder()
            t4.text = ""
        case t4: break
        default:
            print("df")
            self.view.endEditing(true)
        }
    }
    
    //////////////////////// UserLogin Function ?????????/
    func CreateNewUser()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/signup"
        let parameters = [
                    "email":"\(Semail)",
                    "password":"\(Spass)"
                ]
        print(parameters)
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
    
    ///////////////////////// verify Function ?????????/
    func verify()  {
        
        let mt1 = t1.text!
        let mt2 = t2.text!
        let mt3 = t3.text!
        let mt4 = t4.text!
        
        if mt1 != ""{
            if mt2 != ""{
                if mt3 != ""{
                    if mt4 != ""{
                        let txt = "\(mt1)\(mt2)\(mt3)\(mt4)"
                        SVProgressHUD.show(withStatus: "Loading")
                        let urlstring = AppDelegate.baseurl+"api/verify/account"
                        let parameters = [
                            "verification_code":"\(txt)"
                        ]
                        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                            : JSONEncoding.default,headers: nil).responseJSON { response in
                                print(response.request as Any)  // original URL request
                                print(response.response as Any) // URL response
                                print(response.data as Any)     // server data
                                print(response.result)   // result of response serialization
                                switch response.result {
                                case .success:
                                    let json = JSON(response.result.value!)
                                    let dic = json.dictionaryValue
                                    print(dic)
                                    let success = dic["success"]?.bool ?? false
                                    if success {
                                        SVProgressHUD.dismiss()
                                      
                                        let data = dic["data"]?.dictionaryValue ?? [:]
                                        let user = data["user"]?.dictionaryValue ?? [:]
                                        AppDelegate.personalInfo.token = data["token"]?.stringValue ?? ""
                                        print(AppDelegate.personalInfo.token)
                                        print(data)
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
                                        
                                      
                                        self.performSegue(withIdentifier: "lets", sender: nil)
                                    }
                                    else{
                                        SVProgressHUD.dismiss()
                                        let message = dic["message"]?.stringValue ?? ""
                                        alert3(view: self, msg: message)
                                    }
                                    
                                case .failure(let error):
                                    SVProgressHUD.dismiss()
                                    print(error.localizedDescription)
                                }
                        }
                    }
                    else{
                        alert3(view: self, msg: "Please enter provided code and then press verify")
                    }
                }
                else{
                    alert3(view: self, msg: "Please enter provided code and then press verify")
                }
            }
            else{
                alert3(view: self, msg: "Please enter provided code and then press verify")
            }
        }
        else{
            alert3(view: self, msg: "Please enter provided code and then press verify")
        }
        
    }
    
}
