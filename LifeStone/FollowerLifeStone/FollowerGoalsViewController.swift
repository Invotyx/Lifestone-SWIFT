//
//  FollowerGoalsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var goalupdatename = ""
var goalupdateid = ""
var goalupdateindex = 0
var objGoals = FollowerGoalsViewController()
import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class FollowerGoalsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var btnad: UIButton!
    @IBOutlet weak var colvw: UICollectionView!
    @IBOutlet weak var lblnodata: UILabel!
    @IBOutlet var pop: UIView!
    @IBOutlet weak var showtxt: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UserLOad()
        pop.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        HideShow()
    }
    

    @IBAction func btnSuportedCharity(_ sender: UIButton) {
        objdetailsFollow.btnGoalsAndAchivements()
    }
    
    func UserLOad(){
        objGoals = self
        if UserTapped == UserRoleKey.Follow.rawValue{
            btnad.isHidden = true
        }else{
            btnad.isHidden = false
        }
    }
    
    func HideShow(){
        if arrDetGoals.count == 0{
            lblnodata.isHidden = false
        }else{
            lblnodata.isHidden = true
        }
    }
    
    @IBAction func Ok(_ sender: UIButton)
    {
        
        
    }
    
    
    
    @IBAction func Cancel(_ sender: UIButton)
    {
        pop.isHidden = true
    }
    

}






extension FollowerGoalsViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDetGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! UsergetdetailCollectionViewCell
        cell.lbltitle.text = arrDetGoals[indexPath.row].title
        cell.btndel.tag = indexPath.row
        cell.btndel.addTarget(self, action: #selector(UserdeleteGoals(sender:)), for: .touchUpInside)
        return cell
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        goalupdatename = arrDetGoals[indexPath.row].title
        goalupdateid = String(arrDetGoals[indexPath.row].id)
        goalupdateindex = indexPath.row
        objdetailsFollow.updatetext.text = goalupdatename
        objdetailsFollow.btnGoalsAndAchivements1()
        print(goalupdateid)
        print(goalupdatename)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
    
    @objc func UserdeleteGoals(sender: UIButton){
        UserDeleteGoals(id: arrDetGoals[sender.tag].id, indx: sender.tag)
    }
    
    func UserDeleteGoals(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/achievement/delete"
        let parameters = [
            "achievement_id": "\(id)"
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
                            arrDetGoals.remove(at: indx)
                            self.colvw.reloadData()
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



extension FollowerGoalsViewController
{
    
    func UserUpdateGoals(Obj:String,indx: String)
    {
        var UserarrGoals: [String] = []
         
        UserarrGoals.append(Obj)
            
        
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/achievements/update"
        let parameters = [
            "ls_id": "\(indx)",
            "achievements":UserarrGoals
            
            ] as [String : Any]
        
        print(parameters)
        
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true
                    {
                        arrDetGoals.removeAll()
                        SVProgressHUD.dismiss()
                        let arrach = dic["data"]?.array ?? []
                        for item in arrach
                        {
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["achievement_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            arrDetGoals.append(obj)
                            
                        }
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            objGoals.colvw.reloadData()
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        objGoals.HideShow()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
}




