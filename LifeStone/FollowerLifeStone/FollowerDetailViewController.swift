//
//  FollowerDetailViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 22/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

var objdetailsFollow = FollowerDetailViewController()

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class FollowerDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate {
    @IBOutlet var updatepopup: UIView!
    @IBOutlet weak var updatetext: UITextView!
    var flgimage = false
    var pickerController = UIImagePickerController()
    var Charity:[Charities] = []
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var popup1: UIView!
    @IBOutlet var popup2: UIView!
    @IBOutlet var popup3: UIView!
    @IBOutlet weak var txtLast: UITextView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnChangeCover: UIButton!
    @IBOutlet var GoalsPopup: UIView!
    @IBOutlet weak var GoalsTxt: UITextView!
    
    
    var ind = 0
    var arr = [#imageLiteral(resourceName: "123"),#imageLiteral(resourceName: "fb"),#imageLiteral(resourceName: "123"),#imageLiteral(resourceName: "123"),#imageLiteral(resourceName: "123"),#imageLiteral(resourceName: "insta")]
    
    var displayArray = [TreeViewNode]()
    var nodes: [TreeViewNode] = []
    var data: [TreeViewData]  = []
    var arrtobesnd: [TreeViewData] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UserLoad()
        self.navigationItem.title = objtofollow.fName
    }
    
    @IBAction func btnChange(_ sender: UIButton)
    {
        tapUserPhoto()
    }
    
    
    @IBAction func OKUpdate(_ sender: UIButton)
    {
        if goalupdatename != "" && goalupdateid != ""
        {
            updatepopup.isHidden = true
            UserDeleteGoals1(id: Int(goalupdateid) ?? 0, indx: goalupdateindex)
            objLast.LastWisg_colvw.reloadData()
        }
    }
    
    
    
    
    @IBAction func tapimage(_ sender: UITapGestureRecognizer) {
        if flgimage{
            
        }else{
            DispatchQueue.main.async {
                 self.btnChangeCover.transform  = CGAffineTransform.init(scaleX: 1, y: 0)
                UIView.animate(withDuration: 0.5) {
                    self.btnChangeCover.transform = .identity
                    self.btnChangeCover.alpha = 1
                    self.flgimage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute:
                {
                    self.btnChangeCover.alpha = 0
                    self.flgimage = false
                })
            }
        }
        
    }
    
    func AddEvent()
    {
        self.performSegue(withIdentifier: "AddEvent", sender: nil)
    }
    func mov()
    {
        self.performSegue(withIdentifier: "mov", sender: nil)
    }
    
    @IBAction func btnOkLastwish(_ sender: UIButton) {
        if txtLast.text! == "" {
            return
        }
        else if txtLast.text! == "Last wish"{
            return
        }
        UserUpdateLastwish(mystr: txtLast.text!)
        popup3.isHidden = true
        objLast.LastWisg_colvw.reloadData()
        txtLast.text = "Last wish"
        
    }
    
    
    
      @IBAction func OkGoals(_ sender: UIButton)
         {
            if GoalsTxt.text! == ""
            {
                 return
             }
             else if GoalsTxt.text! == "Goals & Achievements"
             {
                 return
             }
            UserUpdateGoals(Obj:GoalsTxt.text! , indx: 0)
             GoalsPopup.isHidden = true
//             objLast.LastWisg_colvw.reloadData()
             GoalsTxt.text = "Goals & Achievements"
         }
      
      
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func cncelAllpopups()
    {
        popup1.isHidden = true
        popup2.isHidden = true
        popup3.isHidden = true
        updatepopup.isHidden = true
        GoalsPopup.isHidden = true
    }
    @IBAction func btnCancel(_ sender: UIButton) {
       cncelAllpopups()
    }
    
    func OpenPopup() {
        animatecenter(VC: self, Popview: popup1)
    }

    func btnGoalsAndAchivements() {
        animatecenter(VC: self, Popview: GoalsPopup)
    }
    
    
    func btnGoalsAndAchivements1() {
        animatecenter(VC: self, Popview: updatepopup)
    }
    
    func btnLastWish() {
        animatecenter(VC: self, Popview: popup3)
    }
    
    func OpenLastWish(){
        txtLast.text = arrdetwish[objLast.indx].title
        animatecenter(VC: self, Popview: popup3)
    }

    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField == txtLast{
            print(textField.text ?? "")
            
            if textField.text != "Last wish"{
                txtLast.text = textField.text
            }
            else{
                txtLast.text = ""
            }
        }
        if textField == GoalsTxt
        {
            print(textField.text ?? "")
            
            if textField.text != "Goals & Achievements"
            {
                GoalsTxt.text = textField.text
            }
            else
            {
                GoalsTxt.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtLast{
            if textView.text != ""{
                txtLast.text = textView.text
            }
            else{
                txtLast.text = "Last wish"
            }
        }
        if textView == GoalsTxt{
            if textView.text != ""
            {
                txtLast.text = textView.text
            }
            else{
                txtLast.text = "Goals & Achievements"
            }
        }
    }
    
    func UserLoad(){
        objdetailsFollow = self
        
        GetCharities()
        GetGoals()
        
        let notificationName = Notification.Name("TreeNodeButtonClicked")
        NotificationCenter.default.addObserver(self, selector: #selector(self.ExpandCollapseNode(_:)), name: notificationName, object: nil)
        
        self.img.sd_setImage(with: URL(string: AppDelegate.returnImg(imgString: objtofollow.coverImage!)), placeholderImage: UIImage(named: "123"))
        btnChangeCover.alpha = 0
    }
    
    func movtoImageCmnt()
    {
        self.performSegue(withIdentifier: "gotocmnt", sender: nil)
    }
    

}









//////////// Handle expandable table view ///////////
extension FollowerDetailViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbl{
            return Charity.count
        }else{
            return displayArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tbl{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = Charity[indexPath.row].title
            return cell!
        }
        else {//if tableView == tableview
            tableView.rowHeight = 62
            let node: TreeViewNode = self.displayArray[indexPath.row]
            let cell  = (self.tableview.dequeueReusableCell(withIdentifier: "cell") as! TreeViewCell)
            
            if node.nodeLevel == 0{
                cell.img.isHidden = false
                if node.isExpanded == "true"{
                    cell.img.image = UIImage(named: "dwn")
                }else{
                    cell.img.image = UIImage(named: "up")
                }
                cell.treeLabel.text = node.nodeObject as! String?
            }
            if node.nodeLevel == 1{
                cell.img.isHidden = false
                if node.isExpanded == "true"{
                    cell.img.image = UIImage(named: "up")
                }else{
                    cell.img.image = UIImage(named: "dwn")
                }
                cell.treeLabel.font = UIFont(name: "Roboto-Medium", size: 16)
                cell.treeLabel.text = "    \(node.nodeObject as! String? ?? "")"
            }
            if node.nodeLevel == 2{
                cell.img.isHidden = true
                cell.treeLabel.font = UIFont(name: "Roboto-Regular", size: 15)
                cell.treeLabel.text = "      \(node.nodeObject as! String? ?? "")"
            }
            
            cell.treeNode = node
            
            
            cell.setNeedsDisplay()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tbl{
            var c = -1
            for item in arrdetcharity{
                if item.title == Charity[indexPath.row].title{
                    c = 1
                }
            }
            if c == -1{
                arrdetcharity.append(Charity[indexPath.row])
                UserUpdateCharity(Obj: Charity[indexPath.row], indx: indexPath.row)
            }
        }
        else{
            let node: TreeViewNode = self.displayArray[indexPath.row]
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell") as! TreeViewCell
            cell.treeNode = node
            if (cell.treeNode != nil)
            {
                if cell.treeNode.nodeChildren != nil
                {
                    if cell.treeNode.isExpanded == GlobalVariables.TRUE
                    {
                        cell.treeNode.isExpanded = GlobalVariables.FALSE
                    }
                    else
                    {
                        cell.treeNode.isExpanded = GlobalVariables.TRUE
                    }
                }
                else
                {
                    
                    if node.nodeLevel == 2{
                        let node: TreeViewNode = self.displayArray[indexPath.row]
                        let obj = Charities()
                        print(node.nodegrandparentId ?? "")
                        print(node.nodeparentId ?? "")
                        obj.id = Int(node.nodeOwnId ?? "") ?? 0
                        obj.title = node.nodeOwnTitle ?? ""
                        
                        if arrDetGoals.count == 0{
                            arrDetGoals.append(obj)
                          //  UserUpdateGoals(Obj: obj, indx: 0)
                        }else{
                            var c = -1
                            for (i,item) in arrDetGoals.enumerated(){
                                if item.title == obj.title{
                                    c = i
                                }
                            }
                            if c == -1{
                                arrDetGoals.append(obj)
                               // UserUpdateGoals(Obj: obj, indx: c)
                            }
                        }
                        self.tbl.reloadData()
                        popup2.isHidden = true
                        
                    }
                    return
                }
                
                cell.isSelected = false
                NotificationCenter.default.post(name: Notification.Name(rawValue: "TreeNodeButtonClicked"), object: self)
            }
            else{
                return
            }
        }
        
    }
    
    //MARK:  Node/Data Functions
    
    @objc func ExpandCollapseNode(_ notification: Notification)
    {
        self.LoadDisplayArray()
        self.tableview.reloadData()
    }
    
    func LoadDisplayArray()
    {
        self.displayArray = [TreeViewNode]()
        for node: TreeViewNode in nodes
        {
            self.displayArray.append(node)
            if (node.isExpanded == GlobalVariables.FALSE)
            {
                self.AddChildrenArray(node.nodeChildren as! [TreeViewNode])
            }
            else{
            }
            
        }
    }
    
    func AddChildrenArray(_ childrenArray: [TreeViewNode])
    {
        for node: TreeViewNode in childrenArray
        {
            self.displayArray.append(node)
            if (node.isExpanded == GlobalVariables.TRUE )
            {
                if (node.nodeChildren != nil)
                {
                    self.AddChildrenArray(node.nodeChildren as! [TreeViewNode])
                }
            }
        }
    }
}











extension FollowerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //// user tapped to change photo//////
    func tapUserPhoto(){
        
        let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.openCamera()
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("user cancel")
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerController.SourceType.camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else {
            let message = "There is some thing wrong with camera"
            alert(view: self, msg: message)
            
        }
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView = cropImage(imageView!, toRect: CGRect(x: 0, y: 0, width: 300, height: 100), viewWidth: view.frame.width, viewHeight: view.frame.height)
        
        img.contentMode = .scaleAspectFill
        img.image = imageView!
        dismiss(animated:true, completion: nil)
//        let Userimage = imageView!
        let myurl = AppDelegate.baseurl+"api/lifestone/cover"
        let para = [
            "ls_id":"\(objtofollow.id)"
        ]
        self.uploadImageData(inputUrl: myurl, parameters: para, imageName: "image", imageFile: imageView!) { (sec) in
            print(sec)
        }
      
    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    /////////////// upload image /////////////////////////
    
    func uploadImageData(inputUrl:String,parameters:[String:Any],imageName: String,imageFile : UIImage,completion:@escaping(_:Any)->Void) {
        //        let imageData = UIImageJPEGRepresentation(imageFile , 0.5)
        let imageData = imageFile.jpegData(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: imageName, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        let dic = json.dictionaryValue
                        print(dic)
                        let success = dic["success"]?.int ?? 0
                        if success == 1 {
                            let user = dic["image"]?.string ?? ""
                            print(user)
                            objtofollow.coverImage = user
                            
//                            let message = dic["message"]?.stringValue ?? ""
//                            alert(view: self, msg: message)
                        }
                        else{
                            SVProgressHUD.dismiss()
//                            let message = dic["message"]?.stringValue ?? ""
//                            alert(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                            self.img.sd_setImage(with: URL(string: objtofollow.coverImage!), placeholderImage: UIImage(named: "123"))
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                    if let JSON = response.result.value {
                        completion(JSON)
                    }
                    else{
                        // completion(nilValue)
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    
}



////////// APi's ////////////////////
extension FollowerDetailViewController{
    
    func UserUpdateLastwish(mystr:String){
        if objLast.flgUpdate{
            arrdetwish[objLast.indx].title = mystr
        }else{
            let ibj = Charities()
            ibj.title = mystr
            arrdetwish.append(ibj)
        }
        var UserarrLastw: [NSMutableDictionary] = []
        for item in arrdetwish{
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["content" : "\(item.title)"])
            UserarrLastw.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/wishes/update"
        let parameters = [
            "ls_id": "\(objtofollow.id)",
            "wishes":UserarrLastw
            ] as [String : Any]
        print(parameters)
        
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
                        arrdetwish.removeAll()
                        SVProgressHUD.dismiss()
                        let arrwish = dic["data"]?.array ?? []
                        for item in arrwish{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.title = item["content"].string ?? ""
                            arrdetwish.append(obj)
                        }
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        objLast.LastWisg_colvw.reloadData()
                        objLast.HideShow()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    func UserUpdateGoals(Obj:String,indx: Int)
    {
        var UserarrGoals: [String] = []
         
        UserarrGoals.append(Obj)
            
        
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/achievements/update"
        let parameters = [
            "ls_id": "\(objtofollow.id)",
            "achievements":UserarrGoals
            
            ] as [String : Any]
        
        print(parameters)
        
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true
                    {
                        arrDetGoals.removeAll()
                        SVProgressHUD.dismiss()
                        let arrach = dic["data"]?.array ?? []
                        for item in arrach
                        {
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["achievement_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            arrDetGoals.append(obj)
                            
                        }
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            objGoals.colvw.reloadData()
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        objGoals.HideShow()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    ///////////////////////// AddCard Function ?????????/
    func GetGoals()
    {
        
        //        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/achievements"
        Alamofire.request (urlstring ,method : .get, parameters: nil, encoding
            : JSONEncoding.default,headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        SVProgressHUD.dismiss()
                        let arr = dic["parent_categories"]?.array ?? []
                        for (i,item) in arr.enumerated(){
                            self.data.append(TreeViewData.init(level: 0, title:  item["title"].string ?? "",id: "\(i)",ArrayID: "\(item["id"].int ?? 0)", parentId: "-1", isChecked: false, grandparentId: "\(i)", parentCategoriesDescription: item["description"].string ?? "" , ArrayparentID: item["parent_id"].int ?? 0)!)
                            let subcatarr = item["sub_categories"].array ?? []
                            for (_,itm) in subcatarr.enumerated(){
                                self.data.append(TreeViewData.init(level: 1, title:  itm["title"].string ?? "",id: "\(itm["id"].int ?? 0)",ArrayID: "\(itm["id"].int ?? 0)", parentId: "\(i)", isChecked: false, grandparentId: "\(i)", parentCategoriesDescription: itm["description"].string ?? "" , ArrayparentID: itm["parent_id"].int ?? 0)!)
                                let arrachiv = itm["achievements"].array ?? []
                                for (_,it) in arrachiv.enumerated(){
                                    self.data.append(TreeViewData.init(level: 2, title:  it["title"].string ?? "",id: "\(it["id"].int ?? 0)",ArrayID: "\(it["id"].int ?? 0)", parentId: "\(itm["id"].int ?? 0)", isChecked: false, grandparentId: "\(i)", parentCategoriesDescription: it["description"].string ?? "" , ArrayparentID: it["parent_id"].int ?? 0)!)
                                    
                                }
                            }
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.nodes = TreeViewLists.LoadInitialNodes(self.data)
                        self.LoadDisplayArray()
                        self.tableview.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    
    ///////////////////////// GetCharities Function ?????????/
    func GetCharities()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/charities"
        Alamofire.request (urlstring ,method : .get, parameters: nil, encoding
            : JSONEncoding.default,headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        SVProgressHUD.dismiss()
                        let arr = dic["charities"]?.array ?? []
                        for itm in arr{
                            let obj = Charities()
                            obj.id = itm["id"].int ?? 0
                            obj.address = itm["address"].string ?? ""
                            obj.charitiesDescription = itm["description"].string ?? ""
                            obj.image = itm["image"].string ?? ""
                            obj.title = itm["title"].string ?? ""
                            obj.status = itm["status"].string ?? ""
                            self.Charity.append(obj)
                        }
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
    //////////// Update cha
    func UserUpdateCharity(Obj:Charities,indx: Int){
        
        var UserChartiy: [NSMutableDictionary] = []
        for (i,item) in Charity.enumerated(){
            if i == indx{
                let dic = NSMutableDictionary()
                dic.addEntries(from: ["id" : "\(item.id)"])
                UserChartiy.append(dic)
            }
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/charities/update"
        let parameters = [
            "ls_id": "\(objtofollow.id)",
            "charities":UserChartiy
            ] as [String : Any]
        
        print(parameters)
        
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
                        let data = dic["data"]?.array ?? []
                        arrdetcharity.removeAll()
                        for item in data{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["charity_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            arrdetcharity.append(obj)
                        }
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        objsuport.tbl.reloadData()
                        objsuport.HideShow()
                        self.popup1.isHidden = true
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
}



extension FollowerDetailViewController
{
    func UserDeleteGoals1(id:Int,indx: Int)
         {
               SVProgressHUD.show(withStatus: "Loading")
               let urlstring = AppDelegate.baseurl+"api/achievement/delete"
               let parameters = [
                   "achievement_id": "\(id)"
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
                               
                               
                               DispatchQueue.main.async {
                                   arrDetGoals.remove(at: indx)
                                self.UserUpdateGoals(Obj: self.updatetext.text!, indx: indx)
                               }
                           }
                           else{
                               SVProgressHUD.dismiss()
//                               let message = dic["message"]?.stringValue ?? ""
//                               alert3(view: self, msg: message)
                           }
                           DispatchQueue.main.async {
                              SVProgressHUD.dismiss()
                           }
                       case .failure(let error):
                           SVProgressHUD.dismiss()
                           print(error.localizedDescription)
                       }
                       
               }
           }
       
       
           
}
