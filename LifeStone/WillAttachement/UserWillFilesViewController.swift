//
//  UserWillFilesViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
 var arrFiles:[Attachment] = []
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class UserWillFilesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
   var flgedit = false
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnedit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tbl.dragInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetUserWillDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    @IBAction func btnEdit(_ sender: UIButton) {
        edit()
    }
    
    func edit(){
        if flgedit{
            self.tbl.isEditing = false
            flgedit = false
            btnedit.setTitle("Edit", for: .normal)
        }else{
            self.tbl.isEditing = true
            flgedit = true
            btnedit.setTitle("Cancel", for: .normal)
        }
        self.tbl.reloadData()
    }
    
}


extension UserWillFilesViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(arrFiles[indexPath.row].type) \(arrFiles[indexPath.row].id)"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        str = arrFiles[indexPath.row].imageURL
        self.performSegue(withIdentifier: "openpdf", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            UserDeleteMedia(id:arrFiles[indexPath.row].id,indx:indexPath.row)
        }
    }
 
}

extension UserWillFilesViewController{
    
    func UserDeleteMedia(id:Int,indx:Int){
        
        var UserMedia: [NSMutableDictionary] = []
                let data = NSMutableDictionary()
                data.addEntries(from: ["id" : "\(id)"])
                UserMedia.append(data)
       
        SVProgressHUD.show(withStatus: "Deleting...")
        let urlstring = AppDelegate.baseurl+"api/will/attachment/delete"
        let parameters = [
            "attachments":UserMedia
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
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                        if arrFiles.count == 1 || arrFiles.count == 0{
                            arrFiles.removeAll()
                        }else{
                            arrFiles.remove(at: indx)
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
    
    func GetUserWillDetails(){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/detail"
        let para = ["ls_id":"\(objtofollow.id)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        arrFiles.removeAll()
                        SVProgressHUD.dismiss()
                        let data = dic["data"]?.dictionary ?? [:]
                        
                        let arrAttachments = data["attachments"]?.array ?? []
                        for item in arrAttachments{
                            let lbj = Attachment()
                            lbj.id = item["id"].int ?? 0
                            lbj.type = item["type"].string ?? ""
                            lbj.imageURL = item["image_url"].string ?? ""
                            lbj.thumbURL = item["thumb_url"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            if  lbj.type == "document"{
                                arrFiles.append(lbj)
                            }
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
