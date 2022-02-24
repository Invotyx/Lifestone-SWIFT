//
//  PaymentDetailsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class CreditCards{
    var id: Int
    var  type, expiry,last_four: String
    var is_default:Int
    
    init() {
        is_default = 0
        self.id = 0
        self.type = ""
        expiry = ""
        last_four = ""
    }
    
    init(id: Int, is_default: Int, expiry: String, type: String, last_four: String) {
        self.id = id
        self.is_default = is_default
        self.expiry = expiry
        self.type = type
        self.last_four = last_four
    }
    
    
}
var objpay = PaymentDetailsViewController()
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PaymentDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    var cardid = ""
    @IBOutlet weak var tbl: UITableView!
    var arr:[CreditCards] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       objpay = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         GetCardList()
    }
    
}





extension PaymentDetailsViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 200
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! PaymentDetailTableViewCell
        cell.lblcardno.text = "************"+arr[indexPath.row].last_four
        cell.lblexpiry.text = arr[indexPath.row].expiry
        
        cell.btndelete.tag = indexPath.row
        cell.btndelete.addTarget(self, action: #selector(deleteCard(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to pay with this card ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.cardid = "\(self.arr[indexPath.row].id)"
            self.UseCard()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteCard(sender: UIButton){
        DeleteCardList(Id:arr[sender.tag].id,Indx: sender.tag)
        
    }
    
}







extension PaymentDetailsViewController{
    
    
    
    ///////////////////////// AddCard Function ?????????/
    func UseCard()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/payment"
        let headers = ["Content-Type":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"]
        let para = [
            "user_subscription_id":"\(user_subscription_id)",
            "card_id":"\(cardid)"
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
                        self.arr.removeAll()
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentMessageViewController") as! PaymentMessageViewController
                        
                        vc.isError   = false
                        vc.titles    = "PAYMENT RECIEVED"
                        vc.subTitle  = "Your subscription is now active"
                        vc.msg       = "\(message)"
                        
                        
                        self.showDetailViewController(vc, sender: self)
//                        alert3(view: self, msg: message)
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentMessageViewController") as! PaymentMessageViewController
                        vc.isError   = true
                        vc.titles    = "Bummer!"
                        vc.subTitle  = "Your payment was not processed unfortunately"
                        vc.msg       = "\(message)"
                          
                        self.showDetailViewController(vc, sender: self)
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
    
    ///////////////////////// UserLogin Function ?????????/
    func DeleteCardList(Id: Int,Indx:Int)  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/card/delete"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        let para = [
            "card_id":"\(Id)"
        ]
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
                        self.GetCardList()
                        if self.arr.count > 0{
                            self.arr.remove(at: Indx)
                            self.tbl.reloadData()
                        }else{
                            self.arr.removeAll()
                            self.tbl.reloadData()
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
    func GetCardList()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/cards"
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
                        self.arr.removeAll()
                        let data = dic["cards"]?.array ?? []
                        SVProgressHUD.dismiss()
                        for item in data{
                            let obj = CreditCards()
                            obj.id = item["id"].int ?? 0
                            obj.expiry = item["expiry"].string ?? ""
                            obj.last_four = "\(item["last_four"].int ?? 0)"
                            obj.is_default = item["is_default"].int ?? 0
                            obj.type = item["type"].string ?? ""
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
    
}
