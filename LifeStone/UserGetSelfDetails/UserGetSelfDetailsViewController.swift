//
//  UserGetSelfDetailsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 19/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var Stonecreated = false

class StoneDetails{
    var id: Int
    var type, fName, lName, gender: String
    var departureDate, dob, stoneDetailsDescription,created_by: String
    var displayImage, coverImage,created_at,updated_at: String?
    var isPrivate,charities_count,followers_count: Int
    
    init(){
        self.id = 0
        self.type = ""
        self.fName = ""
        self.lName = ""
        self.gender = ""
        self.departureDate = ""
        self.dob = ""
        self.stoneDetailsDescription = ""
        self.displayImage = ""
        self.coverImage = ""
        self.isPrivate = 0
        self.created_at = ""
        self.updated_at = ""
        self.created_by = ""
        self.charities_count = 0
        self.followers_count = 0
    }
    init(id: Int, type: String, fName: String, lName: String, gender: String, departureDate: String, dob: String, stoneDetailsDescription: String, displayImage: String?, coverImage: String?, isPrivate: Int,created_at:String,updated_at:String,charities_count:Int,followers_count:Int,created_by: String) {
        self.created_by = created_by
        self.id = id
        self.type = type
        self.fName = fName
        self.lName = lName
        self.gender = gender
        self.departureDate = departureDate
        self.dob = dob
        self.stoneDetailsDescription = stoneDetailsDescription
        self.displayImage = displayImage
        self.coverImage = coverImage
        self.isPrivate = isPrivate
        self.created_at = created_at
        self.updated_at = updated_at
        self.charities_count = charities_count
        self.followers_count = followers_count
    }
}

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD
import Vision
import MLKit

class UserGetSelfDetailsViewController: UIViewController,UITextViewDelegate
{
    
    //    lazy var vision = Vision.vision()
    //    var textRecognizer: VisionTextRecognizer?
    let textRecognizer = TextRecognizer.textRecognizer()
    
    var createPrivateUser = "1"
    var pickerController = UIImagePickerController()
    var dob = ""
    var depature = ""
    var flgd = false
    var Charity:[Charities] = []
    var selecCharity:[Charities] = []
    var arrGoals:[Charities] = []
    var base64str = ""
    var objStoneDetail = StoneDetails()
    var basestr = ""
    var dobs = Date()
    var dods = Date()
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet var popup: UIView!
    @IBOutlet weak var img: RoundUIImage!
    
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw5: UIView!
    
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtbirth: WajihTextField!
    @IBOutlet weak var txtgender: WajihTextField!
    
    @IBOutlet var popup1: UIView!
    @IBOutlet var popup2: UIView!
    @IBOutlet var popup3: UIView!
    
    @IBOutlet weak var txtLast: UITextView!
    
    @IBOutlet weak var colview: UICollectionView!
    @IBOutlet weak var colview2: UICollectionView!
    
    @IBOutlet weak var tblCharity: UITableView!
    @IBOutlet weak var tblLast: UITableView!
    @IBOutlet weak var tableview: UITableView!
    
    var displayArray = [TreeViewNode]()
    var arrLastw:[Charities] = []
    var nodes: [TreeViewNode] = []
    var data: [TreeViewData] = []
    var arrtobesnd: [TreeViewData] = []
    
    @IBOutlet weak var btncreatwill: UIButton!
    @IBOutlet weak var lblcretewill: UILabel!
    @IBOutlet weak var iconcreatewill: UIImageView!
    @IBOutlet weak var vwheight: NSLayoutConstraint!
    @IBOutlet weak var btOk: ButtonGradient!
    
    @IBOutlet weak var lbltapsup: UILabel!
    @IBOutlet weak var lbltapGoals: UILabel!
    @IBOutlet weak var lbltapLast: UILabel!
    
    @IBOutlet var descriptionPopUp: UIView!
    @IBOutlet weak var lbltapdesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        vw2.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 72, height: 72), cornerRadius: 32, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
        dtp.maximumDate = Date()
        GetCharities()
        GetGoals()
        hide()
        let notificationName = Notification.Name("TreeNodeButtonClicked")
        NotificationCenter.default.addObserver(self, selector: #selector(self.ExpandCollapseNode(_:)), name: notificationName, object: nil)
        
        if useratapeself{
            GetStoneDetails()
            btncreatwill.isHidden = false
            lblcretewill.isHidden = false
            iconcreatewill.isHidden = false
            vwheight.constant = 150
        }
        else{
            btncreatwill.isHidden = true
            lblcretewill.isHidden = true
            iconcreatewill.isHidden = true
            vwheight.constant = 100
            btOk.setTitle("OK", for: .normal)
            userGetStones()
        }
        
        
        
    }
    
    func HideShowLbl(){
        if self.selecCharity.count <= 0
        {
            self.lbltapsup.isHidden = false
        }else{
            self.lbltapsup.isHidden = true
        }
        if arrGoals.count != 0{
            lbltapGoals.isHidden = true
        }else{
            lbltapGoals.isHidden = false
        }
        if arrLastw.count != 0{
            lbltapLast.isHidden = true
        }else{
            lbltapLast.isHidden = false
        }
        
        
    }
    
    func Show(){
        blurView.isHidden = false
    }
    func hide(){
        blurView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetdisplay()
    }
    
    @IBAction func btnDescription(_ sender: UIButton) {
        self.view.endEditing(true)
        blurView.isHidden = false
        animatecenter(VC: self, Popview: descriptionPopUp)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        
        //        lbltapsup.text  = "Tap + to Add"
        //        lbltapLast.text  = "Tap + to Add"
        //        lbltapGoals.text  = "Tap + to Add"
        //        lblcretewill.text  = "Tap + to Add"
    }
    
    @IBAction func btnOkDescription(_ sender: UIButton)
    {
        if txtview.text == "Write something about this person"
        {
            return
        }
        lbltapdesc.text = txtview.text!
        descriptionPopUp.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func btnSuportedCharity(_ sender: UIButton) {
        self.MainView.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup1)
    }
    
    @IBAction func btnGoalsAndAchivements(_ sender: UIButton) {
        self.MainView.endEditing(true)
        Show()
        animate2(VC: self, Popview: popup2)
    }
    
    @IBAction func btnLastWish(_ sender: UIButton) {
        self.MainView.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup3)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        popup.isHidden = true
        popup1.isHidden = true
        popup2.isHidden = true
        popup3.isHidden = true
        descriptionPopUp.isHidden = true
        hide()
    }
    
    @IBAction func btnOkLastwish(_ sender: UIButton) {
        if txtLast.text! == "" {
            return
        }
        else if txtLast.text! == "Last wish"
        {
            return
        }
        if useratapeself
        {
            UserUpdateLastwish(mystr: txtLast.text!)
        }else{
            let obj = Charities()
            obj.title = txtLast.text
            arrLastw.append(obj)
        }
        popup3.isHidden = true
        self.tblLast.reloadData()
        txtLast.text = "Last wish"
        hide()
    }
    
    @IBAction func btnOk(_ sender: UIButton)
    {
        if flgd
        {
            self.dods = dtp.date
        }
        else
        {
            let format1 = DateFormatter()
            format1.dateFormat = "dd-MM-yyyy"
            format1.timeZone = TimeZone.current
            dob = format1.string(from: dtp.date)
            txtbirth.text = dob
            self.dobs = dtp.date
            
            
        }
        dtp.date = Date()
        popup.isHidden = true
        hide()
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
        self.MainView.endEditing(true)
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.MainView.endEditing(true)
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btndis(_ sender: UIButton) {
        animatecenter(VC: self, Popview: self.popup)
        Show()
        self.flgd = false
        self.MainView.endEditing(true)
    }
    
    @IBAction func btnGen(_ sender: Any) {
        self.MainView.endEditing(true)
        showAlert(sender: txtgender)
    }
    
    @IBAction func Userswitch(_ sender: UISwitch) {
        if createPrivateUser == "1"{
            createPrivateUser = "0"
        }else{
            createPrivateUser = "1"
        }
    }
    
    
    @IBAction func tapphoto(_ sender: UITapGestureRecognizer){
        tapUserPhoto()
    }
    
    @IBAction func txtdob(_ sender: WajihTextField) {
        Show()
        animatecenter(VC: self, Popview: self.popup)
        self.flgd = false
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            self.MainView.endEditing(true)
        })
    }
    
    @IBAction func txtGender(_ sender: WajihTextField) {
        self.MainView.endEditing(true)
        showAlert(sender: txtgender)
    }
    
    
    @IBAction func btnCreateUserOk(_ sender: UIButton) {
        if useratapeself{
            UpdateLifeStone()
        }else{
            CreateLifeStone()
        }
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
        } //Write something about yourself
        if textField == txtview {
            if textField.text != "Write something about yourself"{
                txtview.text = textField.text
            }
            else{
                txtview.text = ""
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
        if textView == txtview {
            if textView.text != ""{
                txtview.text = textView.text
            }
            else{
                txtview.text = "Write something about yourself"
            }
        }
    }
    
    
    func showAlert(sender: AnyObject) {
        let alert = UIAlertController(title: "Gender", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.txtgender.text = "male".uppercased()
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.txtgender.text = "female".uppercased()
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            self.txtgender.text = "other".uppercased()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    func resetdisplay(){
        
        vw1.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw3.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw4.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw5.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw1.setNeedsDisplay()
        vw2.setNeedsDisplay()
        vw3.setNeedsDisplay()
        vw4.setNeedsDisplay()
        vw5.setNeedsDisplay()
        
    }
    
    
    
}

extension UserGetSelfDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HideShowLbl()
        if collectionView == colview{
            return selecCharity.count
        }else{
            return arrGoals.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! UsergetdetailCollectionViewCell
            cell.lbltitle.text = selecCharity[indexPath.row].title
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(Userdelete(sender:)), for: .touchUpInside)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! UsergetdetailCollectionViewCell
            cell.lbltitle.text = arrGoals[indexPath.row].title
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteGoals(sender:)), for: .touchUpInside)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            return cell
        }
        
    }
    
    @objc func UserdeleteGoals(sender: UIButton){
        UserDeleteGoals(id: arrGoals[sender.tag].id, indx: sender.tag)
    }
    
    @objc func Userdelete(sender: UIButton){
        UserDeleteCharity(id: selecCharity[sender.tag].id, indx: sender.tag)
    }
    
    @objc func UserdeleteLast(sender: UIButton){
        UserDeleteLastwish(id: arrLastw[sender.tag].id, indx: sender.tag)
    }
    
    func getSize(arrsize:Int,height:Int) -> CGFloat {
        var num = arrsize / 2
        if arrsize % 2 == 1{
            num = num + 1
        }
        return CGFloat(num * height)
    }
}

extension UserGetSelfDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        HideShowLbl()
        if tableView == tblCharity
        {
            
            return Charity.count
        }
        else if tableView == tableview{
            return displayArray.count
        }
        else{
            return arrLastw.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCharity{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = Charity[indexPath.row].title
            return cell!
        }
        else if tableView == tableview{
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
        else{
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")  as! GetuserDetailsTableViewCell
            cell.lbltitle.text = arrLastw[indexPath.row].title
            cell.btn.tag = indexPath.row
            cell.btn.addTarget(self, action: #selector(UserdeleteLast(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCharity{
            if selecCharity.count == 0{
                selecCharity.append(Charity[indexPath.row])
                if useratapeself{
                    print(Charity[indexPath.row].id)
                    UserUpdateCharity(Obj: Charity[indexPath.row], indx: indexPath.row)
                }
            }else{
                var c = -1
                for item in selecCharity{
                    if item.title == Charity[indexPath.row].title{
                        c = 1
                    }
                }
                if c == -1{
                    selecCharity.append(Charity[indexPath.row])
                    if useratapeself{
                        print(Charity[indexPath.row].id)
                        UserUpdateCharity(Obj: Charity[indexPath.row], indx: indexPath.row)
                    }
                }
            }
            hide()
            popup1.isHidden = true
            self.colview.reloadData()
        }
        else {//if tableView == tableview
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
                            if useratapeself{
                                UserUpdateGoals(Obj: obj, indx: 0)
                            }
                        }else{
                            var c = -1
                            for (i,item) in arrGoals.enumerated(){
                                if item.title == obj.title{
                                    c = i
                                }
                            }
                            if c == -1{
                                arrGoals.append(obj)
                                if useratapeself{
                                    UserUpdateGoals(Obj: obj, indx: c)
                                }
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
            hide()
        }
        
    }
    
    func reloadData(){
        
        self.txtfname.text = self.objStoneDetail.fName
        self.txtlname.text =  self.objStoneDetail.lName
        
        let  arr = self.objStoneDetail.dob.split(separator: "-")
        let arr1 = arr.reversed()
        var finalstr = ""
        for (i,item)  in arr1.enumerated(){
            if i == arr1.count-1{
                finalstr = finalstr+"\(item)"
            }else{
                finalstr = finalstr+"\(item)-"
            }
        }
        dob = finalstr
        
        self.txtbirth.text = finalstr
        self.txtgender.text = self.objStoneDetail.gender.uppercased()
        self.txtview.text = self.objStoneDetail.stoneDetailsDescription
        self.img.sd_setImage(with: URL(string: "\(self.objStoneDetail.displayImage ?? "")".replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        self.colview.reloadData()//AppDelegate.baseurl+
        self.colview2.reloadData()
        self.tblLast.reloadData()
        self.base64str = ConvertImageToBase64String(img: self.img.image ?? #imageLiteral(resourceName: "Lifestone"))
        
    }
    
}


/////////////// APi callls ///////////////

extension UserGetSelfDetailsViewController{
    
    
    ///////////////////////// UserLogin Function ?????????/
    func userGetStones()  {
        
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
                        SVProgressHUD.dismiss()
                        let data = dic["lifestones"]?.dictionaryValue ?? [:]
                        let user = data["self_stone"]?.array ?? []
                        if user.count>0{
                            let message = "You have already created self stone"
                            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                print(message)
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
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
    
    
    func UserDeleteLastwish(id:Int,indx: Int)
    {
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/wish/delete"
        let parameters = [
            "wish_id": "\(id)"
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
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            self.arrLastw.remove(at: indx)
                            self.tblLast.reloadData()
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
    
    func UserDeleteGoals(id:Int,indx: Int){
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
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            self.arrGoals.remove(at: indx)
                            self.colview2.reloadData()
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
    
    func UserDeleteCharity(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/charity/delete"
        let parameters = [
            "charity_id": "\(id)"
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
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            self.selecCharity.remove(at: indx)
                            self.colview.reloadData()
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
    
    func UserUpdateLastwish(mystr:String){
        let ibj = Charities()
        ibj.title = mystr
        arrLastw.append(ibj)
        var UserarrLastw: [NSMutableDictionary] = []
        for item in arrLastw{
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["content" : "\(item.title)"])
            UserarrLastw.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/wishes/update"
        let parameters = [
            "ls_id": "\(objStoneDetail.id)",
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
                        self.arrLastw.removeAll()
                        SVProgressHUD.dismiss()
                        let arrwish = dic["data"]?.array ?? []
                        for item in arrwish{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.title = item["content"].string ?? ""
                            self.arrLastw.append(obj)
                        }
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async
                        {
                            self.tblLast.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    func UserUpdateGoals(Obj:Charities,indx: Int){
        
        var UserarrGoals: [NSMutableDictionary] = []
        for item in arrGoals{
            if item.title == Obj.title{
                let dic = NSMutableDictionary()
                dic.addEntries(from: ["id" : "\(item.id)"])
                UserarrGoals.append(dic)
            }
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/achievements/update"
        let parameters = [
            "ls_id": "\(objStoneDetail.id)",
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
                    if success == true {
                        self.arrGoals.removeAll()
                        SVProgressHUD.dismiss()
                        let arrach = dic["data"]?.array ?? []
                        for item in arrach{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["achievement_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            self.arrGoals.append(obj)
                        }
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
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
            "ls_id": "\(objStoneDetail.id)",
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
                        self.selecCharity.removeAll()
                        for item in data{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["charity_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            self.selecCharity.append(obj)
                        }
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.colview.reloadData()
                        self.popup1.isHidden = true
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    func UpdateLifeStone(){
        
        if txtfname.text! == ""{
            alert3(view: self, msg: "First name required!")
            return
        }
        if txtlname.text! == ""{
            alert3(view: self, msg: "Last name required!")
            return
        }
        if txtbirth.text! == ""{
            alert3(view: self, msg: "Date of birth required!")
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
        if dobs > dods
        {
            alert3(view: self, msg: "Date of Birth cannot be greater tha Date of Departure.")
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/update"
        if basestr == ""
        {
            self.basestr = ConvertImageToBase64String(img: self.img.image!)
        }
        let parameters = [
            "ls_id":"\(objStoneDetail.id)",
            "f_name":"\(txtfname.text!)",
            "l_name":"\(txtlname.text!)",
            "gender":"\(txtgender.text!.lowercased())",
            "dob":"\(txtbirth.text!)",
            "departure_date":"",
            "description":"\(txtview.text!)",
            "display_text ":"\(searchtxt)",
            "display_image":"data:image/png;base64,\(basestr)",
            "cover_image":"",
            "type":"self",
            "is_private":"\(createPrivateUser)",
            "lat":"",
            "long":"",
            "gps_address":""
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
                        searchtxt = ""
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
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
    
    
    
    
    ///////////////////////// GetCharities Function ?????????/
    func GetStoneDetails()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/detail"
        let parameter = ["ls_id":"\(objtofollow.id)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        
        Alamofire.request (urlstring ,method : .post, parameters: parameter, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        
                        SVProgressHUD.dismiss()
                        let lifeStone = dic["lifestone"]?.dictionary ?? [:]
                        self.objStoneDetail.id = lifeStone["id"]?.int ?? 0
                        self.objStoneDetail.coverImage = lifeStone["cover_image"]?.string ?? ""
                        self.objStoneDetail.departureDate = lifeStone["departure_date"]?.string ?? ""
                        self.objStoneDetail.displayImage = lifeStone["display_image"]?.string ?? ""
                        self.objStoneDetail.dob = lifeStone["dob"]?.string ?? ""
                        self.objStoneDetail.fName = lifeStone["f_name"]?.string ?? ""
                        self.objStoneDetail.gender = lifeStone["gender"]?.string ?? ""
                        self.objStoneDetail.lName = lifeStone["l_name"]?.string ?? ""
                        self.objStoneDetail.isPrivate = lifeStone["is_private"]?.int ?? 0
                        let will =  lifeStone["will"]?.int ?? 0
                        self.objStoneDetail.stoneDetailsDescription = lifeStone["description"]?.string ?? ""
                        
                        let arrchr = lifeStone["charities"]?.array ?? []
                        for item in arrchr{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["charity_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            self.selecCharity.append(obj)
                        }
                        let arrach = lifeStone["achievements"]?.array ?? []
                        for item in arrach{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.subid = item["achievement_id"].int ?? 0
                            obj.address = item["address"].string ?? ""
                            obj.title = item["title"].string ?? ""
                            obj.charitiesDescription = item["description"].string ?? ""
                            self.arrGoals.append(obj)
                            
                        }
                        let arrwish = lifeStone["wishes"]?.array ?? []
                        for item in arrwish{
                            let obj = Charities()
                            obj.id = item["id"].int ?? 0
                            obj.title = item["content"].string ?? ""
                            
                            self.arrLastw.append(obj)
                        }
                        DispatchQueue.main.async {
                            self.btOk.setTitle("UPDATE", for: .normal)
                            if will == 1{
                                self.lblcretewill.text = "UPDATE WILL"
                            }else{
                                self.lblcretewill.text = "CREATE A WILL"
                            }
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.reloadData()
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
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async
                        {
                            print(self.Charity.count)
                            
                            self.tblCharity.reloadData()
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
    
    
    func CreateLifeStone()
    {
        
        if txtfname.text! == ""{
            alert3(view: self, msg: "First name required!")
            return
        }
        if txtlname.text! == ""{
            alert3(view: self, msg: "Last name required!")
            return
        }
        if txtbirth.text! == ""{
            alert3(view: self, msg: "Date of birth required!")
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
        if selecCharity.count == 0{
            alert3(view: self, msg: "Charities required!")
            return
        }
        if arrGoals.count == 0{
            alert3(view: self, msg: "Goals and achiviements required!")
            return
        }
        if arrLastw.count == 0{
            alert3(view: self, msg: "Last wish required!")
            return
        }
        
        
        var UserCharity: [NSMutableDictionary] = []
        for item in selecCharity {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["charity_id" : "\(item.id)"])
            UserCharity.append(dic)
        }
        
        var UserGoals: [NSMutableDictionary] = []
        for item in arrGoals {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["achievement_id" : "\(item.id)"])
            UserGoals.append(dic)
        }
        
        var UserLastWishes: [NSMutableDictionary] = []
        for item in arrLastw {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["content" : "\(item)"])
            UserLastWishes.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/add"
        
        let parameters = [
            "f_name":"\(txtfname.text!)",
            "l_name":"\(txtlname.text!)",
            "gender":"\(txtgender.text!.lowercased())",
            "dob":"\(txtbirth.text!)",
            "departure_date":"",
            "description":"\(txtview.text!)",
            "display_text ":"\(searchtxt)",
            "display_image":"\(base64str)",
            "cover_image":"",
            "type":"self",
            "is_private":"1",
            "charities":UserCharity,
            "achievements":UserGoals,
            "wishes":UserLastWishes
            ] as [String : Any]
        
        print(parameters)
        
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        
        print(parameters)
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result
                {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        searchtxt = ""
                        SVProgressHUD.dismiss()
                        //                        let message = dic["message"]?.stringValue ?? ""
                        //                        alert3(view: self, msg: message)
                        DispatchQueue.main.async {
                            //                            self.navigationController?.popToRootViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                            
                            Stonecreated = true
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
}

/////////// Tree view ////
extension UserGetSelfDetailsViewController{
    
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


////// Image selection //////////
extension UserGetSelfDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerController.SourceType.camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else
        {
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
            let imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            imageView = self.resizeImage(image: imageView!, targetSize: CGSize(width: 500, height: 500))
            self.img.contentMode = .scaleAspectFill
            self.img.image = imageView!
            
            self.basestr = ConvertImageToBase64String(img: self.img.image!)
            self.uploadImageData(inputUrl: "\(AppDelegate.baseurl)api/lifestone/upload/file", imageName: "profile_image", imageFile: self.img.image!)
            //            self.detectText(image: self.img.image!)
            self.detectText(in: self.img.image!) { (res) in
                
                searchtxt = res
                
            }
            self.dismiss(animated:true, completion: nil)
        }
    }
    
    func detectText(in image: UIImage,
                    callback: @escaping (_ text: String) -> Void) {
        // 1
        //      guard let image = imageView.image else { return }
        // 2
        let visionImage = VisionImage(image: image)
        // 3
        textRecognizer.process(visionImage) { result, error in
            // 4
            guard
                error == nil,
                let result = result,
                !result.text.isEmpty
                else {
                    callback("")
                    return
            }
            // 5
            callback(result.text)
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







extension UserGetSelfDetailsViewController
{
    func uploadImageData(inputUrl:String,imageName: String,imageFile : UIImage)
    {
        SVProgressHUD.show(withStatus: "Loading")
        let imageData = imageFile.jpegData(compressionQuality: 0.5)
        Alamofire.upload(multipartFormData:
            { (multipartFormData) in
                multipartFormData.append(imageData!, withName: "image", fileName: "swift_file\(arc4random_uniform(100)).jpeg", mimeType: "image/jpeg")
        }, to:inputUrl,headers:["Authorization":"Bearer \(AppDelegate.personalInfo.token)","Accept":"application/json"])
        { (result) in
            switch result
            {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                upload.responseJSON { response in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success:
                        let json = (response.result.value as? NSDictionary ?? [:])
                        print(json)
                        
                        let Success =  json.value(forKey: "success") as? Bool ?? false
                        
                        let Image = json.value(forKey: "image") as? String ?? ""
                        
                        
                        if Success == true
                        {
                            self.base64str = Image
                            // alert3(view: self, msg: "Image Successfully uploaded..!")
                        }
                        else
                        {
                            alert3(view: self, msg: "Message")
                        }
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        alert3(view: self, msg: "\(error.localizedDescription)")
                    }
                    
                }
            case .failure:
                break
            }
        }
    }
}
