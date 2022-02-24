//
//  LoginViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 09/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import OneSignal
//import TwitterKit
//import TwitterCore

class LoginViewController: UIViewController,UITextFieldDelegate {
   
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpass: UITextField!
    @IBOutlet weak var lblmail: mylbl!
    @IBOutlet weak var lblpas: mylbl!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var btnsi: UIButton!
    
    var providerid = ""
    var socialemail = ""
    
    var isTitleVisible = false
    var titleFadeInDuration: Double = 0.2
    var titleFadeOutDuration: Double = 0.2
    
    var flgcnfrm = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        UserLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        Login.setImage(#imageLiteral(resourceName: "fb"), for: .normal)
    }
    
    
    
    func UserLoad(){
       

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        btnsi.underline()
        
        if AccessToken.current != nil
        {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let fbDetails = result as! NSDictionary
                    print(fbDetails.allKeys)
                    let fb = fbDetails.object(forKey: "name")
                    print(fb as! String)
                } else {
                    print(error?.localizedDescription ?? "Not found")
                }
            })

        }
        else
        {
        }

    }
    
 
    @IBAction func btnShowCnfrm(_ sender: UIButton) {
        if flgcnfrm{
            btn2.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            txtpass.isSecureTextEntry = false
            flgcnfrm = false
        }else{
            btn2.setImage(#imageLiteral(resourceName: "eyehide"), for: .normal)
            txtpass.isSecureTextEntry = true
            flgcnfrm = true
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func googlePlusButtonTouchUpInside(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func txtmail(_ sender: UITextField) {
        txtpass.becomeFirstResponder()
    }
    
    @IBAction func txtpassword(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnlogin(_ sender: UIButton) {
        Userlogin()
    }
    

    
    @IBAction func tapTwitter_btn(_ sender: Any) {
        alert(view: self, msg: "")
        
//        TWTRTwitter.sharedInstance().logIn { (session, error) in
//            if (session != nil) {
//                let client = TWTRAPIClient.withCurrentUser()
//                client.requestEmail { email, error in
//                    if (email != nil) {
//                        print("signed in as \(String(describing: session?.userName))");
//                        let recivedEmailID = email ?? ""
//                        let providerid = session?.userID
//                        UserDefaults.standard.set(true, forKey: "Social")
//                        print(recivedEmailID)
//                        print(providerid ?? "")
//                        self.providerid = providerid ?? ""
//                        self.socialemail = recivedEmailID
//                        self.SocialLogin()
//                    }
//                    else
//                    {
//                        print("error: \(String(describing: error?.localizedDescription))");
//                    }
//                }
//            }
//            else
//            {
//                print("error: \(String(describing: error?.localizedDescription))");
//            }
//        }
    }
    
    @IBAction func btnFbLogin(_ sender: UIButton)
    {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self)
        { (result, error) -> Void in
            if (error == nil)
            {
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!
                {
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    print(fbloginresult)
                    self.fethchFBdata()
                }
            }
        }
    }
 
}



extension LoginViewController: GIDSignInDelegate{
//        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//            if let error = error {
//                print("\(error.localizedDescription)")
//            } else {
//                // Perform any operations on signed in user here.
//                let userId = user.userID                  // For client-side use only!
//                let idToken = user.authentication.idToken // Safe to send to the server
//                let fullName = user.profile.name
//    //            let givenName = user.profile.givenName
//                let familyName = user.profile.familyName
//                let email = user.profile.email
//                // ...
//
//                print(userId ?? "")
//                print(idToken ?? "")
//                print(fullName ?? "")
//    //            print(givenName ?? "")
//                print(familyName ?? "")
//                print(email ?? "")
//
//            }
//        }
//    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userId = user.userID
            let email = user.profile.email
            print(email ?? "")
            print(userId ?? "")
            providerid = userId ?? ""
            socialemail = email ?? ""
             UserDefaults.standard.set(true, forKey: "Social")
            if UserDefaults.standard.value(forKey: "loginstatus")as? Bool ?? false == false{
                SocialLogin()
            }
            
        } else {
            print("\(error.localizedDescription)")
        }
    }

        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                  withError error: Error!) {
            // Perform any operations when the user disconnects from app here.
            // ...
            print("SIgnOUt")
        }
}



extension LoginViewController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtemail{
            textField.placeholder = ""
            vw.layer.borderColor = UIColor.white.cgColor
            lblmail.textColor = UIColor.white
            self.lblmail.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblmail.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblmail.alpha = 0.6
                self.vw3.alpha = 1
                self.lblmail.transform = .identity
            }) { (true) in
            }
            
        }
        if textField == txtpass{
            textField.placeholder = ""
            self.lblpas.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblpas.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblpas.alpha = 0.6
                self.vw2.alpha = 1
                self.lblpas.transform = .identity
            }) { (true) in
            }
            
            vw1.layer.borderColor = UIColor.white.cgColor
            lblpas.textColor = UIColor.white
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtemail{
            vw.layer.borderColor = UIColor.black.cgColor
            lblmail.textColor = UIColor.black
            self.vw2.alpha = 0
            self.vw3.alpha = 0
            self.lblmail.alpha = 0
            self.lblpas.alpha = 0
            if textField.text == ""{
                //                txtemail.placeholder = "Email"
                txtemail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        if textField == txtpass{
            vw1.layer.borderColor = UIColor.black.cgColor
            lblpas.textColor = UIColor.black
            self.vw2.alpha = 0
            self.vw3.alpha = 0
            self.lblmail.alpha = 0
            self.lblpas.alpha = 0
            if textField.text == ""{
                //                txtpass.placeholder = "Password"
                txtpass.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        
    }
    
    private func updateTitleVisibility(_ animated: Bool = false,lbl: mylbl, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = lbl.isTitleVisible! ? 1.0 : 0.0
        let frame: CGRect = lbl.bounds
        let updateBlock = { () -> Void in
            lbl.alpha = alpha
            lbl.frame = frame
        }
        if animated {
            let animationOptions: UIView.AnimationOptions = .curveEaseOut;
            let duration = lbl.isTitleVisible! ? self.titleFadeInDuration : self.titleFadeOutDuration
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }

    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
//    {
//        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
//    }
    

    
    
    func fethchFBdata(){
        let accessToken = AccessToken.current
        if(accessToken != nil)
        {
            print(accessToken?.tokenString ?? "")
        }
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
        req.start(completionHandler: { (connection, result, error : Error!) -> Void in
            if(error == nil) {
                print("result \(result ?? "")")
                let dic = result as! NSDictionary
                self.providerid = "\(dic.value(forKey: "id") ?? "")"
                self.socialemail = "\(dic.value(forKey: "email") ?? "")"
                 UserDefaults.standard.set(true, forKey: "Social")
                self.SocialLogin()
             }else{
                print("error \(error ?? "" as! Error)")
            }
        })
    }
    
    
    ///////////////////////// UserLogin Function ?????????/
    func Userlogin()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let email = txtemail.text!
        let pass = txtpass.text!
        if email == "" {
            SVProgressHUD.dismiss()
            let message = "Email required"
            alert3(view: self, msg: message)
        }
        else if pass == ""{
            SVProgressHUD.dismiss()
            let message = "Password required"
            alert3(view: self, msg: message)
        }
            
        else{
            let flg = email.isValidEmail()
            
            if flg  {
                
                let urlstring = AppDelegate.baseurl+"api/login"
                let parameters = [
                    "email":"\(String(describing: email))",
                    "password":"\(String(describing: pass))"
                ]
                
                Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                    : JSONEncoding.default,headers: nil).responseJSON { response in
                        
                        switch response.result
                        {
                        case .success:
                            let json = JSON(response.result.value!)
                            let dic = json.dictionaryValue
                            print(dic)
                            let success = dic["status"]?.stringValue ?? ""
                            if success == "Success" {
                                
                                let data = dic["data"]?.dictionaryValue ?? [:]
                                let user = data["user"]?.dictionaryValue ?? [:]
                                AppDelegate.personalInfo.token = data["token"]?.stringValue ?? ""
                                print(AppDelegate.personalInfo.token)
                                print(data)
                                print(user)
                                if user["first_name"]?.stringValue ?? "" == "" || user["last_name"]?.stringValue ?? "" == ""
                                {
                                    SVProgressHUD.dismiss()
                                    self.performSegue(withIdentifier: "lets", sender: self)
                                }
                                else
                                {
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
                                    AppDelegate.personalInfo.pass = pass
                                    
                                    AppDelegate.personalInfo.lifestones_count = String(user["lifestones_count"]?.int ?? 0)
                                    AppDelegate.personalInfo.charities_count = String(user["charities_count"]?.int ?? 0)
                                    AppDelegate.personalInfo.subscription = user["subscription"]?.stringValue ?? ""
                                    AppDelegate.personalInfo.created_at = user["created_at"]?.stringValue ?? ""
                                    AppDelegate.personalInfo.display_image = user["display_image"]?.stringValue ?? ""
                                    
                                    Save_UD(info: AppDelegate.personalInfo)
                                    UserDefaults.standard.set(false, forKey: "Social")
                                    UserDefaults.standard.set(true, forKey: "loginstatus")
                                    SVProgressHUD.dismiss()
//                                    self.performSegue(withIdentifier: "loged", sender: nil)
                                    self.SendDeviceData()
                                }
                            }
                            else{
                                SVProgressHUD.dismiss()
                                let inactive = dic["inactive"]?.bool ?? false
                                if inactive
                                {
                                    self.performSegue(withIdentifier: "veri", sender: nil)
                                }
                                else{
                                    let message = dic["message"]?.stringValue ?? ""
                                    alert3(view: self, msg: message)
                                }
                            }
                            
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            print(error.localizedDescription)
                        }
                }
            }
            else{
                SVProgressHUD.dismiss()
                let message = "Vaild email required"
                alert3(view: self, msg: message)
            }
        }
    }
    
    ///////////////////////// UserLogin Function ?????????/
    func SocialLogin()
    {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/login"
        let parameters = [
            "email":"\(socialemail)",
            "provider_id":"\(providerid)"
        ]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: nil).responseJSON { response in
                switch response.result
                {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let data = dic["data"]?.dictionaryValue ?? [:]
                    let user = data["user"]?.dictionaryValue ?? [:]
                    AppDelegate.personalInfo.token = data["token"]?.stringValue ?? ""
                    print(AppDelegate.personalInfo.token)
                    print(data)
                    print(user)
                    if user["first_name"]?.stringValue ?? "" == "" || user["last_name"]?.stringValue ?? "" == ""
                    {
                        SVProgressHUD.dismiss()
                        Save_UD(info: AppDelegate.personalInfo)
                        self.performSegue(withIdentifier: "lets", sender: self)
                    }
                    else
                    {
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
                        UserDefaults.standard.set(true, forKey: "Social")
                        UserDefaults.standard.set(true, forKey: "loginstatus")
                        SVProgressHUD.dismiss()
//                        self.performSegue(withIdentifier: "loged", sender: nil)
                        self.SendDeviceData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
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
//                        updateRootView()
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


