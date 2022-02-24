//
//  ChangePasswordViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 31/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var txtCurrent: UITextField!
    @IBOutlet weak var txtnew: UITextField!
    @IBOutlet weak var txtconfrm: UITextField!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    var flgpass = true
    var flgnew = true
    var flgcnfrm = true

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        if UserDefaults.standard.bool(forKey: "Social") == true
        {
            alert3(view: self, msg: "Account is registered through Social Login, please change your password through that Scoial platform.")
        }
    }
    
    @IBAction func btnShowPass(_ sender: UIButton) {
        if flgpass{
            btn1.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            txtCurrent.isSecureTextEntry = false
            flgpass = false
        }else{
            btn1.setImage(#imageLiteral(resourceName: "eyehide"), for: .normal)
            txtCurrent.isSecureTextEntry = true
            flgpass = true
        }
    }
    
    @IBAction func btnshowNew(_ sender: UIButton) {
        if flgnew{
            btn2.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            txtCurrent.isSecureTextEntry = false
            flgnew = false
        }else{
            btn2.setImage(#imageLiteral(resourceName: "eyehide"), for: .normal)
            txtCurrent.isSecureTextEntry = true
            flgnew = true
        }
    }
    
    @IBAction func btnShowCnfrm(_ sender: UIButton) {
        if flgcnfrm{
            btn3.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            txtconfrm.isSecureTextEntry = false
            flgcnfrm = false
        }else{
            btn3.setImage(#imageLiteral(resourceName: "eyehide"), for: .normal)
            txtconfrm.isSecureTextEntry = true
            flgcnfrm = true
        }
    }
    
    @IBAction func txt1(_ sender: Any) {
        txtnew.becomeFirstResponder()
    }
    
    @IBAction func txt2(_ sender: Any) {
        txtconfrm.becomeFirstResponder()
    }
    
    @IBAction func txt3(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnChange(_ sender: Any) {
        SetPassword()
    }
    
    @IBAction func btncross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ChangePasswordViewController{
    
    ///////////////////////// SetPassword User Function ?????????/
    func SetPassword()  {
        
        let c = self.txtCurrent.text!
        let ne = self.txtnew.text!
        let cnf = self.txtconfrm.text!
        
        if c != AppDelegate.personalInfo.pass{
            let message = "Current password miss matched"
            alert3(view: self, msg: message)
        }
        
        if c != ""{
            if ne != ""{
                if cnf != ""{
                    
                    let urlstring = AppDelegate.baseurl+"api/profile/password/update"
                    let parameters = [
                        "current_password":"\(c)",
                        "new_password":"\(ne)",
                        "confirm_password":"\(cnf)"
                    ]
                    let headers = ["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
                    
                    Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                        : JSONEncoding.default,headers: headers).responseJSON { response in
                            switch response.result {
                            case .success:
                                let json = JSON(response.result.value!)
                                let dic = json.dictionaryValue
                                print(dic)
                                let success = dic["success"]?.bool ?? false
                                if success {
                                    let message = dic["message"]?.stringValue ?? ""
                                    alert3(view: self, msg: message)
                                    AppDelegate.personalInfo.pass = cnf
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
                } // cnf if
                else{
                    let message = "Conform password field is required"
                    alert3(view: self, msg: message)
                }
            }// ne if
            else{
                let message = "New password field is required"
                alert3(view: self, msg: message)
            }
        }  // c if
        else{
            let message = "Current password field is required"
            alert3(view: self, msg: message)
        }
    }
    
}
