//
//  SideMenuViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class userSideMenu{
    var img,name:String
    init() {
        self.img = ""
        self.name = ""
    }
    init(img: String,name: String) {
        self.img = img
        self.name = name
    }
}
var objsideMenu = SideMenuViewController()
import UIKit
import SDWebImage
class SideMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
     var arr1:[userSideMenu] = []
    @IBOutlet weak var img: RoundUIImage!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var ham: UIView!
    @IBOutlet weak var lblversion: UILabel!
    @IBOutlet weak var lblfname: UILabel!
    @IBOutlet weak var lbllnmae: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UserLoad()
        objsideMenu = self
    }
    
    func UserLoad(){
        AppDelegate.personalInfo = Read_UD()
        arr1.append(userSideMenu.init(img: "Home", name: "Home"))
//        arr1.append(userSideMenu.init(img: "familypond", name: "Family Pond"))
        arr1.append(userSideMenu.init(img: "Settings", name: "Settings"))
        arr1.append(userSideMenu.init(img: "Phone", name: "Contact Us"))
        arr1.append(userSideMenu.init(img: "Share", name: "Share"))
        lblversion.text = "V \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")"
        lblfname.text = AppDelegate.personalInfo.firstName
        lbllnmae.text = AppDelegate.personalInfo.lastName
        img.sd_setImage(with: URL(string: AppDelegate.personalInfo.profileImage), placeholderImage: UIImage(named: "123"))
        vw2.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 72, height: 72), cornerRadius: 36, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
    }
    
}

extension SideMenuViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 53
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! SideMenuTableViewCell
        cell.title.text = arr1[indexPath.row].name
        cell.img.image = UIImage(named: arr1[indexPath.row].img)
        return cell
    }
    
    @IBAction func tapGesture(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "profile", sender: nil)
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cs = indexPath.row
        switch  cs
        {
        case 0:
            self.dismiss(animated: true, completion: nil)
          
            
            
            break
        case 1://familytree
//            DispatchQueue.main.async
//            {
//                if objHome.hamshown
//                {
//                     self.dismiss(animated: true, completion: nil)
//                     objHome.gotoPond()
//                }
//                if objPromo.hamshown1{
//                    self.dismiss(animated: true, completion: nil)
//                    objPromo.gotopond()
//                }
//                if objContainer.hamshown2
//                {
//                    self.dismiss(animated: true, completion: nil)
//                }
//                if objself.hamshown1
//                {
//                    self.dismiss(animated: true, completion: nil)
//                    objself.gotoPond()
//                }
//
//            }
            self.performSegue(withIdentifier: "settings", sender: nil)
            break
        case 2:
            self.performSegue(withIdentifier: "contact", sender: nil)
            break
        case 3:
//           self.performSegue(withIdentifier: "Share", sender: nil)
            share(sender: self.view)
            break
        case 4:
            alert(view: self, msg: "")
            break
        case 5:
            alert(view: self, msg: "")
            break
        case 6:
            alert(view: self, msg: "")
            break
        case 7:
            alert(view: self, msg: "")
            break
        default:
            print("some thing went wrong")
        }
    }
    func share(sender:UIView)
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        let textToShare = "Hey,Do you have difficulties meeting your daily Targets and Deadlines? Try out PERSIST. It controls all your daily To-Do in one place nice and neat. Try it Now For Free!http://www.persist-app.com"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id123")
        {//Enter link to your app here
            let objectsToShare = ["", myWebsite, image ?? #imageLiteral(resourceName: "Utilitarian")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }    }
}
