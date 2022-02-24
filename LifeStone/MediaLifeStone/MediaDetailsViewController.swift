//
//  MediaDetailsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 18/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class ImageDetail {
    var views, likes,is_liked: Int
    var comments: [Comment]
    
    init() {
        self.views = 0
        self.is_liked = 0
        self.likes = 0
        self.comments = []
    }
    
    init(views: Int, likes: Int, is_liked: Int, comments: [Comment]) {
        self.views = views
        self.likes = likes
        self.comments = comments
        self.is_liked = is_liked
    }
}

// MARK: - Comment
class Comment{
    var id, userID: Int
    var firstName, lastName, content,created_at,profile_image: String
    
    init() {
        self.id = 0
        self.userID = 0
        self.firstName = ""
        self.lastName = ""
        self.content = ""
        self.created_at = ""
        self.profile_image = ""
    }
    init(id: Int, userID: Int, firstName: String, lastName: String, content: String, created_at: String, profile_image: String) {
        self.id = id
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.content = content
        self.created_at = created_at
        self.profile_image = profile_image
        
    }
}

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD


class MediaDetailsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var obj = ImageDetail()
    @IBOutlet var popup: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var tbl1: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbllikes: UILabel!
    @IBOutlet weak var lblviews: UILabel!
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var Mainview: UIView!
    @IBOutlet weak var txtcmntp: UITextField!
    @IBOutlet weak var txtcmnt: UITextField!
    @IBOutlet weak var conview: UIView!
    
    @IBOutlet weak var lblCreatedat: UILabel!
    @IBOutlet weak var btnlike: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.GetChats()
        UserLoad()
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    @IBAction func txtcmntmain(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnLikePost(_ sender: UIButton) {
        if obj.is_liked == 0{
            obj.is_liked = 1
        }else{
            obj.is_liked = 0
        }
        self.LikePost()
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.popup.isHidden = true
    }
    
    
    @IBAction func btnSeeAll(_ sender: UIButton) {
        animate2(VC: self, Popview: popup)
    }
    
    @IBAction func btnpost(_ sender: UIButton)
    {
        self.UserCmnt()
        self.view.endEditing(true)
    }
    @IBAction func btnPost1(_ sender: UIButton) {
        self.UserCmnt()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func UserLoad(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if MoveobjUserData.type == "image"{
            img.sd_setImage(with: URL(string: MoveobjUserData.imageURL.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
            conview.alpha = 0
            img.alpha = 1
            self.lblCreatedat.isHidden = false
        }else{
            conview.alpha = 1
            img.alpha = 0
            self.lblCreatedat.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.Mainview.addGestureRecognizer(tap)
        self.Popupview.addGestureRecognizer(tap)
        //        let dateFormator = DateFormatter()
        //        dateFormator.timeZone = TimeZone.current
        //        dateFormator.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        let dtt = dateFormator.date(from: MoveobjUserData.created_at)!
        //        dateFormator.dateFormat = "MMM dd, yyyy HH:mm:ss"
        //        let sc = dateFormator.string(from: dtt)
        //        print(dtt)
        //        print(sc)
        let sc = StringtoString(userdate: MoveobjUserData.created_at)
        self.lblCreatedat.text = sc
    }
    
    
    
    //    func validatedate()->Bool{
    //           let dateFormator = DateFormatter()
    //           dateFormator.timeZone = TimeZone.current
    //           dateFormator.dateFormat = "MM/yyyy"
    //           if dateFormator.date(from: txtexpiry.text!) != nil {
    //               print(dateFormator.date(from: txtexpiry.text!) ?? "")
    //               return true
    //           } else {
    //               // invalid format
    //
    //               return false
    //           }
    //       }
    
}


////////// Handle  tablerview//////////////////
extension MediaDetailsViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl{
            if obj.comments.count>4{
                return 4
            }else if obj.comments.count<=4 || obj.comments.count>0{
                return obj.comments.count
            }else{
                return 0
            }
        }else{
            return obj.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! MediaDetailsTableViewCell
        cell.lbltitle.text = obj.comments[indexPath.row].firstName+" "+obj.comments[indexPath.row].lastName
        cell.lbldes.text = obj.comments[indexPath.row].content
        let sc = StringtoString(userdate: obj.comments[indexPath.row].created_at)
        cell.lblCreatedAt.text = sc
        //        cell.btndel.tag = indexPath.row
        //        cell.btndel.addTarget(self, action: #selector(UserdeleteLast(sender:)), for: .touchUpInside)
        cell.img.sd_setImage(with: URL(string: obj.comments[indexPath.row].profile_image.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        print(AppDelegate.personalInfo.id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let actionDelete =  UIContextualAction(style: .normal, title: "Delete", handler:
        { (action,view,completionHandler ) in
            self.DeleteEvents(indx: indexPath.row)
            tableView.reloadData()
            completionHandler(true)
        })
        actionDelete.backgroundColor = UIColor.red
        
        let configuration = UISwipeActionsConfiguration(actions: [actionDelete])
        
        if "\(AppDelegate.personalInfo.id)" == "\(obj.comments[indexPath.row].userID)"{
            return configuration
        }else{
            return nil
        }
        
        
        
        
    }
    //    @objc func UserdeleteLast(sender: UIButton)
    //    {
    //        self.DeleteEvents(indx: sender.tag)
    //    }
    
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        let userInfo = notification.userInfo!
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
}



////////// Api's /////////////
extension MediaDetailsViewController{
    
    
    ///////////////////////// AddCard Function ?????????/
    func DeleteEvents(indx:Int)  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/comment/delete"
        let parameter = ["comment_id":"\(obj.comments[indx].id)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
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
                        self.obj.comments.remove(at: indx)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                        self.tbl1.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    ///////////////////////// GetCharities Function ?????????/
    func UserCmnt()  {
        var a = ""
        if txtcmnt.text! == ""{
            a = txtcmntp.text!
        }
        if txtcmntp.text! == ""{
            a = txtcmnt.text!
        }
        if a == ""{
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlstring = AppDelegate.baseurl+"api/lifestone/comments"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        let parameters = ["attachment_id":"\(MoveobjUserData.id)",
            "comment":"\(a)"
        ]
        
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
                        DispatchQueue.main.async {
                            self.view.endEditing(true)
                            self.GetChats()
                            self.txtcmnt.text = ""
                            self.txtcmntp.text = ""
                        }
                    }
                    else{
                        self.view.endEditing(true)
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                        
                    }
                    DispatchQueue.main.async {
                    }
                case .failure(let error):
                    self.view.endEditing(true)
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    ///////////////////////// GetCharities Function ?????????/
    func LikePost()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlstring = AppDelegate.baseurl+"api/lifestone/likes"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        let parameters = ["attachment_id":"\(MoveobjUserData.id)",
            "like":"\(obj.is_liked)"]
        
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
                        DispatchQueue.main.async {
                            self.GetChats()
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
    
    ///////////////////////// GetCharities Function ?????????/
    func GetChats()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        
        let urlstring = AppDelegate.baseurl+"api/lifestone/views"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        let parameters = ["attachment_id":"\(MoveobjUserData.id)"]
        
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
                        self.obj = ImageDetail()
                        let data = dic["data"]?.dictionary ?? [:]
                        self.obj.views = data["views"]?.int ?? 0
                        self.obj.likes = data["likes"]?.int ?? 0
                        self.obj.is_liked = data["is_liked"]?.int ?? 0
                        let arr = data["comments"]?.array ?? []
                        
                        for item in arr{
                            let abj = Comment()
                            abj.id = item["id"].int ?? 0
                            abj.userID = item["user_id"].int ?? 0
                            abj.firstName = item["first_name"].string ?? ""
                            abj.lastName = item["last_name"].string ?? ""
                            abj.content = item["content"].string ?? ""
                            abj.created_at = item["created_at"].string ?? ""
                            abj.profile_image = item["profile_image"].string ?? ""
                            self.obj.comments.append(abj)
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.lbllikes.text = "\(self.obj.likes)"
                        self.lblviews.text = "\(self.obj.views)"
                        self.tbl.reloadData()
                        self.tbl1.reloadData()
                        if "\(self.obj.is_liked)" == "1"{
                            self.btnlike.setImage(UIImage(named: "liked_white"), for: .normal)
                        }else{
                            self.btnlike.setImage(UIImage(named: "unliked_white"), for: .normal)
                        }
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
}
