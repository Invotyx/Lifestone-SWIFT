//
//  NotificationsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 28/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class UserNotifications{
    var first_name: String
    var last_name: String
     var image: String
     var content: String
    var created_at:Date
    init() {
        first_name = ""
        last_name = ""
        image = ""
        content = ""
        created_at = Date()
    }
    init(first_name: String,last_name: String,image: String,content: String,created_at:Date) {
        self.first_name = first_name
        self.last_name = last_name
        self.image = image
        self.content = content
        self.created_at = created_at
    }
}
import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage
import SideMenu

class NotificationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var hamshown2 = false
    var arrNoti:[UserNotifications] = []
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var lblnodata: UILabel!
    @IBOutlet weak var tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetData()
//        setDefaults()
//        setupSideMenu()
        setupSideMenu()
        updateMenus()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tbl.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UserAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UserAppear()
    }
    
    @IBAction func btnham(_ sender: UIBarButtonItem) {
          if !hamshown2{
              self.performSegue(withIdentifier: "shoeleft", sender: nil)
          }
      }
    
    func UserAppear(){
        AppDelegate.personalInfo = Read_UD()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.6039215686, blue: 0.8274509804, alpha: 1)
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        GetData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrNoti.count == 0{
            lblnodata.isHidden = false
        }else{
            lblnodata.isHidden = true
        }
        return arrNoti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 102
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! HomeTableViewCell
        cell.lbldes.text = arrNoti[indexPath.row].content
        cell.img.sd_setImage(with: URL(string:  arrNoti[indexPath.row].image.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "user"))
        return cell
    }
    
    //////////////////////// GetData Function ?????????/
    func GetData()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/newsfeed"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .get, parameters: nil, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success
                    {
                        SVProgressHUD.dismiss()
                        self.refreshControl.endRefreshing()
                        self.arrNoti.removeAll()
                        let data = dic["data"]?.array ?? []
                        for item in data{
                            let obj = UserNotifications()
                            obj.first_name = item["first_name"].string ?? ""
                            obj.last_name = item["last_name"].string ?? ""
                            obj.image = item["image"].string ?? ""
                            obj.content = item["content"].string ?? ""
                            let datee = item["created_at"].string ?? ""
                            let splits = datee.split(separator: " ")
                            let date1 = String(splits[0])
                            let time = String(splits[1])
                            
                            let start_timee:Date = self.datetimeFormatter.date(from: "\(date1) \(time)") ?? Date()
                            print(start_timee)
                            
                            obj.created_at = start_timee
                            
                            self.arrNoti.append(obj)
                            self.arrNoti.reverse()
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        _ = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(self.arrNoti.count, forKey: "NotificationCount")
                        self.tbl.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
    }
    
    
    lazy var datetimeFormatter: DateFormatter =
        {
           let formatter = DateFormatter()
           formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
           return formatter
       }()
    
}



//extension NotificationsViewController: UISideMenuNavigationControllerDelegate {
//
//    public func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appearing! (animated: \(animated))")
//        //        blurview.isHidden = false
//    }
//
//    public func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appeared! (animated: \(animated))")
//        hamshown2 = true
//    }
//
//    public func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappearing! (animated: \(animated))")
//    }
//
//    public func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappeared! (animated: \(animated))")
//        hamshown2 = false
//        //        blurview.isHidden = true
//        //        UIApplication.shared.isStatusBarHidden = false
//    }
//
//    fileprivate func setupSideMenu() {
//        // Define the menus
//        SideMenuManager.default.menuLeftNavigationController = nil
//        SideMenuManager.default.menuRightNavigationController = nil
//        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
//
//
//        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
//        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
//        //
//        ////        SideMenuManager.default.menuLeftNavigationController = nil
//        //        SideMenuManager.default.menuRightNavigationController = nil
//    }
//
//    fileprivate func setDefaults() {
//
//        let modes:[SideMenuManager.MenuPresentMode] = [.menuSlideIn, .viewSlideOut, .viewSlideInOut, .menuDissolveIn]
//        SideMenuManager.default.menuPresentMode = modes[0]
//
//        SideMenuManager.default.menuAnimationFadeStrength = 0.8//0.0884956
//
//        SideMenuManager.default.menuShadowOpacity = 1//0.955752
//
//        SideMenuManager.default.menuAnimationTransformScaleFactor = 1   //1.00345
//
//        SideMenuManager.default.menuWidth = view.frame.width * CGFloat(0.8)
//
//        SideMenuManager.default.menuFadeStatusBar = false
//        let styles:[UIBlurEffect.Style] = [.dark, .light, .extraLight]
//        //        let styles:[UIBlurEffect.Style] = [.dark, .light, .extraLight]
//        SideMenuManager.default.menuBlurEffectStyle = styles[0]
//
//        //        print(SideMenuManager.default.menuPresentMode)
//        //        print(SideMenuManager.default.menuAnimationFadeStrength)
//        //        print(SideMenuManager.default.menuShadowOpacity)
//        //        print(SideMenuManager.default.menuAnimationTransformScaleFactor)
//        //        print(SideMenuManager.default.menuWidth)
//        //
//    }
//
//}


extension NotificationsViewController: SideMenuNavigationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }

    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }

    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        let modes: [SideMenuPresentationStyle] = [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        return modes[0]
    }

    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = UIColor.darkGray//UIColor(named: "colorPrimary")!
        presentationStyle.menuStartAlpha = 0.2992315
        presentationStyle.menuScaleFactor = 1.0
        presentationStyle.onTopShadowOpacity = 0.037944254
        presentationStyle.presentingEndAlpha = 0.30307394
        presentationStyle.presentingScaleFactor = 1.0
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * CGFloat(0.8)
        let styles:[UIBlurEffect.Style?] = [nil, .dark, .light, .extraLight]
        settings.blurEffectStyle = styles[0]
        settings.statusBarEndAlpha = 0.0
        return settings
    }
}
