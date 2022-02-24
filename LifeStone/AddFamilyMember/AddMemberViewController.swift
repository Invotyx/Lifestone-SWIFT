//
//  AddMemberViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 24/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class Relation: Codable {
    var id: Int
    var title, slug, level: String
    init() {
        self.id = 0
        self.title = ""
        self.slug = ""
        self.level = ""
    }
    init(id: Int, title: String, slug: String, level: String) {
        self.id = id
        self.title = title
        self.slug = slug
        self.level = level
    }
}

var seleRelation = Relation()
var arrRelation:[Relation] = []


import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage
class AddMemberViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    @IBOutlet weak var tbl: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetData()
    }
    
    @IBAction func btnCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRelation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 50
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! AddMemberTableViewCell
        cell.lbltitle.text = arrRelation[indexPath.row].title
        if indexPath.row == arrRelation.count-1{
           tableView.separatorStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleRelation = arrRelation[indexPath.row]
        self.performSegue(withIdentifier: "gosele", sender: nil)
    }
    
    
    //////////////////////// GetData Function ?????????/
    func GetData()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/roles"
       
        Alamofire.request (urlstring ,method : .get, parameters: nil, encoding
            : JSONEncoding.default,headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
                        SVProgressHUD.dismiss()
                        let arr = dic["data"]?.array ?? []
                        arrRelation.removeAll()
                        for item in arr{
                            if datatosnd.level == 1{
                                let obj = Relation()
                                obj.id = item["id"].int ?? 0
                                obj.title = item["title"].string ?? ""
                                obj.level = item["level"].string ?? ""
                                obj.slug = item["slug"].string ?? ""
                                if obj.id != 1 || obj.id != 2{
                                    arrRelation.append(obj)
                                }
                            }
                           else if datatosnd.level == -1{
                                let obj = Relation()
                                obj.id = item["id"].int ?? 0
                                obj.title = item["title"].string ?? ""
                                obj.level = item["level"].string ?? ""
                                obj.slug = item["slug"].string ?? ""
                                if obj.id != 3 || obj.id != 4{
                                    arrRelation.append(obj)
                                }
                            }else{
                                let obj = Relation()
                                obj.id = item["id"].int ?? 0
                                obj.title = item["title"].string ?? ""
                                obj.level = item["level"].string ?? ""
                                obj.slug = item["slug"].string ?? ""
                                    arrRelation.append(obj)
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
