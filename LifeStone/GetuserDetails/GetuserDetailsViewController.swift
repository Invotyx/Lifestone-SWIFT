//
//  GetuserDetailsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 08/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

class Charities {
    
    var id,subid: Int
    var title, charitiesDescription, address: String
    var image: String
    var status: String
  
    init() {
        self.id = 0
        subid = 0
        self.title = ""
        self.charitiesDescription = ""
        self.address = ""
        self.image = ""
        self.status = ""
    }
    
    init(id: Int,subid:Int, title: String, charitiesDescription: String, address: String, image: String, status: String) {
        self.id = id
        self.title = title
        self.charitiesDescription = charitiesDescription
        self.address = address
        self.image = image
        self.status = status
        self.subid = subid
    }
}

var Picklat = ""
var Picklong = ""
var Pickgpsstr = ""

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD
import Vision
import MLKit

class GetuserDetailsViewController: UIViewController,UITextViewDelegate {
    
//    lazy var vision = Vision.vision()
//    var textRecognizer: VisionTextRecognizer?
    let textRecognizer = TextRecognizer.textRecognizer()
    
    @IBOutlet weak var departureWidth: NSLayoutConstraint!
    @IBOutlet weak var locategraveheight: NSLayoutConstraint!
    @IBOutlet weak var lblloategrave: UILabel!
    @IBOutlet weak var imglocategrave: UIImageView!
    @IBOutlet weak var lblprivate: UILabel!
    @IBOutlet weak var switchprivate: UISwitch!
    @IBOutlet var GoalsPopup: UIView!
    
    @IBOutlet weak var gpsbtn: UIButton!
    
   
    @IBOutlet weak var GoalsTxt: UITextView!
    var createPrivateUser = "0"
     var pickerController = UIImagePickerController()
    var dob = ""
    var depature = ""
    var flgd = false
    var Charity:[Charities] = []
    var selecCharity:[Charities] = []
    var arrGoals:[Charities] = []
    var Goals:[String] = []
    var base64str = ""
    @IBOutlet weak var goalvw: NSLayoutConstraint!
    var arryCarity:[String] = []
    @IBOutlet weak var colview: UICollectionView!
    @IBOutlet weak var colview2: UICollectionView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var vw6: UIView!
    @IBOutlet weak var vwtblHeight: NSLayoutConstraint!
    @IBOutlet weak var vwheight: NSLayoutConstraint!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var txtview: UITextView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var img: RoundUIImage!
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet var popup: UIView!
    
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    
    
    @IBOutlet weak var txtbirth: WajihTextField!
    @IBOutlet weak var txtdepart: WajihTextField!
    @IBOutlet weak var txtgender: WajihTextField!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
    @IBOutlet weak var tblCharity: UITableView!
    @IBOutlet var popup1: UIView!
    @IBOutlet var popup2: UIView!
    @IBOutlet var popup3: UIView!
    @IBOutlet weak var txtLast: UITextView!
    
    @IBOutlet weak var tblLast: UITableView!
    @IBOutlet weak var tableview: UITableView!
    
    var displayArray = [TreeViewNode]()
    var arrLastw:[String] = []
    var nodes: [TreeViewNode] = []
    var data: [TreeViewData] = []
    var arrtobesnd: [TreeViewData] = []
    
    @IBOutlet weak var lbltapsup: UILabel!
    @IBOutlet weak var lbltapGoals: UILabel!
    @IBOutlet weak var lbltapLast: UILabel!
    
    @IBOutlet weak var lbltapDesc: UILabel!
    @IBOutlet var descriptionPopUp: UIView!
    
    var dobs = Date()
    var dods = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       UserLoad()
        hide()
    }
    
    func Show(){
        blurView.isHidden = false
    }
    func hide(){
        blurView.isHidden = true
    }
    
    func UserLoad(){
        vw2.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 72, height: 72), cornerRadius: 32, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
        dtp.maximumDate = Date()
        
        GetCharities()
        GetGoals()
        
        let notificationName = Notification.Name("TreeNodeButtonClicked")
        NotificationCenter.default.addObserver(self, selector: #selector(self.ExpandCollapseNode(_:)), name: notificationName, object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        lbltapDesc.text = "Tap to Add"
    }
   
    override func viewDidAppear(_ animated: Bool) {
       resetdisplay()
    }
    
    @IBAction func btnDescription(_ sender: UIButton) {
        
        self.view.endEditing(true)
        blurView.isHidden = false
        animate2(VC: self, Popview: descriptionPopUp)
    }
    
    @IBAction func btnOkDescription(_ sender: UIButton) {
        if txtview.text == "Write something about this person"{
            return
        }
         lbltapDesc.text = txtview.text
         descriptionPopUp.isHidden = true
         blurView.isHidden = true
    }
    
    @IBAction func Userswitch(_ sender: UISwitch) {
        if createPrivateUser == "1"{
            createPrivateUser = "0"
        }else{
            createPrivateUser = "1"
        }
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
        Goals.append(GoalsTxt!.text)
        GoalsPopup.isHidden = true
        hide()
        self.colview2.reloadData()
        GoalsTxt.text = "Goals & Achievements"
    }
    
    @IBAction func CancelGoals(_ sender: UIButton)
    {
        popup.isHidden = true
        popup1.isHidden = true
        popup2.isHidden = true
        popup3.isHidden = true
        GoalsPopup.isHidden = true
        descriptionPopUp.isHidden = true
         hide()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func tapphoto(_ sender: UITapGestureRecognizer){
        tapUserPhoto()
    }
    
    @IBAction func btndob(_ sender: UIButton) {
        self.view.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup)
        flgd = false
    }
    @IBAction func btnDeparture(_ sender: UIButton) {
        self.view.endEditing(true)
        animatecenter(VC: self, Popview: popup)
        flgd = true
    }
    @IBAction func btnGender(_ sender: UIButton) {
        self.view.endEditing(true)
        showAlert(sender: txtgender)
    }
    
    @IBAction func txtdob(_ sender: WajihTextField) {
        self.txtbirth.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup)
        flgd = false
    }
    
    @IBAction func txtdeparture(_ sender: WajihTextField) {
        self.view.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup)
        flgd = true
    }
    
    
    @IBAction func txtGender(_ sender: WajihTextField) {
        self.view.endEditing(true)
        showAlert(sender: txtgender)
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
    
    @IBAction func btnSuportedCharity(_ sender: UIButton)
    {
        self.view.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup1)
    }
    
    
    
    
    
    
    @IBAction func btnGoalsAndAchivements(_ sender: UIButton) {
        self.view.endEditing(true)
        Show()
        animate2(VC: self, Popview: GoalsPopup)
    }
    
    @IBAction func btnLastWish(_ sender: UIButton)
    {
        self.view.endEditing(true)
        Show()
        animatecenter(VC: self, Popview: popup3)
    }
    
    
    
    
    
    
    
    
    @IBAction func btnOk(_ sender: UIButton) {
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
        hide()
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        popup.isHidden = true
        popup1.isHidden = true
        popup2.isHidden = true
        popup3.isHidden = true
         hide()
    }
    
    
    @IBAction func btnOkLastwish(_ sender: UIButton) {
        if txtLast.text! == "" {
            return
        }
        else if txtLast.text! == "Last wish"{
            return
        }
        arrLastw.append(txtLast.text)
        popup3.isHidden = true
        hide()
        self.tblLast.reloadData()
        txtLast.text = "Last wish"
    }
    
    @IBAction func btnLocateGrave(_ sender: UIButton) {
        self.performSegue(withIdentifier: "getloc", sender: nil)
//        getPlacePickerView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "getloc"
        {
            if let navVC = segue.destination as? UINavigationController
            {
                if let vc = navVC.viewControllers[0] as? GGetUserLocationViewController
                {
                    vc.showvc = false
                    
                }
            }
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
        if textField == txtview
        {
                if textField.text != "Write something about this person"{
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
        if textView == GoalsTxt{
                   if textView.text != ""{
                       GoalsTxt.text = textView.text
                   }
                   else{
                       GoalsTxt.text = "Goals & Achievements"
                   }
               }
        if textView == txtview {
                if textView.text != ""{
                    txtview.text = textView.text
                }
                else{
                    txtview.text = "Write something about this person"
                }
         }
        
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
    
}
/////////// Tree view ////
extension GetuserDetailsViewController{
 
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

    
    func resetdisplay(){
        
        vw.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        //        vw1.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw3.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw4.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw5.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw6.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
         vw.setNeedsDisplay()
         vw1.setNeedsDisplay()
         vw2.setNeedsDisplay()
         vw3.setNeedsDisplay()
         vw4.setNeedsDisplay()
         vw5.setNeedsDisplay()
         vw6.setNeedsDisplay()
       
    }
}


extension GetuserDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func HideShowLbl(){
        if Charity.count != 0{
           lbltapsup.isHidden = true
        }else{
            lbltapsup.isHidden = false
        }
        if arrGoals.count != 0
        {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HideShowLbl()
        if tableView == tblCharity{
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
            cell.treeNode = node
            
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
            
            cell.setNeedsDisplay()
            
            return cell
        }
            
            
        else{
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")  as! GetuserDetailsTableViewCell
            cell.lbltitle.text = arrLastw[indexPath.row]
//
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCharity{
            if selecCharity.count == 0{
                 selecCharity.append(Charity[indexPath.row])
            }else{
                var c = -1
                for item in selecCharity{
                    if item.id == Charity[indexPath.row].id{
                        c = 1
                    }
                }
                if c == -1{
                      selecCharity.append(Charity[indexPath.row])
                }
            }
            
        }
            else if tableView == tableview{
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
            }
            else{
                var i = -1
                for item in selecCharity{
                    if item.title == Charity[indexPath.row].title{
                        i = 0
                    }
                }
                if i != -1{
                    
                }
                else{
                    selecCharity.append(Charity[indexPath.row])
                }
            }
            colview.reloadData()
            popup1.isHidden = true
            hide()
    }
    
    
}

extension GetuserDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HideShowLbl()
        if collectionView == colview{
            return selecCharity.count
        }else{
            if Goals.count != 0
                   {
                       lbltapGoals.isHidden = true
                   }else{
                       lbltapGoals.isHidden = false
                   }
            return Goals.count
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
            cell.lbltitle.text = Goals[indexPath.row]
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteGoals(sender:)), for: .touchUpInside)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            return cell
        }
      
    }
    
    @objc func UserdeleteGoals(sender: UIButton)
    {
        print(sender.tag)
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
    
    @objc func Userdelete(sender: UIButton){
        selecCharity.remove(at: sender.tag)
        colview.reloadData()
    }
    
    func getSize(arrsize:Int,height:Int) -> CGFloat {
        var num = arrsize / 2
        if arrsize % 2 == 1{
            num = num + 1
        }
        return CGFloat(num * height)
    }
}

/////////////// APi callls ///////////////

extension GetuserDetailsViewController{
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
                    DispatchQueue.main.async {
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
    
    
    func CreateLifeStone(){
        
        if base64str == ""{
            alert3(view: self, msg: "Image required!")
            return
        }
        
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
        if txtdepart.text! == ""{
            alert3(view: self, msg: "Date of departure required!")
            return
        }
        if txtgender.text! == ""{
            alert3(view: self, msg: "Gender required!")
            return
        }
        if dobs > dods
        {
            alert3(view: self, msg: "Date of Birth should be less than Date of Departure.")
        }
        
        
        var UserCharity: [NSMutableDictionary] = []
        for item in selecCharity {
            let dic = NSMutableDictionary()
                dic.addEntries(from: ["charity_id" : "\(item.id)"])
                UserCharity.append(dic)
            }
        
        var UserGoals: [String] = []
        for item in Goals
        {
            
            UserGoals.append("\(item)")
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
            "gender":"\(txtgender.text!)",
            "dob":"\(txtbirth.text!)",
            "departure_date":"\(txtdepart.text!)",
            "description":"\(txtview.text!)",
            "display_text ":"\(searchtxt)",
            "display_image":"\(base64str)",
            "cover_image":"",
            "type":"person",
            "lat":"\(Picklat)",
            "long":"\(Picklong)",
            "gps_address":"\(Pickgpsstr)",
            "is_private":"\(createPrivateUser)",
            "charities":UserCharity,
            "achievements":UserGoals,
            "wishes":UserLastWishes
            ] as [String : Any]
        
       // print(parameters)
        
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        
        print(parameters)
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
    
}

 ////// Image selection //////////
extension GetuserDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            let imageView  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            imageView = self.resizeImage(image: imageView!, targetSize: CGSize(width: 500, height: 500))
            self.img.contentMode = .scaleAspectFill
            self.img.image = imageView!
//            self.detectText(image: self.img.image!)
            self.detectText(image: self.img.image!) { (res) in

                searchtxt = res
                
            }
            self.uploadImageData(inputUrl: "\(AppDelegate.baseurl)api/lifestone/upload/file", imageName: "image", imageFile: imageView!)
            self.dismiss(animated:true, completion: nil)
            
           
        }
    }
    
//    func detectText(in image: UIImage,
//      callback: @escaping (_ text: String) -> Void) {
//      // 1
////      guard let image = imageView.image else { return }
//      // 2
//      let visionImage = VisionImage(image: image)
//      // 3
//        textRecognizer.process(visionImage) { result, error in
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




extension GetuserDetailsViewController
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

