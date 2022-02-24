//
//  ForLovedOnesViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 20/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

class LovedStone {
    var id: Int
    var type: String
    var createdBy, managedBy: Int
    var fName, lName, gender: String
    var departureDate: String?
    var stoneDescription: String
    var displayImage, coverImage: String?
    var isPrivate: Int
    var createdAt: String
    var is_following: Int
    
    init() {
        self.id = 0
        self.type = ""
        self.createdBy = 0
        self.managedBy = 0
        self.fName = ""
        self.lName = ""
        self.gender = ""
        self.departureDate = ""
        self.stoneDescription = ""
        self.displayImage = ""
        self.coverImage = ""
        self.isPrivate = 0
        self.createdAt = ""
        self.is_following = 0
    }
    
    init(id: Int, type: String, createdBy: Int, managedBy: Int, fName: String, lName: String, gender: String, departureDate: String, stoneDescription: String, displayImage: String, coverImage: String, isPrivate: Int, createdAt: String,is_following: Int) {
        self.id = id
        self.type = type
        self.createdBy = createdBy
        self.managedBy = managedBy
        self.fName = fName
        self.lName = lName
        self.gender = gender
        self.departureDate = departureDate
        self.stoneDescription = stoneDescription
        self.displayImage = displayImage
        self.coverImage = coverImage
        self.isPrivate = isPrivate
        self.createdAt = createdAt
        self.is_following = is_following
    }
}



import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForLovedOnesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var colview: UICollectionView!
    
    var arrLoved:[LovedStone] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userGetStones()
        
    }
    
    
    
    
}



extension ForLovedOnesViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLoved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ForLovedOnesCollectionViewCell
        cell.img.sd_imageIndicator?.startAnimatingIndicator()
        //        cell.img.sd
        cell.img.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        let sizes = cell.img.image?.size
        if Int(sizes?.width ?? 0)  >= Int(sizes?.height ?? 0)
        {
            cell.img.contentMode = .scaleAspectFit
        }
        else
        {
            cell.img.contentMode = .scaleAspectFill
        }
        cell.title.text = "\(arrLoved[indexPath.row].fName) \(arrLoved[indexPath.row].lName)"
        let sec = stringtoString_with_Format(userdate: arrLoved[indexPath.row].createdAt, input: "yyyy-MM-dd HH:mm:ss", Output: "yyyy-MM-dd")
        cell.date.text = sec
        cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        cell.backImg.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width/2-20), height: (collectionView.bounds.height/2-15))
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        objtofollow = arrLoved[indexPath.row]
        UserTapped = UserRoleKey.Loved.rawValue
        self.performSegue(withIdentifier: "Godt", sender: nil)
    }
    
    
    ///////////////////////// UserLogin Function ?????????/
    func userGetStones()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestones"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .get, parameters: nil, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        let data = dic["lifestones"]?.dictionaryValue ?? [:]
                        let user = data["loved_ones"]?.array ?? []
                        
                        for item in user{
                            let obj = LovedStone()
                            obj.id = item["id"].int ?? 0
                            obj.type = item["type"].string ?? ""
                            obj.createdBy = item["created_by"].int ?? 0
                            obj.managedBy = item["managed_by"].int ?? 0
                            obj.fName = item["f_name"].string ?? ""
                            obj.lName = item["l_name"].string ?? ""
                            obj.gender = item["gender"].string ?? ""
                            obj.departureDate = item["departure_date"].string ?? ""
                            obj.stoneDescription = item["description"].string ?? ""
                            obj.displayImage = item["display_image"].string ?? ""
                            obj.coverImage = item["cover_image"].string ?? ""
                            obj.createdAt = item["created_at"].string ?? ""
                            obj.isPrivate = item["is_private"].int ?? 0
                            self.arrLoved.append(obj)
                        }
                        SVProgressHUD.dismiss()
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.colview.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
        
    }
}
