//
//  UpgradeViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

class UserUpgrade{
    var id: Int
    var status, title, type, price: String
    var is_checked:Bool
    
    init() {
        title = ""
        price = ""
        is_checked = false
        self.id = 0
        self.status = ""
        self.type = ""
        self.price = ""
    }
    
    init(id: Int, status: String, title: String, type: String, price: String,is_checked:Bool) {
        self.id = id
        self.status = status
        self.title = title
        self.type = type
        self.price = price
        self.is_checked = is_checked
    }
    
    
}
var user_subscription_id = -1
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Stripe

class UpgradeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var txtcop: UITextField!
    var type = ""
    var UserSelected = ""
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var bottm: NSLayoutConstraint!
    @IBOutlet weak var tbl: UITableView!
    var arr:[UserUpgrade] = []
    var subscription_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        arr.append(UserUpgrade.init(title: "Freemium", price: "$ 0.00", is_checked: true))
//        arr.append(UserUpgrade.init(title: "Preemium", price: "$ 2.99", is_checked: false))
        
        GetActiveSubscription()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        vw.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.8)
         self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = AppDelegate.linecolor//or.lightGray
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppDelegate.linecolor]
      
    }
    
    
    @IBAction func Buynow(_ sender: Any) {
        if subscription_id == ""{
            return
        }
        BuySubscriptions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnback(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}





extension UpgradeViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 64
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! UpgradeTableViewCell
        cell.lblttile.text = arr[indexPath.row].title
        cell.lblprice.text = "$ "+arr[indexPath.row].price
        
        cell.btnradio.tag = indexPath.row
        cell.btnradio.addTarget(self, action: #selector(radio(sender:)), for: .touchUpInside)
        if  arr[indexPath.row].is_checked{
            cell.btnradio.setImage(#imageLiteral(resourceName: "Rbtn"), for: .normal)
        }else{
            cell.btnradio.setImage(#imageLiteral(resourceName: "UnRbtn"), for: .normal)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in arr{
            item.is_checked = false
        }
        if indexPath.row == 0{
            AppDelegate.personalInfo.subscription = "Freemium"
        }else{
            AppDelegate.personalInfo.subscription = "Premium"
        }
        arr[indexPath.row].is_checked = true
        subscription_id = "\(arr[indexPath.row].id)"
        UserSelected = "\( arr[indexPath.row].id)"
        print(UserSelected)
        self.tbl.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottm.constant = 200
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottm.constant = 8
    }
    
    
    @objc func radio(sender:UIButton){
        for item in arr{
            item.is_checked = false
        }
        UserSelected = "\( arr[sender.tag].id)"
        print(UserSelected)
        arr[sender.tag].is_checked = true
        subscription_id = "\(arr[sender.tag].id)"
        self.tbl.reloadData()
    }
    
    
    
}







extension UpgradeViewController{
    ///////////////////////// UserLogin Function ?????????/
    func GetActiveSubscription()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/subscription/active"
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
                        let data = dic["subscription"]?.dictionary ?? [:]
                        let typee = "\(data["subscription_id"]?.int ?? 0)"
                        print(typee)
                        self.type = typee
                        DispatchQueue.main.async {
                            self.GetSubscriptions()
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
    
    
    
    ///////////////////////// UserLogin Function ?????????/
    func GetSubscriptions()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/subscriptions"
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
                        let data = dic["subscriptions"]?.array ?? []
                        let user = data[0].array ?? []
                        print(user)
                        SVProgressHUD.dismiss()
                        for item in user{
                            let obj = UserUpgrade()
                            obj.id = item["id"].int ?? 0
                            obj.price = item["price"].string ?? ""
                            obj.status = item["status"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.type = item["type"].string ?? ""
                            if self.type == "\(obj.id)" {
                                obj.is_checked = true
                                self.subscription_id = "\(obj.id)"
                            }else{
                                obj.is_checked = false
                            }
                            self.arr.append(obj)
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    ///////////////////////// UserLogin Function ?????????/
    func BuySubscriptions()  {
        let cop = txtcop.text!
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/subscribe"
        let headers = ["Content-Type":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
        let para = [
            "subscription_id":"\(subscription_id)",
            "coupon_id":"\(cop)"
        ]
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
                        user_subscription_id = dic["user_subscription_id"]?.int ?? 0
                        
                        if self.UserSelected == "1"{
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        else{
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "PaymentDetail", sender: nil)
                            }
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
