//
//  DetailsViewController.swift
//  LifeStone
//
//  Created by Mr.Mac on 13/08/2020.
//  Copyright © 2020 Invotyx. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class DetailsViewController: UIViewController
{
    @IBOutlet weak var genderbtn: UIButton!
    @IBOutlet weak var FirstField: UITextField!
    @IBOutlet weak var LastField: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var EditingBtn: ButtonRound!
    @IBOutlet weak var CancelBtn: ButtonRound!
    @IBOutlet weak var SaveBtn: ButtonRound!
    var id = ""
    var isEditingOn = false
    @IBOutlet weak var Views: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserTapped == UserRoleKey.Follow.rawValue
        {
            EditingBtn.isHidden = true
        }
        else
        {
            EditingBtn.isHidden = false
        }
        
        UserDetailWill(id: "\(objtofollow.id)")
        CancelBtn.isHidden  = true
        SaveBtn.isHidden    = true
        FirstField.isUserInteractionEnabled = false
        LastField.isUserInteractionEnabled = false
        Gender.isUserInteractionEnabled = false
        genderbtn.isUserInteractionEnabled = false
    }
    
    @IBAction func Edit(_ sender: ButtonRound)
    {
        if isEditingOn == false
        {
            FirstField.isUserInteractionEnabled = true
            LastField.isUserInteractionEnabled = true
            Gender.isUserInteractionEnabled = true
            genderbtn.isUserInteractionEnabled = true
            EditingBtn.isHidden = true
            CancelBtn.isHidden  = false
            SaveBtn.isHidden    = false
            
            isEditingOn = true
        }
        else
        {
            genderbtn.isUserInteractionEnabled = false
            FirstField.isUserInteractionEnabled = false
            LastField.isUserInteractionEnabled = false
            Gender.isUserInteractionEnabled = false
            EditingBtn.isHidden = false
            CancelBtn.isHidden  = true
            SaveBtn.isHidden    = true
            
            isEditingOn = false
        }
    }
    
    @IBAction func BtnGHender(_ sender: UIButton)
    {
        showAlert(sender: sender)
    }
    
    
    
    @IBAction func Cancel(_ sender: ButtonRound)
    {
        isEditingOn = false
        FirstField.isUserInteractionEnabled = false
        LastField.isUserInteractionEnabled = false
        Gender.isUserInteractionEnabled = false
        genderbtn.isUserInteractionEnabled = false
        EditingBtn.isHidden = false
        CancelBtn.isHidden = true
        SaveBtn.isHidden   = true
    }
    
    @IBAction func Save(_ sender: ButtonRound)
    {
        UpdateLifeStone()
    }
    
    
    
    func UserDetailWill(id:String)
    {
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/detail"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        let param = ["ls_id":"\(id)"]
        Alamofire.request (urlstring ,method : .post, parameters: param, encoding
            : JSONEncoding.default,headers: headers).responseJSON
            { response in
                switch response.result
                {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    let dicc1 = dic["lifestone"]?.dictionaryValue ?? [:]
                    
                    if success == true
                    {
                        SVProgressHUD.dismiss()
                        print(dicc1)
                        let message = dic["message"]?.stringValue ?? ""
                        self.FirstField.text = dicc1["f_name"]?.stringValue ?? ""
                        self.LastField.text = dicc1["l_name"]?.stringValue ?? ""
                        self.Gender.text = dicc1["gender"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async
                    {
                        
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
       func UpdateLifeStone()
        {
            
            let img = UIImageView()
            img.sd_setImage(with: URL(string: "\(objtofollow.displayImage ?? "")".replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "user"))
            let base64Str = ConvertImageToBase64String(img: img.image!)
            
            SVProgressHUD.show(withStatus: "Loading")
            let urlstring = AppDelegate.baseurl+"api/lifestone/update"
            
            let parameters = [
                "ls_id":"\(objtofollow.id)",
                "f_name":"\(FirstField.text!)",
                "l_name":"\(LastField.text!)",
                "gender":"\(Gender.text!)",
                "dob":"\(dobs)",
                "departure_date":"\(objtofollow.departureDate ?? "")",
                "description":"\(objtofollow.stoneDescription)",
                "display_image":"data:image/png;base64,\(base64Str)",
                "cover_image":"\(objtofollow.coverImage!)",
                "type":"Loved",
                "is_private":"\(objtofollow.isPrivate)",
                "lat":"",
                "long":"",
                "gps_address":""
                ] as [String : Any]
            
            print(parameters)
            let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
            
            
            Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
                : JSONEncoding.default,headers: headers).responseJSON { response in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.boolValue ?? false
                        if success == true {
    //                        let message = dic["message"]?.stringValue ?? ""
    //                        alert3(view: self, msg: message)
                            self.isEditingOn = false
                                    self.EditingBtn.isHidden = false
                                   self.SaveBtn.isHidden = true
                                   self.CancelBtn.isHidden = true
                            self.FirstField.isUserInteractionEnabled = false
                            self.LastField.isUserInteractionEnabled = false
                            self.Gender.isUserInteractionEnabled = false
                            self.genderbtn.isUserInteractionEnabled = false
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
    
    func showAlert(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        
        
        let alert = UIAlertController(title: "Gender", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.Gender.text = "male"
            
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.Gender.text = "female"
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
           
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}
//if FirstField.text! == ""
//       {
//           alert3(view: self, msg: "First name required!")
//           return
//       }
//       if LastField.text! == ""
//       {
//           alert3(view: self, msg: "Last name required!")
//           return
//       }
//       if Gender.text! == ""{
//           alert3(view: self, msg: "Date of birth required!")
//           return
//       }
//
