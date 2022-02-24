//
//  UserGetPetDetailsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD
import Vision
import MLKit

class UserGetPetDetailsViewController: UIViewController,UITextViewDelegate {
  
//    lazy var vision = Vision.vision()
//    var textRecognizer: VisionTextRecognizer?
    let textRecognizer = TextRecognizer.textRecognizer()
    
    var pickerController = UIImagePickerController()
    var base64str = ""
    var dob = ""
    var depature = ""
    var flgd = false
    var createPrivateUser = "0"
    var arrGoals:[Charities] = []
    var Goals:[String] = []
    var dobs = Date()
       var dods = Date()

    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var img: RoundUIImage!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtbirth: WajihTextField!
    @IBOutlet weak var txtdepart: WajihTextField!
    @IBOutlet weak var txtgender: WajihTextField!
    @IBOutlet weak var colview2: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var lbltap: UILabel!
    @IBOutlet var GoalsPopup: UIView!
    @IBOutlet weak var GoalsTxt: UITextView!
    
    @IBOutlet var popup2: UIView!
    @IBOutlet var descriptionPopUp: UIView!
    @IBOutlet weak var lbltapdesc: UILabel!
    
    var displayArray = [TreeViewNode]()
    var arrLastw:[String] = []
    //    var indentation: Int = 0
    var nodes: [TreeViewNode] = []
    var data: [TreeViewData] = []
    var arrtobesnd: [TreeViewData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     UserLoad()
    }
    
//    func detectText(in image: UIImage,
//      callback: @escaping (_ text: String) -> Void) {
//      // 1
////      guard let image = imageView.image else { return }
//      // 2
//      let visionImage = VisionImage(image: image)
//      // 3
//      textRecognizer?.process(visionImage) { result, error in
//        // 4
//        guard
//          error == nil,
//          let result = result,
//          !result.text.isEmpty
//          else {
//            callback("")
//            return
//        }
//        // 5
//        callback(result.text)
//      }
//    }
    
    func detectText(image:UIImage,
    callback: @escaping (_ text: String) -> Void){
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
          guard error == nil, let result = result else {
            // Error handling
            callback("")
            return
          }
          // Recognized text
            print(result.text)
            print(result.blocks)
            callback(result.text)
        }
    }

    
    func UserLoad()
    {
        blurView.isHidden = true
        vw2.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 72, height: 72), cornerRadius: 32, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
        //        img.sd_setImage(with: URL(string: AppDelegate.personalInfo.profileImage), placeholderImage: UIImage(named: "123"))
        dtp.maximumDate = Date()
        
        GetGoals()
        
        let notificationName = Notification.Name("TreeNodeButtonClicked")
        NotificationCenter.default.addObserver(self, selector: #selector(self.ExpandCollapseNode(_:)), name: notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        resetdisplay()
    }
    
    @IBAction func tapphoto(_ sender: UITapGestureRecognizer)
    {
        tapUserPhoto()
    }
    
    @IBAction func btnGoalsAndAchivements(_ sender: UIButton)
    {
        self.view.endEditing(true)
        blurView.isHidden = false
        animate2(VC: self, Popview: GoalsPopup)
    }
       
    @IBAction func btnDescription(_ sender: UIButton) {
        self.view.endEditing(true)
        blurView.isHidden = false
        animate2(VC: self, Popview: descriptionPopUp)
    }
    
    @IBAction func btndob(_ sender: UIButton)
    {
        self.view.endEditing(true)
        blurView.isHidden = false
        animatecenter(VC: self, Popview: popup)
        flgd = false
    }
    
    @IBAction func btnDeparture(_ sender: UIButton)
    {
        self.view.endEditing(true)
         blurView.isHidden = false
        animatecenter(VC: self, Popview: popup)
        flgd = true
    }
    @IBAction func btnGender(_ sender: UIButton) {
        self.view.endEditing(true)
        showAlert(sender: txtgender)
    }
    
    @IBAction func txtdob(_ sender: WajihTextField) {
        self.view.endEditing(true)
        blurView.isHidden = false
        animatecenter(VC: self, Popview: popup)
        flgd = false
    }
    
    @IBAction func txtdeparture(_ sender: WajihTextField) {
        self.view.endEditing(true)
        blurView.isHidden = false
        animatecenter(VC: self, Popview: popup)
        flgd = true
    }
    
    @IBAction func txtGender(_ sender: WajihTextField) {
        self.view.endEditing(true)
        showAlert(sender: txtgender)
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
        blurView.isHidden = true
        Goals.append(GoalsTxt!.text)
        GoalsPopup.isHidden = true
        self.colview2.reloadData()
        GoalsTxt.text = "Goals & Achievements"
    }
    
    @IBAction func CancelGoals(_ sender: UIButton)
    {
        blurView.isHidden = true
        popup.isHidden = true
        popup2.isHidden = true
        GoalsPopup.isHidden = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func btnOk(_ sender: UIButton)
    {
        if flgd{
            let format1 = DateFormatter()
            format1.dateFormat = "dd-MM-yyyy"
            format1.timeZone = TimeZone.current
            depature = format1.string(from: dtp.date)
            txtdepart.text = depature
            self.dods = dtp.date
        }else{
            let format1 = DateFormatter()
            format1.dateFormat = "dd-MM-yyyy"
            format1.timeZone = TimeZone.current
            dob = format1.string(from: dtp.date)
            txtbirth.text = dob
            self.dobs = dtp.date
        }
        if dobs > dods
        {
            alert3(view: self, msg: "Date of Birth should be less than Date of Departure.")
        }
        dtp.date = Date()
        popup.isHidden = true
         blurView.isHidden = true
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        popup.isHidden = true
        popup2.isHidden = true
        descriptionPopUp.isHidden = true
        blurView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        lbltapdesc.text = "Tap to Add"
    }
    
    @IBAction func btnOkDescription(_ sender: UIButton) {
        if txtview.text == "Write something about this person"{
           return
        }
         lbltapdesc.text = txtview.text!
         descriptionPopUp.isHidden = true
         blurView.isHidden = true
    }
    
    @IBAction func btnCreateUserOk(_ sender: UIButton) {
        CreateLifeStone()
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Userswitch(_ sender: UISwitch) {
        if createPrivateUser == "1"{
            createPrivateUser = "0"
        }else{
            createPrivateUser = "1"
        }
    }
    
    func showAlert(sender: AnyObject) {
        let alert = UIAlertController(title: "Gender", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.txtgender.text = "male"
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.txtgender.text = "female"
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            self.txtgender.text = "other"
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
       
        if textField == txtview {
                   if textField.text != "Write something about this pet"{
                       txtview.text = textField.text
                   }
                   else{
                       txtview.text = ""
                   }
               }
               
                   if GoalsTxt == textField
                   {
                              print(textField.text ?? "")
                              
                              if GoalsTxt.text != "Goals & Achievements"
                              {
                                  GoalsTxt.text = GoalsTxt.text
                              }
                              else
                              {
                                  GoalsTxt.text = ""
                              }
                          }
                           
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtview {
            if textView.text != ""{
                txtview.text = textView.text
            }
            else{
                txtview.text = "Write something about this pet"
            }
        }
        
        if textView == GoalsTxt{
                   if textView.text != ""{
                       GoalsTxt.text = textView.text
                   }
                   else{
                       GoalsTxt.text = "Goals & Achievements"
                   }
               }

    }
    
    func resetdisplay(){
        
        vw.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        
        vw4.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
    }
    
}


extension UserGetPetDetailsViewController{
    
    func CreateLifeStone(){
        if base64str == ""{
            alert3(view: self, msg: "Image required!")
            return
        }
        if txtfname.text! == ""{
            alert3(view: self, msg: "First name required!")
            return
        }
//        if txtlname.text! == ""{
//            alert3(view: self, msg: "Last name required!")
//            return
//        }
        if txtbirth.text! == ""{
            alert3(view: self, msg: "Date of birth required!")
            return
        }
        if txtdepart.text! == ""{
            alert3(view: self, msg: "Date of departure required!")
            return
        }
        if txtgender.text! == ""{
            alert3(view: self, msg: "Gender required!")
            return
        }
        if txtview.text! == ""{
            alert3(view: self, msg: "Description required!")
            return
        }
        
        if Goals.count == 0
        {
            alert3(view: self, msg: "Goals and achiviements required!")
            return
        }
        if dobs > dods
        {
            alert3(view: self, msg: "Date of Birth should be less than Date of Departure.")
        }
        
        var UserGoals: [String] = []
        for item in Goals
        {
            
            UserGoals.append("\(item)")
        }
        
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/add"
        
        let parameters = [
            "f_name":"\(txtfname.text!)",
            "l_name":"\(txtlname.text!)",
            "gender":"\(txtgender.text!)",
            "dob":"\(txtbirth.text!)",
            "departure_date":"\(txtdepart.text!)",
            "description":"\(txtview.text!)",
            "display_text ":"\(searchtxt)",
            "display_image":"\(base64str)",
            "cover_image":"",
            "type":"pet",
            "is_private":"\(createPrivateUser)",
            "charities":"",
            "achievements":UserGoals,
            "wishes":""
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
                        searchtxt = ""
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async {
                          self.dismiss(animated: true, completion: nil)
                          objpop2.userDismiss()
                        objpop1.userDismiss()
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    ///////////////////////// AddCard Function ?????????/
    func GetGoals()  {
        
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
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
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
    
}

extension UserGetPetDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func Showlbl(){
        if Goals.count != 0{
            lbltap.isHidden = true
        }else{
            lbltap.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            Showlbl()
            return Goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! UsergetdetailCollectionViewCell
            cell.lbltitle.text = Goals[indexPath.row]
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteGoals(sender:)), for: .touchUpInside)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            return cell
        
    }
    
    @objc func UserdeleteGoals(sender: UIButton){
        for (index,_) in Goals.enumerated()
        {
            if index == sender.tag
            {
                Goals.remove(at: index)
                break
            }
        }
        colview2.reloadData()
    }
   
    func getSize(arrsize:Int,height:Int) -> CGFloat {
        var num = arrsize / 2
        if arrsize % 2 == 1{
            num = num + 1
        }
        return CGFloat(num * height)
    }
}




////// Image selection //////////
extension UserGetPetDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        DispatchQueue.main.async {
            var imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imageView = self.resizeImage(image: imageView!, targetSize: CGSize(width: 500, height: 500))
            self.img.contentMode = .scaleAspectFill
            self.img.image = imageView!
//            self.base64str = imageView?.toBase64() ?? ""
            
          self.uploadImageData(inputUrl: "\(AppDelegate.baseurl)api/lifestone/upload/file", imageName: "image", imageFile: imageView!)
//           self.detectText(image: self.img.image!)
            self.detectText(image: self.img.image!) { (res) in
                searchtxt = res
            }

//            guard let imageData1: Data = imageView!.jpegData(compressionQuality: 0.4) else{return}
//            self.base64str = imageData1.base64EncodedString(options: .lineLength64Characters)
//            self.base64str  = imageView!.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
            //            print(self.base64str)
            self.dismiss(animated:true, completion: nil)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}



extension UserGetPetDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                    
                    if arrGoals.count == 0{
                        arrGoals.append(obj)
                    }else{
                        var c = -1
                        for item in arrGoals{
                            if item.id == obj.id{
                                c = 1
                            }
                        }
                        if c == -1{
                            arrGoals.append(obj)
                        }
                    }
                    colview2.reloadData()
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
        self.blurView.isHidden = true
    }
}


/////////// Tree view ////
extension UserGetPetDetailsViewController{
    
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






extension UserGetPetDetailsViewController
{
    func uploadImageData(inputUrl:String,imageName: String,imageFile : UIImage)
       {
           SVProgressHUD.show(withStatus: "Loading")
           let imageData = imageFile.jpegData(compressionQuality: 0.5)
           Alamofire.upload(multipartFormData:
               { (multipartFormData) in
                   multipartFormData.append(imageData!, withName: imageName, fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
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
                           
                            self.base64str = dic["image"]?.stringValue ?? ""
                            
                        }
                        else{
                            SVProgressHUD.dismiss()
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error.localizedDescription)
                    }
                    
                }
            case .failure:
                break
            }
        }
    }

}

