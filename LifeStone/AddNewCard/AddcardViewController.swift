//
//  AddcardViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON
import Alamofire
import SVProgressHUD

class AddcardViewController: UIViewController,UITextFieldDelegate {

    var dob = ""
    var depature = ""
    var Cardtoken = ""
    @IBOutlet weak var txtexpiry: UITextField!
    @IBOutlet weak var txtcvc: UITextField!
    @IBOutlet weak var txtcardNumber: UITextField!
    @IBOutlet weak var txtcardholdr: UITextField!
    
    @IBOutlet var popup: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var Exp: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dtp.minimumDate = Date()
        dtp.setValue(UIColor.white, forKey: "textColor")
        txtcardNumber.delegate = self
    }
    
    @IBAction func btndob(_ sender: UIButton) {
        self.view.endEditing(true)
       
        blurView.isHidden = false
        animatecenter(VC: self, Popview: popup)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        let format1 = DateFormatter()
        format1.dateFormat = "MM/yyyy"
        format1.timeZone = TimeZone.current
        dob = format1.string(from: dtp.date)
        txtexpiry.text = dob
        dtp.date = Date()
        popup.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        blurView.isHidden = true
        popup.isHidden = true
    }
    

    @IBAction func btnCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TxtHolder(_ sender: UITextField) {
        txtcardNumber.becomeFirstResponder()
    }
    
    @IBAction func txtNumber(_ sender: Any) {
        txtcvc.becomeFirstResponder()
    }
    
    @IBAction func txtCV(_ sender: Any) {
        self.view.endEditing(true)
//        txtexpiry.becomeFirstResponder()
    }
    
    @IBAction func txtDate(_ sender: Any) {
         self.view.endEditing(true)
    }
    
    @IBAction func btnPay(_ sender: UIButton) {
        
        if txtcardholdr.text == ""{
            alert3(view: self, msg: "Please enter card holder name")
            return
        }
        if txtcardNumber.text == ""{
            alert3(view: self, msg: "Please enter card number")
            return
        }
        if txtcardNumber.text!.count != 16{
            alert3(view: self, msg: "Card number must be 16 numbers")
            return
        }
        if txtcvc.text == ""{
            alert3(view: self, msg: "Please enter CVC number")
            return
        }
        if txtcvc.text!.count != 3{
            alert3(view: self, msg: "CVC must be of 3 numbers")
            return
        }
        if txtexpiry.text == ""{
            alert3(view: self, msg: "Please enter Expiry date")
            return
        }
        let a = validatedate()
        if  !a{
            alert3(view: self, msg: "Please enter valid date format")
            return
        }
        
            var ab = txtexpiry.text!
            ab = ab.replacingOccurrences(of: "\"", with: "")
            ab = ab.replacingOccurrences(of: " ", with: "")
            let comps = ab.components(separatedBy: "/")
        
            let f = UInt(comps.first!)
            let l = UInt(comps.last!)

        if f == nil || l == nil{
            alert3(view: self, msg: "Please enter valid date format")
            return
        }
            let cardParams = STPCardParams()
            cardParams.name = txtcardholdr.text!
            cardParams.number = txtcardNumber.text!
            cardParams.expMonth = f!
            cardParams.expYear =  l!
            cardParams.cvc = txtcvc.text!

            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                print("\(String(describing: token?.allResponseFields))")
                print("\(String(describing: token?.tokenId)))")
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    alert3(view: self, msg: error?.localizedDescription ?? "")
                }

                if token != nil{
                    self.Cardtoken = token!.tokenId
                    self.AddCard()
                }else{
                    alert3(view: self, msg: "Some thing went wrong")
                }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension AddcardViewController{
    
    func validatedate()->Bool{
        let dateFormator = DateFormatter()
        dateFormator.timeZone = TimeZone.current
        dateFormator.dateFormat = "MM/yyyy"
        if dateFormator.date(from: txtexpiry.text!) != nil {
            print(dateFormator.date(from: txtexpiry.text!) ?? "")
            return true
        } else {
            // invalid format
            
            return false
        }
    }
    
    ///////////////////////// AddCard Function ?????????/
    func AddCard()  {
        if Cardtoken == ""{
            return
        }
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/card/add"
        let headers = ["Content-Type":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
        let para = [
            
            "token":"\(Cardtoken)"
        ]
        //         "user_subscription_id":"\(user_subscription_id)",
        print(para)
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        SVProgressHUD.dismiss()
                        //                        let message = dic["message"]?.stringValue ?? ""
                        //                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        objpay.GetCardList()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
}
