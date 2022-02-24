//
//  FollwerAboutViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var arrdetcharity:[Charities] = []
var arrDetGoals:[Charities] = []
var arrdetwish:[Charities] = []
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
var dobs = ""

class FollwerAboutViewController: UIViewController {

    @IBOutlet weak var btnheight: NSLayoutConstraint!
    
    @IBOutlet weak var btnfollow: ButtonTwoGradient!
    @IBOutlet weak var vw: SetTwoGradiant!
    @IBOutlet weak var lbldes: UITextView!
    @IBOutlet weak var lblbirth: UILabel!
    @IBOutlet weak var lbldeparture: UILabel!
    @IBOutlet weak var lblfollowers: UILabel!
    @IBOutlet weak var lblcharties: UILabel!
    @IBOutlet weak var lblcreatedby: UILabel!
    @IBOutlet weak var vwcon: NSLayoutConstraint!
    
    
    var moved = false
    var dob = ""
    var depature = ""
    var userfollow = true
    var mainVc = FollowerLifeStoneViewController()
    
    @IBOutlet weak var btnAcCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var btnEdit: UIButton!
    var flgd = true
    
    var objStoneDetail = StoneDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dtp.maximumDate = Date()
        dtp.setValue(UIColor.white, forKey: "textColor")
        // Do any additional setup after loading the view.
       UserLoad()
//        lbldes.layer.borderColor = UIColor.white.cgColor
//        lbldes.layer.borderWidth = 1
//        lbldes.layer.cornerRadius = 10
        lbldes.clipsToBounds = true
  
    }

//    func adjustUITextViewHeight(arg : UITextView)
//    {
//        arg.translatesAutoresizingMaskIntoConstraints = true
//        arg.sizeToFit()
//        arg.isScrollEnabled = true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnEditAbout(_ sender: UIButton)
    {
        btnEdit.isHidden = true
        lbldes.isEditable = true
        btnSave.isHidden = false
        btnAcCancel.isHidden = false
    }
    
    @IBAction func btnCancelEdit(_ sender: UIButton)
    {
        lbldes.isEditable = false
         btnEdit.isHidden = false
        btnSave.isHidden = true
        btnAcCancel.isHidden = true
    }
    
    @IBAction func DOb(_ sender: UIButton)
    {
        if btnSave.isHidden
        {
            return
        }
        self.view.endEditing(true)
        blurView.isHidden = false
        animate2(VC: self, Popview: popup)
        flgd = false
    }
    
    @IBAction func departure(_ sender: UIButton) {
        if btnSave.isHidden{
            return
        }
        
        self.view.endEditing(true)
        blurView.isHidden = false
        animate2(VC: self, Popview: popup)
        flgd = true
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
            lblbirth.text = dob
            dobs = dob
        }
        dtp.date = Date()
        popup.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        blurView.isHidden = true
        popup.isHidden = true
    }
    
    @IBAction func btnfollow(_ sender: ButtonTwoGradient) {
        FollowUnfollow()
    }
    @IBAction func btnSave(_ sender: UIButton) {
        if lbldes.text == ""{
            return
        }
        UpdateLifeStone()
    }
    
    func setFolow(){
        if self.userfollow{
            self.btnfollow.setTitle("Unfollow", for: .normal)
        }else{
            self.btnfollow.setTitle("Follow", for: .normal)
        }
    }
    
    func UserLoad(){
        btnfollow.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        vw.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        if UserTapped != UserRoleKey.Follow.rawValue{
            btnheight.constant = 0
            btnEdit.isHidden = false
            btnfollow.isHidden = true
            vwcon.constant = -2000
        }else{
            btnEdit.isHidden = true
            btnfollow.isHidden = false
            vwcon.constant = -20
            btnheight.constant = 40
        }
        
        setFolow()
        GetStoneDetails()
    }
    
}



extension FollwerAboutViewController{
    
    
    ///////////////////////// UserLogin Function ?????????/
    func FollowUnfollow()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/follow"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        let para = ["ls_id":"\(objtofollow.id)"]
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result
                {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true
                    {
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
//                        var navArray:Array = (self.navigationController?.viewControllers)!
//                        navArray.remove(at: (navArray.count-1))
//                        self.navigationController?.viewControllers = navArray
//                        if self.moved == true
//                        {
//                            var navArray1:Array = (self.navigationController?.viewControllers)!
//                            navArray1.remove(at: (navArray1.count-1))
//                            self.navigationController?.viewControllers = navArray1
//                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    else
                    {
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async
                    {
                        self.setFolow()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    func UpdateLifeStone()
    {
        
        let img = UIImageView()
        img.sd_setImage(with: URL(string: "\(self.objStoneDetail.displayImage ?? "")".replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "user"))
        let base64Str = ConvertImageToBase64String(img: img.image!)
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/update"
        
        let parameters = [
            "ls_id":"\(objtofollow.id)",
            "f_name":"\(objtofollow.fName)",
            "l_name":"\(objtofollow.lName)",
            "gender":"\(objtofollow.gender.lowercased())",
            "dob":"\(dob)",
            "departure_date":"\(self.depature)",
            "description":"\(lbldes.text ?? "")",
            "display_image":"data:image/png;base64,\(base64Str)",
            "cover_image":"\(objtofollow.coverImage!)",
            "type":"Loved",
            "is_private":"\(objtofollow.isPrivate)",
            "lat":"",
            "long":"",
            "gps_address":""
            ] as [String : Any]
        
        
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
                        self.lbldes.isEditable = false
                                self.btnEdit.isHidden = false
                               self.btnSave.isHidden = true
                               self.btnAcCancel.isHidden = true
                    }
                    else{
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
        }
        
    }
    
    ///////////////////////// GetCharities Function ?????????/
    func GetStoneDetails()
    {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/detail"
        let parameter = ["ls_id":"\(objtofollow.id)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameter, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        arrdetcharity.removeAll()
                        arrDetGoals.removeAll()
                        arrdetwish.removeAll()
                        SVProgressHUD.dismiss()
                        let lifeStone = dic["lifestone"]?.dictionary ?? [:]
                        self.objStoneDetail.id = lifeStone["id"]?.int ?? 0
                        self.objStoneDetail.coverImage = lifeStone["cover_image"]?.string ?? ""
                        self.objStoneDetail.departureDate = lifeStone["departure_date"]?.string ?? ""
                        self.objStoneDetail.displayImage = lifeStone["display_image"]?.string ?? ""
                        self.objStoneDetail.dob = lifeStone["dob"]?.string ?? ""
//                        dobs = lifeStone["dob"]?.string ?? ""//
                        self.objStoneDetail.fName = lifeStone["f_name"]?.string ?? ""
                        self.objStoneDetail.gender = lifeStone["gender"]?.string ?? ""
                        self.objStoneDetail.lName = lifeStone["l_name"]?.string ?? ""
                        self.objStoneDetail.created_at = lifeStone["created_at"]?.string ?? ""
                        self.objStoneDetail.updated_at = lifeStone["updated_at"]?.string ?? ""
                        self.objStoneDetail.created_by = lifeStone["created_by"]?.string ?? ""
                        self.objStoneDetail.isPrivate = lifeStone["is_private"]?.int ?? 0
                        self.objStoneDetail.charities_count =  lifeStone["charities_count"]?.int ?? 0
                        self.objStoneDetail.followers_count =  lifeStone["followers_count"]?.int ?? 0
                        
                        self.objStoneDetail.stoneDetailsDescription = lifeStone["description"]?.string ?? ""
                        
                        
                        let arrchr = lifeStone["charities"]?.array ?? []
                        for item in arrchr{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["charity_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            arrdetcharity.append(obj)
                        }
                        let arrach = lifeStone["achievements"]?.array ?? []
                        for item in arrach{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["achievement_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            arrDetGoals.append(obj)
                            
                        }
                        let arrwish = lifeStone["wishes"]?.array ?? []
                        for item in arrwish{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.title = item["content"].string ?? ""
                            
                            arrdetwish.append(obj)
                        }
                        DispatchQueue.main.async {
                            self.lbldes.text = self.objStoneDetail.stoneDetailsDescription
                            self.lblfollowers.text = "\(self.objStoneDetail.followers_count)"
                            self.lblcharties.text = "\(self.objStoneDetail.charities_count)"
                            self.lblcreatedby.text = self.objStoneDetail.created_by
                            let sc = stringtoString_with_Format(userdate: self.objStoneDetail.dob, input: "yyyy-MM-dd", Output: "dd-MM-yyyy")
                            self.lblbirth.text = sc
                            let sc1 = stringtoString_with_Format(userdate: self.objStoneDetail.departureDate, input: "yyyy-MM-dd", Output: "dd-MM-yyyy")
                            self.lbldeparture.text = sc1
//                            self.adjustUITextViewHeight(arg: self.lbldes)
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
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


