//
//  searchDetailViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 13/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage

class searchDetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate
{
  
    @IBOutlet weak var roundImg: RoundUIImage!
    var  userfollow = true
    @IBOutlet weak var lblcharity: UILabel!
    @IBOutlet weak var lbldod: UILabel!
    @IBOutlet weak var lbldob: UILabel!
    @IBOutlet weak var lbllname: UILabel!
    @IBOutlet weak var lblfname: UILabel!
    @IBOutlet weak var lblflollowings: UILabel!
    @IBOutlet weak var colvw: UICollectionView!
    @IBOutlet weak var btnfollow: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    var objStoneDetail = StoneDetails()
     var Listimages: [UserData]  = []
    
@IBOutlet weak var vw2: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         vw2.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 57, height: 57), cornerRadius: 30, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
        GetStoneDetails()
        if btnfollow.titleLabel?.text == "Unfollow"
        {
            GetData()
        }
    }
    
    @IBAction func btnfollow(_ sender: UIButton)
    {
        FollowUnfollow()
    }

}

extension searchDetailViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Listimages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! SearchdetailCollectionViewCell
        cell.img.sd_setImage(with: URL(string: Listimages[indexPath.row].thumbURL.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        return cell
    }
    
    func setFolow(){
        if self.userfollow
        {
        
            self.btnfollow.setTitle("Unfollow", for: .normal)
            GetData()
        }else{
            self.btnfollow.setTitle("Follow", for: .normal)
        }
    }
    
    ///////////////////////// UserLogin Function ?????????/
    func FollowUnfollow()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/follow"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        let para = ["ls_id":"\(objStoneDetail.id)"]
        
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
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
//                        alert3(view: self, msg: message
                        objtofollow.id = self.objStoneDetail.id
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowerDetailViewController") as! FollowerDetailViewController
                        self.navigationController?.pushViewController(vc, animated: true)
//                        (withIdentifier: "godet", sender: nil)
                        DispatchQueue.main.async
                        {
                            self.setFolow()
                        }
                    }
                    else{
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    //////////////////////// GetData Function ?????????/
    func GetData()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/media/list"
        let parameters = [
            "ls_id":"\(userobjdetail.id)"
        ]
        let headers = ["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
                        let arr = dic["message"]?.array ?? []
                        self.Listimages.removeAll()
                        for item in arr{
                            let obj = UserData()
                            obj.id = item["id"].int ?? 0
                            obj.imageURL = item["image_url"].string ?? ""
                            obj.lsID = item["ls_id"].int ?? 0
                            obj.thumbURL = item["thumb_url"].string ?? ""
                            obj.userID = item["user_id"].int ?? 0
                            obj.type = item["type"].string ?? ""
                            
                            if obj.type == "image"{
                                self.Listimages.append(obj)
                            }
                            
                        }
                        SVProgressHUD.dismiss()
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.colvw.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
    }
    
    
    ///////////////////////// GetCharities Function ?????????/
    func GetStoneDetails()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/detail"
        let parameter = ["ls_id":"\(userobjdetail.id)"]
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
                        
                        SVProgressHUD.dismiss()
                        let lifeStone = dic["lifestone"]?.dictionary ?? [:]
                        self.objStoneDetail.id = lifeStone["id"]?.int ?? 0
                        self.objStoneDetail.coverImage = lifeStone["cover_image"]?.string ?? ""
                        self.objStoneDetail.departureDate = lifeStone["departure_date"]?.string ?? ""
                        self.objStoneDetail.displayImage = lifeStone["display_image"]?.string ?? ""
                        self.objStoneDetail.dob = lifeStone["dob"]?.string ?? ""
                        self.objStoneDetail.fName = lifeStone["f_name"]?.string ?? ""
                        self.objStoneDetail.gender = lifeStone["gender"]?.string ?? ""
                        self.objStoneDetail.lName = lifeStone["l_name"]?.string ?? ""
                        self.objStoneDetail.created_at = lifeStone["created_at"]?.string ?? ""
                        self.objStoneDetail.updated_at = lifeStone["updated_at"]?.string ?? ""
                        self.objStoneDetail.isPrivate = lifeStone["is_private"]?.int ?? 0
                        self.objStoneDetail.charities_count =  lifeStone["charities_count"]?.int ?? 0
                        self.objStoneDetail.followers_count =  lifeStone["followers_count"]?.int ?? 0
                        
                        self.objStoneDetail.stoneDetailsDescription = lifeStone["description"]?.string ?? ""
                        DispatchQueue.main.async {
                            self.lbldob.text = self.objStoneDetail.dob
                            self.lbldod.text = self.objStoneDetail.departureDate
                            
                            self.lblfname.text = self.objStoneDetail.fName
                            self.lbllname.text = self.objStoneDetail.lName
                            self.lblcharity.text = "\(self.objStoneDetail.charities_count)"
                            self.lblflollowings.text = "\(self.objStoneDetail.followers_count)"
                            self.img.sd_setImage(with: URL(string: AppDelegate.returnImg(imgString: "\(self.objStoneDetail.coverImage!)")), placeholderImage: #imageLiteral(resourceName: "123"), options: .highPriority)
                            
                            self.roundImg.sd_setImage(with: URL(string: AppDelegate.returnImg(imgString: "\(self.objStoneDetail.coverImage!)")), placeholderImage: #imageLiteral(resourceName: "123"), options: .highPriority)
                            
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
