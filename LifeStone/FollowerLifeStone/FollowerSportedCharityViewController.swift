//
//  FollowerSportedCharityViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

var objsuport = FollowerSportedCharityViewController()

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class FollowerSportedCharityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    var arr:[CreditCards] = []
    
    var cardid = ""
    var id = ""
    var datee = ""
    @IBOutlet weak var tbl1: UITableView!
    @IBOutlet weak var txtexpiry: UITextField!
    @IBOutlet weak var txtcvc: UITextField!
    @IBOutlet weak var txtcardNumber: UITextField!
    @IBOutlet weak var txtcardholdr: UITextField!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var btnad: UIButton!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var txtamount: UITextField!
    @IBOutlet weak var lblnodata: UILabel!
    
    @IBOutlet var popup1: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var tblheight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dtp.minimumDate = Date()
        dtp.setValue(UIColor.white, forKey: "textColor")
         UserLOad()
    }
    override func viewDidAppear(_ animated: Bool) {
        HideShow()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.tbl.reloadData()
         GetCardList()
    }
    
    @IBAction func btndob(_ sender: UIButton) {
        self.view.endEditing(true)
        
        blurView.isHidden = false
        animate2(VC: self, Popview: popup1)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        let format1 = DateFormatter()
        format1.dateFormat = "MM/yyyy"
        format1.timeZone = TimeZone.current
        datee = format1.string(from: dtp.date)
        txtexpiry.text = datee
        dtp.date = Date()
        popup1.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func btnUserCancel (_ sender: UIButton) {
        blurView.isHidden = true
        popup1.isHidden = true
    }
    

    func HideShow(){
        if arrdetcharity.count == 0{
            lblnodata.isHidden = false
        }else{
            lblnodata.isHidden = true
        }
    }
    
    @IBAction func TxtHolder(_ sender: UITextField) {
        txtcardNumber.becomeFirstResponder()
    }
    
    @IBAction func txtNumber(_ sender: Any) {
        txtcvc.becomeFirstResponder()
    }
    
    @IBAction func txtCV(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func txtDate(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        popup.isHidden = true
    }
    
    @IBAction func btnSuportedCharity(_ sender: UIButton) {
        popup.isHidden = true
        objdetailsFollow.OpenPopup()
    }

    @IBAction func btnSubmit(_ sender: UIButton) {
        btnPay()
    }
    
    func UserLOad(){
        objsuport = self
        if UserTapped == UserRoleKey.Follow.rawValue{
            btnad.isHidden = true
        }else{
            btnad.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}





extension FollowerSportedCharityViewController{
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        ScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero //UIEdgeInsetsZero
        ScrollView.contentInset = contentInset
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl1{
            if arr.count == 0{
                tblheight.constant = 0
            }else{
                tblheight.constant = 135
            }
            return arr.count
        }else{
            return arrdetcharity.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl1{
            tableView.rowHeight = 200
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! PaymentDetailTableViewCell
            cell.lblcardno.text = "************"+arr[indexPath.row].last_four
            cell.lblexpiry.text = arr[indexPath.row].expiry
            return cell
        }else{
            tableView.rowHeight = 150
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! FollowerSuportedcharityTableViewCell
            if indexPath.row%2 != 0{
                cell.bkimg.isHidden = true
                cell.btn.tintColor = UIColor.black
            }else{
                cell.bkimg.isHidden = false
                cell.btn.tintColor = UIColor.white
            }
            cell.lbltitle.text = arrdetcharity[indexPath.row].title
            cell.lbldes.text = arrdetcharity[indexPath.row].charitiesDescription
            cell.btn.tag = indexPath.row
            cell.btn.addTarget(self, action: #selector(Userdelete(sender:)), for: .touchUpInside)
            cell.btndonate.tag = indexPath.row
            cell.btndonate.addTarget(self, action: #selector(UserOpenPoup(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbl1{
            self.txtcardNumber.text = self.arr[indexPath.row].last_four
            self.cardid =  "\(self.arr[indexPath.row].id)"
        }
    }
    
    @objc func UserOpenPoup(sender: UIButton){
        id = "\(arrdetcharity[sender.tag].subid)"
        print(id)
        objdetailsFollow.cncelAllpopups()
        animateFull(VC: self, Popview: popup)
    }
    
    @objc func Userdelete(sender: UIButton){
        UserDeleteCharity(id: arrdetcharity[sender.tag].id, indx: sender.tag)
    }
    
}









extension FollowerSportedCharityViewController{
    
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
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
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
    
    func btnPay() {
        
        if txtcardNumber.text == ""{
            alert3(view: self, msg: "Please enter card number")
            return
        }
        
        if txtamount.text == ""{
            alert3(view: self, msg: "Please enter valid Amount")
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/charity/donate"
        let parameters = [
            "charity_id": "\(id)",
            "amount":"\(txtamount.text!)",
            "card_id":"\(self.cardid)"
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
                            self.txtamount.text = ""
                            self.txtcardholdr.text = ""
                            self.txtcardNumber.text = ""
                            self.txtcvc.text = ""
                            self.cardid = ""
                            self.id = ""
                            self.popup.isHidden = true
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
    
    func validatedate()->Bool{
        let dateFormator = DateFormatter()
        dateFormator.timeZone = TimeZone.current
        dateFormator.dateFormat = "MM/yyyy"
        if dateFormator.date(from: txtexpiry.text!) != nil {
            print(dateFormator.date(from: txtexpiry.text!) ?? "")
            return true
        } else {
            // invalid format
            
            return false
        }
    }
    
    func UserDeleteCharity(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/charity/delete"
        let parameters = [
            "charity_id": "\(id)"
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
                            arrdetcharity.remove(at: indx)
                            self.tbl.reloadData()
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
