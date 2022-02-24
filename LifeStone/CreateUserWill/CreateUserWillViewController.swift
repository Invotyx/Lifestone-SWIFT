//
//  CreateUserWillViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 02/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var willId = -1
var arrAttactment:[Attachment] = []
import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class CreateUserWillViewController: UIViewController
{
    
    let objUserWillDetail = UserWillDetails()
    var willflg = false
    var arrAddBox:[Confession] = []
    var arrLaywer:[Lawyer] = []
    var arrBenifi:[Beneficiary] = []
    var arrNominee:[Nominy] = []
    var arrLastWish:[Confession] = []
    var arrConfession:[Confession] = []
    var dob = ""
    var edi = -1
    var base64str = ""
    var pickerController = UIImagePickerController()
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var vw6: UIView!
    @IBOutlet weak var vw7: UIView!
    @IBOutlet weak var vw8: UIView!
    
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet weak var img: RoundUIImage!
    
    @IBOutlet weak var txtfname: UITextField!
    @IBOutlet weak var txtlname: UITextField!
    @IBOutlet weak var txtbirth: WajihTextField!
    @IBOutlet weak var txtgender: WajihTextField!
    
    @IBOutlet var popup: UIView!
    @IBOutlet var popup1: UIView!
    @IBOutlet var popup2: UIView!
    @IBOutlet var popup3: UIView!
    @IBOutlet var popup4: UIView!
    @IBOutlet var popup5: UIView!
    
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var txttitle: UITextField!
    @IBOutlet weak var vwtitle: UIView!
    
    @IBOutlet weak var txtdes: UITextView!
    @IBOutlet weak var lbldes: UILabel!
    @IBOutlet weak var vwdes: UIView!
    
    
    @IBOutlet weak var Lfname: UITextField!
    @IBOutlet weak var LLname: UITextField!
    @IBOutlet weak var LLEmail: UITextField!
    
    @IBOutlet weak var BFname: UITextField!
    @IBOutlet weak var BLname: UITextField!
    
    @IBOutlet weak var Nfname: UITextField!
    @IBOutlet weak var NLname: UITextField!
    @IBOutlet weak var NEmail: UITextField!
    
    @IBOutlet weak var lfnvw: UIView!
    @IBOutlet weak var llnvw: UIView!
    @IBOutlet weak var llevw: UIView!
    
    @IBOutlet weak var bfnvw: UIView!
    @IBOutlet weak var blnvw: UIView!
    
    @IBOutlet weak var Nfnvw: UIView!
    @IBOutlet weak var Nlnvw: UIView!
    @IBOutlet weak var Nevw: UIView!
    
    @IBOutlet weak var lblLffn: UILabel!
    @IBOutlet weak var lbllln: UILabel!
    @IBOutlet weak var lblLe: UILabel!
    
    @IBOutlet weak var lblBfn: UILabel!
    @IBOutlet weak var lblBln: UILabel!
    
    @IBOutlet weak var lblNfn: UILabel!
    @IBOutlet weak var lblNln: UILabel!
    @IBOutlet weak var lblNe: UILabel!
    
    @IBOutlet weak var LayTbl: UITableView!
    @IBOutlet weak var BenTbl: UITableView!
    @IBOutlet weak var NomTbl: UITableView!
    @IBOutlet weak var LastTbl: UITableView!
    @IBOutlet weak var BoxTbl: UITableView!
    
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var txtLast: UITextView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var Myview: UIView!
    
    @IBOutlet weak var btnUploadMedia: UIButton!
    @IBOutlet weak var lblcretewill: UILabel!
    @IBOutlet weak var iconcreatewill: UIImageView!
    @IBOutlet weak var vwheight: NSLayoutConstraint!
    
    @IBOutlet weak var lbltaplaywer: UILabel!
    @IBOutlet weak var lbltapben: UILabel!
    @IBOutlet weak var lbltanom: UILabel!
    @IBOutlet weak var lbltalast: UILabel!
    @IBOutlet weak var lbltapother: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         GetUserWillDetails()
        hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setBorderAndSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func Show(){
        blurView.isHidden = false
    }
    func hide(){
        blurView.isHidden = true
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
       
        let format1 = DateFormatter()
        format1.dateFormat = "dd-MM-yyyy"
        format1.timeZone = TimeZone.current
        dob = format1.string(from: dtp.date)
        txtbirth.text = dob
        dtp.date = Date()
        popup.isHidden = true
        HidePopups()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        hide()
       HidePopups()
    }
    
    @IBAction func btnback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         self.view.endEditing(true)
    }
   
    @IBAction func txtdob(_ sender: UIButton) {
        animatecenter(VC: self, Popview: self.popup)
        Show()
            self.view.endEditing(true)
    }
    
    @IBAction func btnLaywer(_ sender: UIButton) {
        if willflg{
            Lfname.text = arrLaywer[0].fName
            LLname.text = arrLaywer[0].lName
            LLEmail.text = arrLaywer[0].email
        }else{
            
        }
        animate2(VC: self, Popview: self.popup1)
        Show()
        self.view.endEditing(true)
    }
    
    @IBAction func btnBenif(_ sender: UIButton)
    {
        BFname.text = ""
        BLname.text = ""
        
        animate2(VC: self, Popview: self.popup2)
        Show()
        self.view.endEditing(true)
    }
    
    @IBAction func btnNominee(_ sender: UIButton)
    {
        animate2(VC: self, Popview: self.popup3)
        Show()
        self.view.endEditing(true)
    }
    
    @IBAction func btnLastwish(_ sender: UIButton) {
        animatecenter(VC: self, Popview: self.popup4)
        Show()
        self.view.endEditing(true)
    }
    @IBAction func btnOthers(_ sender: UIButton) {
        animate2(VC: self, Popview: self.popup5)
        Show()
        self.view.endEditing(true)
    }
    
    
    @IBAction func btnGen(_ sender: Any) {
        showAlert(sender: txtgender)
    }
    
    @IBAction func btnOkLastWish(_ sender: UIButton) {
        if txtLast.text == ""{
            return
        }
        if txtLast.text == "Last wish"{
            return
        }
        let obj = Confession()
        obj.content = txtLast.text!
        if edi == -1{
            if willflg{
            arrLastWish.append(obj)
            HidePopups()
            self.LastTbl.reloadData()
              self.UserUpdateWishes()
                
            }else{
                arrLastWish.append(obj)
                HidePopups()
                self.LastTbl.reloadData()
            }
            txtLast.text = "Last wish"
            edi = -1
        }else{
            obj.id = arrLastWish[edi].id
            if willflg{
                arrLastWish.remove(at: edi)
                arrLastWish.insert(obj, at: edi)
                HidePopups()
                self.LastTbl.reloadData()
                self.UserUpdateWishes()
            }else{
                arrLastWish.remove(at: edi)
                arrLastWish.insert(obj, at: edi)
                HidePopups()
                self.LastTbl.reloadData()
                txtLast.text = "Last wish"
            }
        }
        hide()
    }
    @IBAction func tapphoto(_ sender: UITapGestureRecognizer){
        tapUserPhoto()
    }
    
    @IBAction func btnSaveBox(_ sender: UIButton) {
        if txttitle.text == ""{
            return
        }
        if txtdes.text == ""{
            return
        }
        if txtdes.text == "Description"{
            return
        }
        let obj = Confession()
        obj.title = txttitle.text!
        obj.content  = txtdes.text!
        if edi == -1{
                if willflg{
                    arrAddBox.append(obj)
                    self.HidePopups()
                    self.BoxTbl.reloadData()
                    self.txttitle.text = ""
                    self.UserUpdatecustom()
                }else{
                    arrAddBox.append(obj)
                    self.HidePopups()
                    self.BoxTbl.reloadData()
                    self.txttitle.text = ""
                    self.txtdes.text = "Description"
                }
                edi = -1
        }else{
             obj.id = arrAddBox[edi].id
            if willflg{
                arrAddBox.remove(at: edi)
                arrAddBox.insert(obj, at: edi)
                self.HidePopups()
                self.BoxTbl.reloadData()
                self.UserUpdatecustom()
            }else{
                arrAddBox.remove(at: edi)
                arrAddBox.insert(obj, at: edi)
                self.HidePopups()
                self.BoxTbl.reloadData()
                self.txttitle.text = ""
                self.txtdes.text = "Description"
            }
            
        }
        hide()
    }
    
    @IBAction func btnSaveLaywer(_ sender: UIButton) {
        
        if Lfname.text == ""{
             alert3(view: self, msg: "First Name Cannot be empty")
            return
        }
        if LLname.text == ""
        {
            alert3(view: self, msg: "Last Name Cannot be empty")
            return
        }
        if LLEmail.text == ""{
            alert3(view: self, msg: "Email Cannot be empty")
            return
        }
        if !(LLEmail.text?.isValidEmail())!
        {
            alert3(view: self, msg: "Invalid email address")
            return
        }
        let obj = Lawyer()
        obj.fName = Lfname.text!
        obj.lName  = LLname.text!
        obj.email = LLEmail.text!
        if arrLaywer.count>0{
            obj.id = arrLaywer[0].id
        }
        
        if willflg {
            arrLaywer.removeAll()
            arrLaywer.append(obj)
            self.HidePopups()
            self.LayTbl.reloadData()
            self.UserUpdateLawyer()
        }else{
            arrLaywer.removeAll()
            arrLaywer.append(obj)
            self.HidePopups()
            self.LayTbl.reloadData()
        }
        hide()
    }
    
    @IBAction func btnSaveBenifc(_ sender: UIButton)
    {
        
        if BFname.text == ""{
            alert3(view: self, msg: "First Name Cannot be empty")
            return
        }
        if BLname.text == ""{
            alert3(view: self, msg: "Last Name Cannot be empty")
            return
        }
        let obj = Beneficiary()
        
        obj.fName = BFname.text?.capitalizingFirstLetter() ?? ""
        obj.lName  = BLname.text?.capitalizingFirstLetter() ?? ""
        var exst = -1
        for item in arrBenifi
        {
            if item.fName == obj.fName
            {
                exst = 1
                obj.id = item.id
                obj.fName = BFname.text!
                obj.lName  = BLname.text!
                obj.dob = item.dob
                obj.gender = item.gender
            }
        }
        if exst == -1{
            if willflg{
                arrBenifi.append(obj)
                self.BenTbl.reloadData()
                self.HidePopups()
                self.UserUpdateBenificiaries()
            }else{
                arrBenifi.append(obj)
                self.BenTbl.reloadData()
                self.BFname.text = ""
                    
                self.BLname.text = ""
                 
                self.HidePopups()
            }
        }
        
        hide()
    }
    
    @IBAction func btnSaveNominee(_ sender: UIButton)
    {
        
        if Nfname.text == ""{
            alert3(view: self, msg: "First Name Cannot be empty")
            return
        }
        if NLname.text == ""{
            alert3(view: self, msg: "Last Name Cannot be empty")
            return
        }
        if NEmail.text == ""{
            alert3(view: self, msg: "Email Name Cannot be empty")
            return
        }
        if !(NEmail.text?.isValidEmail())!{
            alert3(view: self, msg: "Invalid email address")
            return
        }
        let obj = Nominy()
        obj.fName = Nfname.text!
        obj.lName  = NLname.text!
        obj.email = NEmail.text!
        var exst = -1
        for item in arrNominee{
            if item.fName == obj.fName{
                exst = 1
            }
        }
        if exst == -1{
            if willflg{
                arrNominee.append(obj)
                self.NomTbl.reloadData()
                self.HidePopups()
                self.UserUpdateNominee()
            }else{
                arrNominee.append(obj)
                self.NomTbl.reloadData()
                self.HidePopups()
            }
        }
        hide()
    }
    
    @IBAction func btnOKCreateWill(_ sender: UIButton) {
        if willflg{
            UserUpdateWill()
        }else{
            CreateWill()
        }
    }
    
}



extension CreateUserWillViewController: UITableViewDataSource,UITableViewDelegate,UITextViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == LayTbl{
            return arrLaywer.count
        }
        if tableView == BenTbl{
            return arrBenifi.count
        }
        if tableView == LastTbl{
            return arrLastWish.count
        }
        if tableView == BoxTbl{
            return arrAddBox.count
        }
        else{
            return arrNominee.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == LayTbl{
             tableView.rowHeight = 35
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CreateWillLawyerTableViewCell
            cell.lbltitle.text = arrLaywer[indexPath.row].fName
            cell.lbldes.text = arrLaywer[indexPath.row].email
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteLaywer(sender:)), for: .touchUpInside)
            return cell
        }
        if tableView == BenTbl{
             tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CreateWillBenficTableViewCell
            cell.lbltitle.text = arrBenifi[indexPath.row].fName
            cell.lblindx.text = "\(indexPath.row+1)"
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteBeni(sender:)), for: .touchUpInside)
            return cell
        }
        if tableView == LastTbl{
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CreateWillLastwishTableViewCell
            cell.lbltitle.text = arrLastWish[indexPath.row].content
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(Userdelete(sender:)), for: .touchUpInside)
            return cell
        }
        if tableView == BoxTbl{
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CreateWillLastwishTableViewCell
            cell.lbltitle.text = arrAddBox[indexPath.row].title
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteBox(sender:)), for: .touchUpInside)
            return cell
        }
        else{
             tableView.rowHeight = 35
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! CreateWillLawyerTableViewCell
            cell.lbltitle.text = arrNominee[indexPath.row].fName
            cell.lbldes.text = arrNominee[indexPath.row].email
            cell.btndel.tag = indexPath.row
            cell.btndel.addTarget(self, action: #selector(UserdeleteNominee(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == BoxTbl{
        edi = indexPath.row
        self.txttitle.text = arrAddBox[indexPath.row].title
        self.txtdes.text = arrAddBox[indexPath.row].content
        animatecenter(VC: self, Popview: self.popup5)
        self.view.endEditing(true)
        }
        if tableView == LastTbl{
             edi = indexPath.row
            txtLast.text = arrLastWish[indexPath.row].content
            animatecenter(VC: self, Popview: self.popup4)
            self.view.endEditing(true)
        }
    }
    
    @objc func UserdeleteNominee(sender: UIButton){
        self.UserDeleteNominee(id: arrNominee[sender.tag].id, indx: sender.tag)
//        arrNominee.remove(at: sender.tag)
//        self.NomTbl.reloadData()
    }
    
    @objc func UserdeleteLaywer(sender: UIButton){
        arrLaywer.remove(at: sender.tag)
        self.LayTbl.reloadData()
    }
    
    @objc func UserdeleteBeni(sender: UIButton){
        if arrBenifi[sender.tag].id != 0
        {
            self.UserDeleteBenificiaries(id: arrBenifi[sender.tag].id, indx: sender.tag)
        }
        else
        {
            arrBenifi.remove(at: sender.tag)
            self.BenTbl.reloadData()
        }
//        arrBenifi.remove(at: sender.tag)
//        self.BenTbl.reloadData()
    }
    
    @objc func UserdeleteBox(sender: UIButton){
       self.UserDeleteOthers(id: arrAddBox[sender.tag].id, indx: sender.tag)
//        arrAddBox.remove(at: sender.tag)
//        self.BoxTbl.reloadData()
    }
    
    @objc func Userdelete(sender: UIButton){
        self.UserDeleteLastWish(id: arrLastWish[sender.tag].id, indx: sender.tag)
//        arrLastWish.remove(at: sender.tag)
//        self.LastTbl.reloadData()
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField == txtdes{
            if textField.text != "Description"{
                txtdes.text = textField.text
            }
            else{
                txtdes.text = ""
                lbldes.alpha = 0
                self.lbldes.transform = CGAffineTransform(translationX: 0, y: 30)
                UIView.animate(withDuration: 0.5, animations: {
                    self.vwdes.alpha = 1
                    self.lbldes.alpha = 0.6
                    self.lbldes.transform = .identity
                }) { (true) in
                }
            }
        }
        
        if textField == txtLast{
            print(textField.text ?? "")
            
            if textField.text != "Last wish"{
                txtLast.text = textField.text
            }
            else{
                txtLast.text = ""
            }
        }
        if textField == textview {
            
            if textField.text != "This is the sample description of the profile"{
                textview.text = textField.text
            }
            else{
                textview.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtdes{
            if textView.text != "Description"{
                txtdes.text = textView.text
            }
            else{
                txtdes.text = "Description"
            }
            resertBorder()
        }
        if textView == txtLast{
            if textView.text != ""{
                txtLast.text = textView.text
            }
            else{
                txtLast.text = "Last wish"
            }
        }
        if textView == textview {
            if textView.text != ""{
                textview.text = textView.text
            }
            else{
                textview.text = "This is the sample description of the profile"
            }
        }
    }
    
    
    
}


extension CreateUserWillViewController:UITextFieldDelegate{
    
    func HidePopups(){
        if arrLaywer.count != 0{
            lbltaplaywer.isHidden = true
        }
        else{
            lbltaplaywer.isHidden = false
        }
        if arrBenifi.count != 0{
            lbltapben.isHidden = true
        }
        else{
            lbltapben.isHidden = false
        }
        if arrLastWish.count != 0{
            lbltalast.isHidden = true
        }
        else{
            lbltalast.isHidden = false
        }
        if arrAddBox.count != 0{
            lbltapother.isHidden = true
        }
        else{
            lbltapother.isHidden = false
        }
        if arrNominee.count != 0{
            lbltanom.isHidden = true
        }
        else{
            lbltanom.isHidden = false
        }
        popup.isHidden = true
        popup1.isHidden = true
        popup2.isHidden = true
        popup3.isHidden = true
        popup4.isHidden = true
        popup5.isHidden = true
        hide()
    }
    
    func setBorderAndSetup(){
        vw6.setGradientBorder(Rect: CGRect(x: 1, y: 1, width: 72, height: 72), cornerRadius: 32, width: 2, colors: [#colorLiteral(red: 0.2744714916, green: 0.3137462139, blue: 0.3607364893, alpha: 1),#colorLiteral(red: 0.9607874751, green: 0.4784552455, blue: 0.2000235915, alpha: 1)])
        vw1.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw2.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 35, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw3.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw4.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw5.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw7.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        vw8.setLeftRadius(corners: [.topLeft, .bottomRight], cornerRadius: 30, bordercolor: AppDelegate.linecolor, borderWidth: 0.3)
        
        resertBorder()
    }

    
}


extension CreateUserWillViewController{
    
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
    
    func resertBorder(){
        lblText.alpha = 0
        vwtitle.alpha = 0
        
        lbldes.alpha = 0
        vwdes.alpha = 0
        
        lblLffn.alpha = 0
        lfnvw.alpha = 0
        lbllln.alpha = 0
        llnvw.alpha = 0
        lblLe.alpha = 0
        llevw.alpha = 0
        
        lblBfn.alpha = 0
        bfnvw.alpha = 0
        lblBln.alpha = 0
        blnvw.alpha = 0
        
        lblNfn.alpha = 0
        Nfnvw.alpha = 0
        lblNln.alpha = 0
        Nlnvw.alpha = 0
        lblNe.alpha = 0
        Nevw.alpha = 0
    }
    
}





////// Image selection //////////
extension CreateUserWillViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
//            imageView = self.resizeImage(image: imageView!, targetSize: CGSize(width: 500, height: 500))
            self.img.contentMode = .scaleAspectFill
            self.img.image = imageView!
            self.base64str = ConvertImageToBase64String(img: self.img.image!)
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


/////    Text fields handling //////

extension CreateUserWillViewController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != ""{
            return
        }
        if textField == txttitle{
            textField.placeholder = ""
            lblText.alpha = 0
            self.lblText.transform = CGAffineTransform(translationX: 0, y: 30)
            UIView.animate(withDuration: 0.5, animations: {
                self.vwtitle.alpha = 1
                self.lblText.alpha = 0.6
                self.lblText.transform = .identity
            }) { (true) in
            }
        }
        if textField == Lfname{
            textField.placeholder = ""
            lblLffn.alpha = 0
            self.lblLffn.transform = CGAffineTransform(translationX: 0, y: 30)
            UIView.animate(withDuration: 0.5, animations: {
                self.lfnvw.alpha = 1
                self.lblLffn.alpha = 0.6
                self.lblLffn.transform = .identity
            }) { (true) in
            }
            
        }
        if textField == LLname{
            textField.placeholder = ""
            self.lbllln.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lbllln.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lbllln.alpha = 0.6
                self.llnvw.alpha = 1
                self.lbllln.transform = .identity
            }) { (true) in
            }
        }
        if textField == LLEmail
        {
            textField.placeholder = ""
            self.lblLe.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblLe.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblLe.alpha = 0.6
                self.llevw.alpha = 1
                self.lblLe.transform = .identity
            }) { (true) in
            }
        }
        
        if textField == BFname{
            textField.placeholder = ""
            self.lblBfn.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblBfn.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblBfn.alpha = 0.6
                self.bfnvw.alpha = 1
                self.lblBfn.transform = .identity
            }) { (true) in
            }
        }
        if textField == BLname{
            textField.placeholder = ""
            self.lblBln.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblBln.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblBln.alpha = 0.6
                self.blnvw.alpha = 1
                self.lblBln.transform = .identity
            }) { (true) in
            }
        }
        if textField == Nfname{
            textField.placeholder = ""
            self.lblNfn.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblNfn.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblNfn.alpha = 0.6
                self.Nfnvw.alpha = 1
                self.lblNfn.transform = .identity
            }) { (true) in
            }
        }
        if textField == NLname{
            textField.placeholder = ""
            self.lblNln.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblNln.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblNln.alpha = 0.6
                self.Nlnvw.alpha = 1
                self.lblNln.transform = .identity
            }) { (true) in
            }
        }
        if textField == NEmail{
            textField.placeholder = ""
            self.lblNe.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblNe.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblNe.alpha = 0.6
                self.Nevw.alpha = 1
                self.lblNe.transform = .identity
            }) { (true) in
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txttitle{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Title"
            }
        }
        if textField == Lfname{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "First name"
            }
        }
        if textField == LLname{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Last name"
            }
        }
        if textField == LLEmail{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Lawyer Email"
            }
        }
        if textField == BFname{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "First name"
            }
        }
        if textField == BLname{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Last name"
            }
        }
        if textField == Nfname{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "First name"
            }
        }
        if textField == NLname{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Last name"
            }
        }
        if textField == NEmail{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Nominee Email"
            }
        }
        
    }

}





/////////// Api calls .////////////////

extension CreateUserWillViewController{
    
    func UserDeleteOthers(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/content/delete"
        let parameters = [
            "id": "\(id)"
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
                            self.arrAddBox.remove(at: indx)
                            self.BoxTbl.reloadData()
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
    
    func UserDeleteLastWish(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/wish/delete"
        let parameters = [
            "id": "\(id)"
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
                            self.arrLastWish.remove(at: indx)
                            self.LastTbl.reloadData()
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
    
    func UserDeleteNominee(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/nominee/delete"
        let parameters = [
            "id": "\(id)"
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
                            self.arrNominee.remove(at: indx)
                            self.NomTbl.reloadData()
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
    
    func UserDeleteBenificiaries(id:Int,indx: Int){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/beneficiary/delete"
        let parameters = [
            "id": "\(id)"
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
                            self.arrBenifi.remove(at: indx)
                            self.BenTbl.reloadData()
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
    
    func UserUpdatecustom(){
        var UserCustom: [NSMutableDictionary] = []
        for item in arrAddBox {
            let dic = NSMutableDictionary()
            if item.id == 0{
                dic.addEntries(from: ["id" : ""])
            }else{
                dic.addEntries(from: ["id" : "\(item.id)"])
            }
            dic.addEntries(from: ["title" : "\(item.title ?? "")"])
            dic.addEntries(from: ["content" : "\(item.content)"])
            UserCustom.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/content/update"
        let parameters = [
            "will_id": "\(objUserWillDetail.id)",
            "custom":UserCustom
            
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
                        self.txttitle.text = ""
                        self.txtdes.text = "Description"
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
    
    func UserUpdateWishes(){
        
        var UserWishes: [NSMutableDictionary] = []
        for item in arrLastWish {
            let dic = NSMutableDictionary()
            if item.id == 0{
                dic.addEntries(from: ["id" : ""])
            }else{
                dic.addEntries(from: ["id" : "\(item.willID)"])
            }
            dic.addEntries(from: ["content" : "\(item)"])
            UserWishes.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/wishes/update"
        let parameters = [
            "will_id": "\(objUserWillDetail.id)",
            "wishes":UserWishes
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
                        self.txtLast.text = "Last wish"
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
    
    func UserUpdateBenificiaries(){
        
        
        if arrBenifi.count == 0{
            alert3(view: self, msg: "Beneficiaries required!")
            return
        }
        
        var UserBenifi: [NSMutableDictionary] = []
        for item in arrBenifi {
            let dic = NSMutableDictionary()
            if item.id == 0{
                dic.addEntries(from: ["id" : ""])
            }else{
                dic.addEntries(from: ["id" : "\(item.id)"])
            }
            dic.addEntries(from: ["f_name" : "\(item.fName)"])
            dic.addEntries(from: ["l_name" : "\(item.lName)"])
            UserBenifi.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/beneficiaries/update"
        let parameters = [
            "will_id": "\(objUserWillDetail.id)",
            "beneficiaries":UserBenifi
            
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
                    if success == true
                    {
                        SVProgressHUD.dismiss()
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
   
    func UserUpdateNominee(){
        
        if arrNominee.count == 0{
            alert3(view: self, msg: "Nominee's required!")
            return
        }
        
        var UserNominee: [NSMutableDictionary] = []
        for (i,item) in arrNominee.enumerated() {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["id" : ""])
            dic.addEntries(from: ["f_name" : "\(item.fName)"])
            dic.addEntries(from: ["l_name" : "\(item.lName)"])
            dic.addEntries(from: ["email" : "\(item.email)"])
            dic.addEntries(from: ["priority" : "\(i+1)"])
            UserNominee.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/nominies/update"
        let parameters = [
            "will_id": "\(objUserWillDetail.id)",
            "nominies":UserNominee
            
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
    
    func UserUpdateLawyer(){
        
        if arrLaywer.count == 0{
            alert3(view: self, msg: "Laywer required!")
            return
        }
     
        let Userlaywer = NSMutableDictionary()
        for item in arrLaywer {
            Userlaywer.addEntries(from: ["id" : "\(item.id)"])
            print(item.id)
            Userlaywer.addEntries(from: ["f_name" : "\(item.fName)"])
            Userlaywer.addEntries(from: ["l_name" : "\(item.lName)"])
            Userlaywer.addEntries(from: ["email" : "\(item.email)"])
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lawyer/update"
        let parameters = [
            "will_id": "\(objUserWillDetail.id)",
            "lawyer":Userlaywer
            
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
    
    
    
    func UserUpdateWill(){
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
        if base64str == ""{
            alert3(view: self, msg: "Image required!")
            return
        }
        
        
            base64str = ConvertImageToBase64String(img: self.img.image ?? #imageLiteral(resourceName: "Graphic Bezel"))
            
        
        
        let UserConfession = NSMutableDictionary()
        UserConfession.addEntries(from: ["id" : "\(objUserWillDetail.confessions[0].id)"])
        UserConfession.addEntries(from: ["content" : "\(textview.text!)"])
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/update"
        let parameters = [
            "will_id": "\(objUserWillDetail.id)",
            "f_name":"\(txtfname.text!)",
            "l_name":"\(txtlname.text!)",
            "gender":"\(txtgender.text!)",
            "dob":"\(txtbirth.text!)",
            "display_image":"data:image/png;base64,\(base64str)",
            "confession": UserConfession,
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
    
    func GetUserWillDetails(){
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/detail"
//        print(AppDelegate.personalInfo.token)
        let para = ["ls_id":"\(objtofollow.id)"]
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        self.willflg = true
                        SVProgressHUD.dismiss()
                        let data = dic["data"]?.dictionary ?? [:]
                       
                        self.objUserWillDetail.id = data["id"]?.int ?? 0
                        willId = data["id"]?.int ?? 0
                        self.objUserWillDetail.lsID = data["ls_id"]?.int ?? 0
                        self.objUserWillDetail.fName = data["f_name"]?.string ?? ""
                        self.objUserWillDetail.lName = data["l_name"]?.string ?? ""
                        self.objUserWillDetail.dob = data["dob"]?.string ?? ""
                        self.objUserWillDetail.gender = data["gender"]?.string ?? ""
                        self.objUserWillDetail.image = data["image"]?.string ?? ""
                        
                        let arrlaw = data["lawyer"]?.array ?? []
                        for item in arrlaw{
                            let lbj = Lawyer()
                            lbj.id = item["id"].int ?? 0
                            lbj.fName = item["f_name"].string ?? ""
                            lbj.lName = item["l_name"].string ?? ""
                            lbj.email = item["email"].string ?? ""
                            self.arrLaywer.append(lbj)
//                            self.objUserWillDetail.lawyer.append(lbj)
                        }
                        
                        let arrNominee = data["nominies"]?.array ?? []
                        for item in arrNominee{
                            let lbj = Nominy()
                            lbj.id = item["id"].int ?? 0
                            lbj.fName = item["f_name"].string ?? ""
                            lbj.lName = item["l_name"].string ?? ""
                            lbj.email = item["email"].string ?? ""
                             self.arrNominee.append(lbj)
//                            self.objUserWillDetail.nominies.append(lbj)
                        }
                        
                        let arrBen = data["beneficiaries"]?.array ?? []
                        for item in arrBen{
                            let lbj = Beneficiary()
                            lbj.id = item["id"].int ?? 0
                            lbj.fName = item["f_name"].string ?? ""
                            lbj.lName = item["l_name"].string ?? ""
                            lbj.gender = item["gender"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            lbj.dob = item["dob"].string ?? ""
                            self.arrBenifi.append(lbj)
                            self.objUserWillDetail.beneficiaries.append(lbj)
                        }
                        
                        let arrCon = data["confessions"]?.array ?? []
                        for item in arrCon{
                            let lbj = Confession()
                            lbj.id = item["id"].int ?? 0
                            lbj.content = item["content"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            self.textview.text = lbj.content
                            self.objUserWillDetail.confessions.append(lbj)
                        }
                        let arrCustom = data["custom"]?.array ?? []
                        for item in arrCustom{
                            let lbj = Confession()
                            lbj.id = item["id"].int ?? 0
                            lbj.title = item["title"].string ?? ""
                            lbj.content = item["content"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            self.arrAddBox.append(lbj)
//                            self.objUserWillDetail.custom.append(lbj)
                        }
                        let arrwishes = data["wishes"]?.array ?? []
                        for item in arrwishes{
                            let lbj = Confession()
                            lbj.id = item["id"].int ?? 0
                            lbj.title = item["title"].string ?? ""
                            lbj.content = item["content"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            self.arrLastWish.append(lbj)
                            self.objUserWillDetail.wishes.append(lbj)
                        }
                        
                        let arrAttachments = data["attachments"]?.array ?? []
                        for item in arrAttachments{
                            let lbj = Attachment()
                            lbj.id = item["id"].int ?? 0
                            lbj.type = item["type"].string ?? ""
                             lbj.imageURL = item["image_url"].string ?? ""
                             lbj.thumbURL = item["thumb_url"].string ?? ""
                            lbj.willID = item["will_id"].int ?? 0
                            if lbj.type == "image" ||  lbj.type == "video" ||  lbj.type == "audio"{
                                 arrAttactment.append(lbj)
                            }
                            self.objUserWillDetail.attachments.append(lbj)
                        }
                        
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        if self.willflg{
                            self.btnUpdate.setTitle("UPDATE", for: .normal)
                            self.btnUploadMedia.isHidden = false
                            self.lblcretewill.isHidden = false
                            self.iconcreatewill.isHidden = false
                            self.vwheight.constant = 160
                        }else{
                            self.btnUpdate.setTitle("OK", for: .normal)
                            self.btnUploadMedia.isHidden = true
                            self.lblcretewill.isHidden = true
                            self.iconcreatewill.isHidden = true
                            self.vwheight.constant = 100
                        }
                        self.img.sd_setImage(with: URL(string: self.objUserWillDetail.image), placeholderImage: UIImage(named: "123"))
                        print(self.objUserWillDetail.image)
                        self.txtfname.text = self.objUserWillDetail.fName
                        self.txtlname.text = self.objUserWillDetail.lName
                        self.txtgender.text = self.objUserWillDetail.gender
                        self.txtbirth.text = self.objUserWillDetail.dob
                        self.LayTbl.reloadData()
                        self.BenTbl.reloadData()
                        self.LastTbl.reloadData()
                        self.BoxTbl.reloadData()
                        self.NomTbl.reloadData()
                        
//                        if self.img.image == #imageLiteral(resourceName: "E123") || self.img.image == nil
//                        {
//                            self.base64str = ""
//                        }
//                        else
//                        {
                            self.base64str = ConvertImageToBase64String(img: self.img.image ?? #imageLiteral(resourceName: "Utilitarian"))
//                        }
                        self.HidePopups()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
    func CreateWill(){
        
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
        
        if arrLaywer.count == 0{
            alert3(view: self, msg: "Laywer required!")
            return
        }
        if arrBenifi.count == 0{
            alert3(view: self, msg: "Beneficiaries required!")
            return
        }
        if arrNominee.count == 0{
            alert3(view: self, msg: "Nominee's required!")
            return
        }
        if base64str == ""{
            alert3(view: self, msg: "Image required!")
            return
        }
        
        let UserConfession = NSMutableDictionary()
        UserConfession.addEntries(from: ["content" : "\(textview.text!)"])
        
        let Userlaywer = NSMutableDictionary()
        for item in arrLaywer {
            Userlaywer.addEntries(from: ["f_name" : "\(item.fName)"])
            Userlaywer.addEntries(from: ["l_name" : "\(item.lName)"])
            Userlaywer.addEntries(from: ["email" : "\(item.email)"])
        }
        
        var UserBenifi: [NSMutableDictionary] = []
        for item in arrBenifi {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["f_name" : "\(item.fName)"])
            dic.addEntries(from: ["l_name" : "\(item.lName)"])
            UserBenifi.append(dic)
        }
        
        var UserCustom: [NSMutableDictionary] = []
        for item in arrAddBox {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["title" : "\(item.title ?? "")"])
            dic.addEntries(from: ["content" : "\(item.content)"])
            UserCustom.append(dic)
        }
        
        var UserWishes: [NSMutableDictionary] = []
        for item in arrLastWish {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["content" : "\(item)"])
            UserWishes.append(dic)
        }
        
        var UserNominee: [NSMutableDictionary] = []
        for (i,item) in arrNominee.enumerated() {
            let dic = NSMutableDictionary()
            dic.addEntries(from: ["f_name" : "\(item.fName)"])
            dic.addEntries(from: ["l_name" : "\(item.lName)"])
            dic.addEntries(from: ["email" : "\(item.email)"])
            dic.addEntries(from: ["priority" : "\(i+1)"])
            UserNominee.append(dic)
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/will/add"
        let parameters = [
            "ls_id": "\(objtofollow.id)",
            "f_name":"\(txtfname.text!)",
            "l_name":"\(txtlname.text!)",
            "gender":"\(txtgender.text!)",
            "dob":"\(txtbirth.text!)",
            "display_image":"data:image/png;base64,\(base64str)",
            "lawyer":Userlaywer,
            "beneficiaries":UserBenifi,
            "nominies": UserNominee,
            "confessions": UserConfession,
            "custom": UserCustom,
            "wishes":UserWishes
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
                    }
                    else{
                        SVProgressHUD.dismiss()
                        
                        let message = dic["message"]?.arrayValue ?? []
                        if message != []
                        {
                            var str = ""
                            for a in message
                            {
                                let messages = a.stringValue
                                str += "\(messages) \n"
                            }
                            alert3(view: self, msg: str)
                        }
                        else
                        {
                            let message = dic["message"]?.stringValue ?? ""
                            alert3(view: self, msg: message)
                        }
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






extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
