//
//  SettingsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 27/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var obj = SettingsViewController()

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arr = ["About","Notifications","FAQs","Rate us","Terms of use","Change Password"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//       UserAppear()
    }
    override func viewDidAppear(_ animated: Bool) {
//        UserAppear()
    }
    @IBAction func btnback(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnlogout(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "loginstatus")
        updateRootView()
    }
    @IBAction func btndelete(_ sender: UIButton) {
        DeleteProfile()
    }
    @IBAction func btninsta(_ sender: UIButton) {
         alert(view: self, msg: "")
    }
    @IBAction func btntwitter(_ sender: UIButton) {
         alert(view: self, msg: "")
    }
    @IBAction func btnfb(_ sender: UIButton) {
         alert(view: self, msg: "")
    }
    
    func UserAppear(){
        AppDelegate.personalInfo = Read_UD()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = #colorLiteral(red: 0.3882352941, green: 0.6823529412, blue: 0.5725490196, alpha: 1)
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3882352941, green: 0.6823529412, blue: 0.5725490196, alpha: 1)]
        obj = self
    }
    
}

extension SettingsViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 50
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! SettingsTableViewCell
        cell.lbltilte.text = arr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4{
            self.performSegue(withIdentifier: "terms", sender: nil)
        }
        else if indexPath.row == 1{
            self.performSegue(withIdentifier: "noti", sender: nil)
        }
        else if indexPath.row == 0{
            self.performSegue(withIdentifier: "about", sender: nil)
        }
       else if indexPath.row == 5
        {
            if UserDefaults.standard.bool(forKey: "Social") == true
            {
                alert3(view: self, msg: "Account is registered through Social Login, please change your password through that Scoial platform.")
            }
            else
            {
                self.performSegue(withIdentifier: "change", sender: nil)
            }
        }
        else
        {
            alert(view: self, msg: "")
        }
    }
    
    ///////////////////////// logoutProfile Function ?????????/
    func logoutProfile()  {
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/logout"
        let parameter = ["device_id":"\(AppDelegate.devToken)"]
        let headers = ["Token":"\(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .post, parameters: parameter, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success {
                        UserDefaults.standard.set(false, forKey: "loginstatus")
                        self.performSegue(withIdentifier: "logout", sender: nil)
//                        updateRootView()
                    }
                    else{
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    ///////////////////////// DeleteProfile Function ?????????/
    func DeleteProfile()  {
        SVProgressHUD.show(withStatus: "Loading")
            let urlstring = AppDelegate.baseurl+"api/profile/delete"
            let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
            Alamofire.request (urlstring ,method : .post, parameters: nil, encoding
                : JSONEncoding.default,headers: headers).responseJSON { response in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.boolValue ?? false
                        if success {
                            UserDefaults.standard.set(false, forKey: "loginstatus")
                            updateRootView()
                        }
                        else{
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                        }
                        case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
    }


}
