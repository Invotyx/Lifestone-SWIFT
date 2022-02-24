//
//  ForFollowingsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 20/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var useratapeself = false
var objtofollow = LovedStone()
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForFollowingsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var colview: UICollectionView!
    
     var arrLoved:[LovedStone] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         userGetStones()
    }
    
}






extension ForFollowingsViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLoved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ForLovedOnesCollectionViewCell
        cell.img.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))//#imageLiteral(resourceName: "123")//arrLoved[indexPath.row].displayImage
        cell.title.text = "\(arrLoved[indexPath.row].fName) \(arrLoved[indexPath.row].lName)"
        let sec = stringtoString_with_Format(userdate: arrLoved[indexPath.row].createdAt, input: "yyyy-MM-dd HH:mm:ss", Output: "yyyy-MM-dd")
        cell.date.text = sec
        //        cell.clipsToBounds = true
        //        cell.layer.cornerRadius = 20
        //        cell.img.layer.cornerRadius = 20
        cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        cell.backImg.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width/2-20), height: (collectionView.bounds.height/2-15))
        //         - (3 * 10))/2
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
        UserTapped = UserRoleKey.Follow.rawValue
        self.performSegue(withIdentifier: "Godt", sender: nil)
        //        alert(view: self, msg: "")
        
    }
    
}


extension ForFollowingsViewController{
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
                        let user = data["following"]?.array ?? []
                        
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
