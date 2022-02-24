//
//  PromotionsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 28/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class Promotion{
   var title: String
   var description: String
    init() {
         title = ""
         description = ""
    }
    init(title: String,description: String) {
        self.title = title
        self.description = description
    }
}
var objPromo = PromotionsViewController()
import UIKit
import SideMenu
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage
class PromotionsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var hamshown1 = false
    var arrpromo:[Promotion] = []
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetData()
        setupSideMenu()
        updateMenus()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tbl.addSubview(refreshControl)
        objPromo = self
    }
    
    func gotopond(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
             self.performSegue(withIdentifier: "xyz", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserLoadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserLoadData()
    }
    
    func UserLoadData(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        GetData()
    }
    
    @IBAction func btnMan(_ sender: UIButton) {
        alert(view: self, msg: "")
    }
    
    @IBAction func btnham(_ sender: UIBarButtonItem) {
        if !hamshown1
        {
            self.performSegue(withIdentifier: "shoeleft", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrpromo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 102
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! PromotionTableViewCell
        cell.lbltitle.text = arrpromo[indexPath.row].title
        cell.lbldes.text = arrpromo[indexPath.row].description
        return cell
    }

   
    //////////////////////// GetData Function ?????????/
    func GetData()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/promotions"
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
                        self.arrpromo.removeAll()
                        self.refreshControl.endRefreshing()
                       let data = dic["data"]?.array ?? []
                        for item in data{
                            let obj = Promotion()
                            obj.title = item["title"].string ?? ""
                            obj.description = item["description"].string ?? ""
                            self.arrpromo.append(obj)
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

extension PromotionsViewController: SideMenuNavigationControllerDelegate {
    
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


//extension PromotionsViewController: UISideMenuNavigationControllerDelegate {
//
//    public func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appearing! (animated: \(animated))")
//        //        blurview.isHidden = false
//    }
//
//    public func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appeared! (animated: \(animated))")
//        hamshown1 = true
//    }
//
//    public func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappearing! (animated: \(animated))")
//    }
//
//    public func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappeared! (animated: \(animated))")
//        hamshown1 = false
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
