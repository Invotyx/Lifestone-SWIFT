//
//  HomeViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var objHome = HomeViewController()
import UIKit
import SideMenu
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage
class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    var Social_Login = false
    
    
   lazy var datetimeFormatter: DateFormatter =
           {
              let formatter = DateFormatter()
              formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
              return formatter
          }()
    lazy var datetimeFormatter_UTC: DateFormatter =
        {
           let formatter = DateFormatter()
           formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
           formatter.timeZone = TimeZone(abbreviation: "UTC")
           return formatter
       }()
    lazy var dateFormatterNew: DateFormatter =
     {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    var arrNoti:[UserNotifications] = []
    @IBOutlet weak var pagecontrol: UIPageControl!
    var arr2: [userSideMenu] = []
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var barbtn: UIBarButtonItem!
    @IBOutlet weak var lbl1: UILabel!
    var start = 0
    var end = 0
    var Position = 0
    var hamshown = false
    var menu_vc : SideMenuViewController!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        setupSideMenu()
        updateMenus()
        AppDelegate.personalInfo = Read_UD()
        arr2.append(userSideMenu.init(img: "create", name: "Create New LifeStone"))
        arr2.append(userSideMenu.init(img: "existing", name: "Existing LifeStone"))
        arr2.append(userSideMenu.init(img: "Lifestone", name: "LifeStone"))
        arr2.append(userSideMenu.init(img: "Pond", name: "Family Pond"))
        
        objHome = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserLoadData()
        pagecontrol.currentPage = 0
        pagecontrol.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        AppDelegate.personalInfo = Read_UD()
        lbl.text = "Hey \(AppDelegate.personalInfo.firstName)"
        GetData()
//        chkfornotification()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UserLoadData()
    }
    
    @IBAction func btnham(_ sender: UIBarButtonItem) {
        if !hamshown{
          self.performSegue(withIdentifier: "shoeleft", sender: nil)
        }
    }
    
    
    @IBAction func tabbtn4(_ sender: UIButton) {
          alert(view: self, msg: "")
    }
    
    func UserLoadData(){
//        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        barbtn.tintColor = UIColor.white
//        let nav = self.navigationController?.navigationBar
//        nav?.tintColor = UIColor.white
//        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func startTimer(){
        end = arrNoti.count
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(ScrollTableView), userInfo: nil, repeats: true)
    }
    func EndTImer(){
        timer.invalidate()
    }
    
    @objc func ScrollTableView(){
        if arrNoti.count>0{
            if Position == end-1
            {
                Position = start
                let index = IndexPath(row: Position, section: 0)
                self.tbl.scrollToRow(at: index, at: .top, animated: true)
            }
            else
            {
                Position = Position+1
                let index = IndexPath(row: Position, section: 0)
                self.tbl.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }
}

extension HomeViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! HomeCollectionViewCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        cell.img.image = UIImage(named: arr2[indexPath.row].img)
        cell.lbltitle.text = arr2[indexPath.row].name
        cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width/2-20), height: (collectionView.bounds.height/2-10))
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! HomeCollectionViewCell
        
        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        cell.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            cell.transform = CGAffineTransform.identity
            cell.layoutIfNeeded()
        })
        { (true) in
            if indexPath.row == 0
            {
                self.performSegue(withIdentifier: "create", sender: nil)
            }
            else if indexPath.row == 2
            {
                self.performSegue(withIdentifier: "Lifestones", sender: nil)
            }
            else if indexPath.row == 3
            {
                alert3(view: self, msg: "This feature is coming soon")
//                self.performSegue(withIdentifier: "gotopond", sender: nil)
            }
            else{
               //ibm
                self.performSegue(withIdentifier: "ibm", sender: nil)
            }
        }
        
        
    }
    
    func gotoPond(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
             self.performSegue(withIdentifier: "gotopond", sender: nil)
        }
    }
}

extension HomeViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pagecontrol.numberOfPages = arrNoti.count
        pagecontrol.currentPage = 0
        return arrNoti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.rowHeight = 125
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! HomeTableViewCell
        
        cell.vw.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        cell.lblname.text = arrNoti[indexPath.row].first_name
        cell.lbldes.text = arrNoti[indexPath.row].content
        cell.img.sd_setImage(with: URL(string:  arrNoti[indexPath.row].image.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "user"))
        print(arrNoti[indexPath.row].created_at)
        let timeinterval = arrNoti[indexPath.row].created_at.timeIntervalSince(Date())
        let hours = floor(timeinterval / 60 / 60)
        
        if abs(hours) <= 12
        {
            cell.lblactive.text = "\(abs(Int(hours))) hours ago"
        }
        else
        {
            cell.lblactive.text = dateFormatterNew.string(from:arrNoti[indexPath.row].created_at)
        }
        
        
        cell.vw1.dropShadow2(color: .black, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        cell.alpha = 0
        
        UIView.animate(withDuration: 1, animations: { cell.alpha = 1 })
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        pagecontrol.currentPage = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        alert(view: self, msg: "")
    }
    
    
    //////////////////////// GetData Function ?????????/
    func GetData()
    {
        
//        SVProgressHUD.show(withStatus: "Loading")
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
                    if success {
                        SVProgressHUD.dismiss()
                        self.arrNoti.removeAll()
                        let data = dic["data"]?.array ?? []
                        for (i,item) in data.enumerated(){
                            if (i == data.count - 2) || (i == data.count - 1) || (i == data.count-3)
                            {
                                print(i)
                                let obj = UserNotifications()
                                obj.first_name = item["first_name"].string ?? ""
                                obj.last_name = item["last_name"].string ?? ""
                                obj.image = item["image"].string ?? ""
                                obj.content = item["content"].string ?? ""
                                
                                let datee = item["created_at"].string ?? ""
                                let splits = datee.split(separator: " ")
                                let date1 = String(splits[0])
                                let time = String(splits[1])
                                
                                let start_timee:Date = self.datetimeFormatter_UTC.date(from: "\(date1) \(time)") ?? Date()
                                print(start_timee)
                                
                                obj.created_at = start_timee
                                
                                self.arrNoti.append(obj)
                            }
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                       self.chkfornotification()
                        self.tbl.reloadData()
                        if self.arrNoti.count>0{
                           self.startTimer()
                        }
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
    }
    
  
    
    func chkfornotification(){
//        AppDelegate.NotificationCount = UserDefaults.standard.integer(forKey: "NotificationCount")
//        if AppDelegate.NotificationCount >= self.arrNoti.count{
//            self.barbtn.image = UIImage(named: "notify_ic_2")
//        }else{
//            self.barbtn.image = UIImage(named: "2_objectsx")
//        }
    }
    
}

//extension HomeViewController: UISideMenuNavigationControllerDelegate {
//
//    public func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appearing! (animated: \(animated))")
//        //        blurview.isHidden = false
//    }
//
//    public func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appeared! (animated: \(animated))")
//         hamshown = true
//    }
//
//    public func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappearing! (animated: \(animated))")
//    }
//
//    public func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappeared! (animated: \(animated))")
//         hamshown = false
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
////
//////        SideMenuManager.default.menuLeftNavigationController = nil
////        SideMenuManager.default.menuRightNavigationController = nil
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
////        print(SideMenuManager.default.menuPresentMode)
////        print(SideMenuManager.default.menuAnimationFadeStrength)
////        print(SideMenuManager.default.menuShadowOpacity)
////        print(SideMenuManager.default.menuAnimationTransformScaleFactor)
////        print(SideMenuManager.default.menuWidth)
////
//}
//
//}


extension HomeViewController: SideMenuNavigationControllerDelegate {
    
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
