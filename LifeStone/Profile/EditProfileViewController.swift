//
//  EditProfileViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 25/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    @IBOutlet weak var backimage: UIImageView!
    @IBOutlet weak var lblcreatedat: UILabel!
    @IBOutlet weak var lblMySite: UILabel!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var lblsuported: UILabel!
    @IBOutlet weak var lblprofiles: UILabel!
    
    var arr1:[userSideMenu] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       UserApear()
    }
    override func viewDidAppear(_ animated: Bool) {
        UserLoad()
    }
    func UserApear(){
        self.tabBarController?.tabBar.isHidden = true
        AppDelegate.personalInfo = Read_UD()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        let nav = self.navigationController?.navigationBar
//        nav?.tintColor = #colorLiteral(red: 0.3882352941, green: 0.6823529412, blue: 0.5725490196, alpha: 1)//or.lightGray
//        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3882352941, green: 0.6823529412, blue: 0.5725490196, alpha: 1)]
        lblMySite.text = AppDelegate.personalInfo.firstName+" \nYour life stone sites"
        lblsuported.text = AppDelegate.personalInfo.charities_count
        lblprofiles.text = AppDelegate.personalInfo.lifestones_count
        lblcreatedat.text = "Created on "+AppDelegate.personalInfo.created_at
         userimage.sd_setImage(with: URL(string: AppDelegate.personalInfo.display_image), placeholderImage: UIImage(named: "123"))
        backimage.sd_setImage(with: URL(string: AppDelegate.personalInfo.display_image), placeholderImage: UIImage(named: "123"))
    }
    
    func UserLoad(){
        arr1.removeAll()
        vw2.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 72, height: 72), cornerRadius: 37.5, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
        arr1.append(userSideMenu.init(img: "First Name", name: "\(AppDelegate.personalInfo.firstName.capitalized)"))
        arr1.append(userSideMenu.init(img: "Last Name", name: "\(AppDelegate.personalInfo.lastName.capitalized)"))
        arr1.append(userSideMenu.init(img: "Date of Birth", name: "\(AppDelegate.personalInfo.dob)"))
        arr1.append(userSideMenu.init(img: "Gender", name: "\(AppDelegate.personalInfo.gender.capitalized)"))
        arr1.append(userSideMenu.init(img: "Subscribed Package", name: AppDelegate.personalInfo.subscription))
        userimage.sd_setImage(with: URL(string: AppDelegate.personalInfo.profileImage), placeholderImage: UIImage(named: "user"))
        self.tbl.reloadData()
    }
    
    @IBAction func btnback(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension EditProfileViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 35
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! EditProfileTableViewCell
        cell.lbltitle.text = arr1[indexPath.row].img
        cell.lbldes.text = arr1[indexPath.row].name
        return cell
    }
    
}
