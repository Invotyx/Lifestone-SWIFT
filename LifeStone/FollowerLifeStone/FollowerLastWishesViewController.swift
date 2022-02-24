//
//  FollowerLastWishesViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var objLast = FollowerLastWishesViewController()
import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class FollowerLastWishesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnad: UIButton!
    @IBOutlet weak var LastWisg_colvw: UICollectionView!
    @IBOutlet weak var lblnodata: UILabel!
    
    var flgUpdate = false
    var indx = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      UserLoad()
//        HideShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        HideShow()
    }
    
    @IBAction func btnSuportedCharity(_ sender: UIButton) {
        flgUpdate = false
        objdetailsFollow.btnLastWish()
    }
    
    func UserLoad(){
        objLast = self
        if UserTapped == UserRoleKey.Follow.rawValue{
            btnad.isHidden = true
        }else{
            btnad.isHidden = false
        }
    }
    func HideShow(){
        if arrdetwish.count == 0{
            lblnodata.isHidden = false
        }else{
            lblnodata.isHidden = true
        }
    }
}








extension FollowerLastWishesViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrdetwish.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! UsergetdetailCollectionViewCell
        cell.lbltitle.text = arrdetwish[indexPath.row].title
        cell.btndel.tag = indexPath.row
        cell.btndel.addTarget(self, action: #selector(UserdeleteLast(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indx = indexPath.row
        flgUpdate = true
        objdetailsFollow.OpenLastWish()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width-50), height: 40)
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
    
    @objc func UserdeleteLast(sender: UIButton){
        UserDeleteLastwish(id: arrdetwish[sender.tag].id, indx: sender.tag)
    }
    
    func UserDeleteLastwish(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/wish/delete"
        let parameters = [
            "wish_id": "\(id)"
            ] as [String : Any]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
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
                            arrdetwish.remove(at: indx)
                            self.LastWisg_colvw.reloadData()
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.HideShow()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }

}
