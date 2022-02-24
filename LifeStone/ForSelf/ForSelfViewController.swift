//
//  ForSelfViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 20/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SideMenu

var objself = ForSelfViewController()
class ForSelfViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  var hamshown1 = false
     @IBOutlet weak var colview: UICollectionView!
     var arrLoved:[LovedStone] = []
    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSideMenu()
        updateMenus()
        objself = self
        userGetStones()
    }
    
    @IBAction func btnham(_ sender: UIBarButtonItem)
    {
        if !hamshown1
        {
            self.performSegue(withIdentifier: "shoeleft", sender: nil)
        }
    }
    
}






extension ForSelfViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrLoved.count > 0
        {
            lbl.isHidden = true
        }
        else
        {
            lbl.isHidden = false
        }
        return arrLoved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ForLovedOnesCollectionViewCell
        cell.img.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))// #imageLiteral(resourceName: "123")//arrLoved[indexPath.row].displayImage
        cell.title.text = "\(arrLoved[indexPath.row].fName) \(arrLoved[indexPath.row].lName)"
        let sec = stringtoString_with_Format(userdate: arrLoved[indexPath.row].createdAt, input: "yyyy-MM-dd HH:mm:ss", Output: "yyyy-MM-dd")
        cell.date.text = sec
        //        cell.clipsToBounds = true
        //        cell.layer.cornerRadius = 20
        //        cell.img.layer.cornerRadius = 20
        cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width-20), height: (collectionView.bounds.height-50))
        //         - (3 * 10))/2
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        useratapeself = true
        print(arrLoved[indexPath.row].id)
        objtofollow = arrLoved[indexPath.row]
        UserTapped = UserRoleKey.User.rawValue
        //        alert(view: self, msg: "")
        self.performSegue(withIdentifier: "gotoself", sender: nil)
    }
    func gotoPond(){
        
           DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.performSegue(withIdentifier: "gotopond", sender: nil)
           }
       }

}


extension ForSelfViewController{
    
    ///////////////////////// UserLogin Function ?????????/
    func userGetStones()  {
        arrLoved.removeAll()
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestones"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .get, parameters: nil, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        let data = dic["lifestones"]?.dictionaryValue ?? [:]
                        //                        loved_ones  self_stone
                        let user = data["self_stone"]?.array ?? []
                        
                        for item in user{
                            let obj = LovedStone()
                            obj.id = item["id"].int ?? 0
                            obj.type = item["type"].string ?? ""
                            obj.createdBy = item["created_by"].int ?? 0
                            obj.managedBy = item["managed_by"].int ?? 0
                            obj.fName = item["f_name"].string ?? ""
                            obj.lName = item["l_name"].string ?? ""
                            obj.gender = item["gender"].string ?? ""
                            obj.departureDate = item["departure_date"].string ?? ""
                            obj.stoneDescription = item["description"].string ?? ""
                            obj.displayImage = item["display_image"].string ?? ""
                            obj.coverImage = item["cover_image"].string ?? ""
                            obj.createdAt = item["created_at"].string ?? ""
                            obj.isPrivate = item["is_private"].int ?? 0
                            self.arrLoved.append(obj)
                        }
                        SVProgressHUD.dismiss()
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.colview.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
        
    }
}





//extension ForSelfViewController: UISideMenuNavigationControllerDelegate {
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


extension ForSelfViewController: SideMenuNavigationControllerDelegate {
    
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
