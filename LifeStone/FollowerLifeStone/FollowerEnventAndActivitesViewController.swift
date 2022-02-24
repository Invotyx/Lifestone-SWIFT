//
//  FollowerEnventAndActivitesViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class UserEvent {
    var id, lsID, userID: Int
    var title, userEventDescription, date, time,duration: String
    var address: String
    var lat, long, isGoing: Int
 
    init()
    {
        self.duration = ""
        self.id = 0
        self.lsID = 0
        self.userID = 0
        self.title = ""
        self.userEventDescription = ""
        self.date = ""
        self.time = ""
        self.address = ""
        self.lat = 0
        self.long = 0
        self.isGoing = 0
    }
    
    init(id: Int, lsID: Int, userID: Int, title: String, userEventDescription: String, date: String, time: String, address: String, lat: Int, long: Int, isGoing: Int,duration:String)
    {
        self.duration = duration
        self.id = id
        self.lsID = lsID
        self.userID = userID
        self.title = title
        self.userEventDescription = userEventDescription
        self.date = date
        self.time = time
        self.address = address
        self.lat = lat
        self.long = long
        self.isGoing = isGoing
    }
}

var arrevent:[UserEvent] = []
var objEvent = FollowerEnventAndActivitesViewController()

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class FollowerEnventAndActivitesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  @IBOutlet weak var btnad: UIButton!
    @IBOutlet weak var btndeleAll: UIButton!
    @IBOutlet weak var tbl: UITableView!
    var flgedit = false
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblnodata: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     UserLoad()
    }
    
    func UserLoad(){
        objEvent = self
        setupLongPressGesture()
        if UserTapped == UserRoleKey.Follow.rawValue{
            btnad.isHidden = true
        }else{
            btnad.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        HideShow()
       GetEvents()
    }
    
    @IBAction func btnAddEvent(_ sender: UIButton) {
        objdetailsFollow.AddEvent()
    }
   
    @IBAction func btnDeleteAll(_ sender: UIButton) {
        DeleteAllEvents()
    }
    
    func HideShow(){
        if arrevent.count == 0{
            lblnodata.isHidden = false
        }else{
            lblnodata.isHidden = true
        }
    }
    
    func setupLongPressGesture()
    {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press0
        longPressGesture.delaysTouchesBegan = false
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tbl.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        
        let touchPoint = gestureRecognizer.location(in: self.tbl)
        
        if tbl.indexPathForRow(at: touchPoint) != nil
        {
            if (gestureRecognizer.state == .ended) {
                //Do Whatever You want on End of Gesture
                if  flgedit{
                    flgedit = false
                    btndeleAll.isHidden = true
                    self.tbl.reloadData()
                }else{
                    flgedit = true
                    btndeleAll.isHidden = false
                    self.tbl.reloadData()
                }
            }
            
        }
    }
}




extension FollowerEnventAndActivitesViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrevent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 120
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! EventTableViewCell
        cell.vw1.setRightRadius(corners: [.topLeft, .bottomRight], cornerRadius: 40, bordercolor: UIColor.white, borderWidth: 1.5)
        cell.vw2.setRightRadius(corners: [.topLeft, .bottomRight], cornerRadius: 40, bordercolor: UIColor.white, borderWidth: 1.5)
        cell.lbltitle.text = arrevent[indexPath.row].title
        cell.lbldes.text = arrevent[indexPath.row].userEventDescription
        cell.lblmap.text = arrevent[indexPath.row].address
//        if cell.lblmap.text?.count ?? 0 <= 14
//        {
//            cell.height.constant = 15
//        }
//        else
//        {
//            cell.height.constant = 30
//        }
               
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        let dt = dateFormatterGet.date(from: arrevent[indexPath.row].date)
        cell.lbldate.text = arrevent[indexPath.row].date
//        if dt == Date()
//        {
            let dur    = "\(arrevent[indexPath.row].duration)"
            let date   = dur.split(separator:":")
            let datee1 = "Duration "+date[2]+" Hrs"
            cell.lblduration.text = datee1
//        }else{
//            let date = arrevent[indexPath.row].duration.split(separator:":")
//            let datee1 = "Duration "+date[2]+" Hrs"
//            cell.lblduration.text = datee1
//        }

        print(arrevent[indexPath.row].time)
        
        cell.lbltime.text = arrevent[indexPath.row].time
        
        cell.btnDel.tag = indexPath.row
        cell.btnDel.addTarget(self, action: #selector(UserdeleteLast(sender:)), for: .touchUpInside)
        cell.btnRsvp.tag = indexPath.row
        cell.btnRsvp.addTarget(self, action: #selector(UserIsgoing(sender:)), for: .touchUpInside)
        if  flgedit{
            cell.btnDel.isHidden = false
        }else{
            cell.btnDel.isHidden = true
        }
        if arrevent[indexPath.row].isGoing == 1{
            cell.iconisgoing.isHidden = false
            cell.btnRsvp.setTitle("GOING", for: .normal)
        }else{
            cell.iconisgoing.isHidden = true
            cell.btnRsvp.setTitle("RSVP", for: .normal)
        }
        return cell
    }
    
    @objc func UserIsgoing(sender: UIButton){
        self.Setisgoing(indx: sender.tag)
    }
    
    @objc func UserdeleteLast(sender: UIButton){
        self.DeleteEvents(indx: sender.tag)
    }
    
}






///////////////APi's/////////////////
extension FollowerEnventAndActivitesViewController{
    
    ///////////////////////// AddCard Function ?????????/
    func Setisgoing(indx:Int)  {
        var isgoing = arrevent[indx].isGoing
        if isgoing == 1{
            isgoing = 0
        }else{
            isgoing = 1
        }
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/event/rsvp"
        let parameter = ["event_id":"\(arrevent[indx].id)","is_going":"\(isgoing)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameter, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result
                {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true
                    {
                        SVProgressHUD.dismiss()
                        arrevent[indx].isGoing = isgoing
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
    
    ///////////////////////// GetEvents Function ?????????/
    func GetEvents()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/event/detail"
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
                        arrevent.removeAll()
                        SVProgressHUD.dismiss()
                        let data = dic["data"]?.array ?? []
                        print(data)
                        for item in data
                        {
                            let obj = UserEvent()
                            obj.id = item["id"].int ?? 0
                            obj.lsID = item["ls_id"].int ?? 0
                            obj.lat = item["lat"].int ?? 0
                            obj.long = item["long"].int ?? 0
                            obj.duration = item["duration"].string ?? ""
                            obj.isGoing = item["is_going"].int ?? 0
                            obj.userID = item["user_id"].int ?? 0
                            obj.time = item["time"].string ?? ""
                            obj.address = item["address"].string ?? ""
                            obj.userEventDescription = item["description"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.date = item["date"].string ?? ""
                            arrevent.append(obj)
                        }
                    }
                    else
                    {
                        arrevent.removeAll()
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                        self.HideShow()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    ///////////////////////// DeleteEvents Function ?????????/
    func DeleteEvents(indx:Int)  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/event/delete"
        let parameter = ["event_id":"\(arrevent[indx].id)"]
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
                        arrevent.remove(at: indx)
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                        if  self.flgedit{
                            self.flgedit = false
                            self.btndeleAll.isHidden = true
                            self.tbl.reloadData()
                        }
                        else{
                            self.flgedit = true
                            self.btndeleAll.isHidden = false
                            self.tbl.reloadData()
                        }
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    ///////////////////////// DeleteAllEvents Function ?????????/
    func DeleteAllEvents()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/event/delete/all"
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
                        
                        SVProgressHUD.dismiss()
                        arrevent.removeAll()
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                        if  self.flgedit{
                            self.flgedit = false
                            self.btndeleAll.isHidden = true
                            self.tbl.reloadData()
                        }else{
                            self.flgedit = true
                            self.btndeleAll.isHidden = false
                            self.tbl.reloadData()
                        }
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
}
