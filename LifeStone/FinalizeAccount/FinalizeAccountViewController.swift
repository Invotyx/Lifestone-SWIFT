//
//  FinalizeAccountViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 16/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import  OneSignal

class FinalizeAccountViewController: UIViewController,UITextFieldDelegate {

    var dob = ""
    var gender = ""
    
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var vw6: UIView!
    
    @IBOutlet weak var vw7: UIView!
    @IBOutlet weak var vw8: UIView!
    @IBOutlet weak var vw9: UIView!
    @IBOutlet weak var vw10: UIView!
    @IBOutlet weak var vw11: UIView!
    @IBOutlet weak var vw12: UIView!
    
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtgender: UITextField!
    @IBOutlet weak var txtmobile: UITextField!
    @IBOutlet weak var txtdob: UITextField!
    @IBOutlet weak var txtcity: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var lblln: UILabel!
    @IBOutlet weak var lblm: UILabel!
    @IBOutlet weak var lbld: UILabel!
    @IBOutlet weak var lblc: UILabel!
    @IBOutlet weak var lblge: UILabel!
    @IBOutlet weak var lblfn: UILabel!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dtp.maximumDate = Date()
        dtp.setValue(UIColor.white, forKey: "textColor")
       myload()
       resetBorder()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        AppDelegate.personalInfo = Read_UD()
    }
    
    @IBAction func btndob(_ sender: UIButton)
    {
        self.view.endEditing(true)
        vw4.layer.borderColor = UIColor.white.cgColor
        lbld.textColor = UIColor.white
        txtdob.placeholder = ""
        self.lbld.transform = CGAffineTransform(translationX: 0, y: 30)
        self.lbld.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.lbld.alpha = 0.6
            self.vw11.alpha = 1
            self.lbld.transform = .identity
        }) { (true) in
        }
        blurView.isHidden = false
        animate2(VC: self, Popview: popup)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        let format1 = DateFormatter()
        format1.dateFormat = "dd-MM-yyyy"
        format1.timeZone = TimeZone.current
        dob = format1.string(from: dtp.date)
        txtdob.text = dob
        dtp.date = Date()
        popup.isHidden = true
        blurView.isHidden = true
        if txtdob.text == ""{
            txtdob.attributedPlaceholder = NSAttributedString(string: "dd-mm-yyyy",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        resetBorder()
        txtcity.becomeFirstResponder()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        if txtdob.text == ""{
            txtdob.attributedPlaceholder = NSAttributedString(string: "dd-mm-yyyy",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        resetBorder()
        blurView.isHidden = true
        popup.isHidden = true
    }
    
    
    @IBAction func genderTaped(_ sender: UITapGestureRecognizer) {
        showAlert(sender: sender)
    }
    
    
    @IBAction func tapgesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func txtfn(_ sender: UITextField) {
        txtlname.becomeFirstResponder()
    }
    
    @IBAction func txtln(_ sender: Any) {
        txtgender.becomeFirstResponder()
    }
    
    @IBAction func txtgen(_ sender: Any) {
        txtmobile.becomeFirstResponder()
    }
    
    @IBAction func txtmno(_ sender: Any) {
        self.view.endEditing(true)
//        txtdob.becomeFirstResponder()
    }
    
    @IBAction func txtdb(_ sender: Any) {
//        txtcity.becomeFirstResponder()
    }
    
    @IBAction func btnCross(_ sender: UIButton) {
        goback()
    }
    @IBAction func txtc(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnfinalize(_ sender: UIButton) {
        final()
    }
    
}



extension FinalizeAccountViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtfname{
            vw6.layer.borderColor = UIColor.white.cgColor
            lblfn.textColor = UIColor.white
            
            textField.placeholder = ""
            self.lblfn.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblfn.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblfn.alpha = 0.6
                self.vw7.alpha = 1
                self.lblfn.transform = .identity
            }) { (true) in
            }
        }
        
        if textField == txtlname{
            vw1.layer.borderColor = UIColor.white.cgColor
            lblln.textColor = UIColor.white
            
            textField.placeholder = ""
            self.lblln.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblln.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblln.alpha = 0.6
                self.vw8.alpha = 1
                self.lblln.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtgender{
            vw2.layer.borderColor = UIColor.white.cgColor
            lblge.textColor = UIColor.white
            textField.placeholder = ""
            self.lblge.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblge.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblge.alpha = 0.6
                self.vw9.alpha = 1
                self.lblge.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtmobile{
            vw3.layer.borderColor = UIColor.white.cgColor
            lblm.textColor = UIColor.white
            textField.placeholder = ""
            self.lblm.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblm.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblm.alpha = 0.6
                self.vw10.alpha = 1
                self.lblm.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtdob{
            vw4.layer.borderColor = UIColor.white.cgColor
            lbld.textColor = UIColor.white
            textField.placeholder = ""
            self.lbld.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lbld.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lbld.alpha = 0.6
                self.vw11.alpha = 1
                self.lbld.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtcity{
            vw5.layer.borderColor = UIColor.white.cgColor
            lblc.textColor = UIColor.white
            textField.placeholder = ""
            self.lblc.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblc.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblc.alpha = 0.6
                self.vw12.alpha = 1
                self.lblc.transform = .identity
            }) { (true) in
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtfname{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "First name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtlname{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Last name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtgender{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Last name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtmobile{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "Mobile Number",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtdob{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "dd-mm-yyyy",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                
            }
        }
        if textField == txtcity{
            if textField.text == ""{
                textField.attributedPlaceholder = NSAttributedString(string: "City",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        resetBorder()
    }
    func resetBorder(){
        
        vw7.alpha = 0
        vw8.alpha = 0
        vw9.alpha = 0
        vw10.alpha = 0
        vw11.alpha = 0
        vw12.alpha = 0
        
        lblc.alpha = 0
        lbld.alpha = 0
        lblm.alpha = 0
        lblge.alpha = 0
        lblln.alpha = 0
        lblfn.alpha = 0
        
        vw1.layer.borderColor = UIColor.black.cgColor
        vw2.layer.borderColor = UIColor.black.cgColor
        vw3.layer.borderColor = UIColor.black.cgColor
        vw4.layer.borderColor = UIColor.black.cgColor
        vw5.layer.borderColor = UIColor.black.cgColor
        vw6.layer.borderColor = UIColor.black.cgColor
        
        if txtgender.text == ""{
            txtgender.placeholder = "Gender"
        }
    }
    
    func showAlert(sender: AnyObject) {
        self.view.endEditing(true)
        txtgender.resignFirstResponder()
        vw2.layer.borderColor = UIColor.white.cgColor
        lblge.textColor = UIColor.white
        txtgender.placeholder = ""
        self.lblge.transform = CGAffineTransform(translationX: 0, y: 30)
        self.lblge.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.lblge.alpha = 0.6
            self.vw9.alpha = 1
            self.lblge.transform = .identity
        }) { (true) in
        }
        let alert = UIAlertController(title: "Gender", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.txtgender.text = "Male"
            self.resetBorder()
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.txtgender.text = "Female"
            self.resetBorder()
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            self.txtgender.text = "Other"
            self.resetBorder()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
            self.resetBorder()
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}







extension FinalizeAccountViewController{
    func myload(){
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func goback(){
        self.navigationController?.popViewController(animated: false)
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
    
    ///////////////////////// UserLogin Function ?????????/
    func final()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let fname = txtfname.text!
        let last_name = txtlname.text!
        let gender = txtgender.text!
        let phone_number = txtmobile.text!
        let dob = txtdob.text!
        let city = txtcity.text!
        if fname == "" {
            SVProgressHUD.dismiss()
            let message = "First name required"
            alert3(view: self, msg: message)
        }
       else if last_name == "" {
            SVProgressHUD.dismiss()
            let message = "Last name required"
            alert3(view: self, msg: message)
        }
        else if gender == ""{
            SVProgressHUD.dismiss()
            let message = "Gender required"
            alert3(view: self, msg: message)
        }
        else if phone_number == ""{
            SVProgressHUD.dismiss()
            let message = "Phone number required"
            alert3(view: self, msg: message)
        }
            
        else if dob == ""{
            SVProgressHUD.dismiss()
            let message = "Date of birth required"
            alert3(view: self, msg: message)
        }
        else if city == ""{
            SVProgressHUD.dismiss()
            let message = "City required"
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
                    "first_name":"\(fname)",
                    "last_name":"\(last_name)",
                    "gender":"\(gender)",
                    "phone_number":"\(phone_number)",
                    "dob":"\(dob)",
                    "city":"\(city)"
                ]
                let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
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
                                let user = dic["user"]?.dictionaryValue ?? [:]
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
                                AppDelegate.personalInfo.lifestones_count = String(user["lifestones_count"]?.int ?? 0)
                                AppDelegate.personalInfo.charities_count = String(user["charities_count"]?.int ?? 0)
                                AppDelegate.personalInfo.subscription = user["subscription"]?.stringValue ?? ""
                                AppDelegate.personalInfo.created_at = user["created_at"]?.stringValue ?? ""
                                AppDelegate.personalInfo.display_image = user["display_image"]?.stringValue ?? ""
                                
                                Save_UD(info: AppDelegate.personalInfo)
                                UserDefaults.standard.set(true, forKey: "loginstatus")
                                SVProgressHUD.dismiss()
//                                self.performSegue(withIdentifier: "loged", sender: nil)
                                self.SendDeviceData()
                                DispatchQueue.main.async {
                                }
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
    
    //////////////////////// User DataDevice ?????????????
    
    func SendDeviceData()  {
        AppDelegate.oneSignalToken = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId ?? ""
        let urlstring = AppDelegate.baseurl + "api/device/info"
        let parameters = [
            "device_name": "\(UIDevice.current.name)",
            "device_id": AppDelegate.oneSignalToken
        ]
        print(urlstring)
        print(parameters)
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.data as Any)     // server data
                print(response.result)   // result of response serialization
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success{
                        self.performSegue(withIdentifier: "loged", sender: self)
                    }else{
                        let message = dic["message"]?.string ?? ""
                        alert3(view: self, msg: message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                SVProgressHUD.dismiss()
        }
    }
}
