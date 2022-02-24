//
//  AddEventViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 17/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire
import SVProgressHUD

class AddEventViewController: UIViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var vw: UIView!
    var lat = ""
    var long = ""
    var gpsstr = ""
    var dt = ""
    var tm = ""
    
    
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var vwevent: UIView!
    @IBOutlet weak var txtevent: UITextField!
    
    @IBOutlet weak var lblabout: UILabel!
    @IBOutlet weak var vwabout: UIView!
    @IBOutlet weak var txtabout: UITextField!
    
    @IBOutlet weak var lblselectdata: UILabel!
    @IBOutlet weak var vwselectdate: UIView!
    @IBOutlet weak var btnselectdata: UIButton!
    
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var vwlocation: UIView!
    @IBOutlet weak var btnlocation: UIButton!
    
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var vwtime: UIView!
    @IBOutlet weak var btntime: UIButton!
    
    @IBOutlet weak var lblduration: UILabel!
    @IBOutlet weak var vwduration: UIView!
    @IBOutlet weak var txtduration: UITextField!
    
    @IBOutlet weak var dtp: UIDatePicker!
    @IBOutlet var popup1: UIView!
    
    @IBOutlet weak var dtp1: UIDatePicker!
    @IBOutlet var popup2: UIView!
    @IBOutlet weak var vw1: UIView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var blurview: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      UserLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddEvent(_ sender: UIButton) {
        self.UserUpdateGoals()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        blurview.isHidden = true
        popup1.isHidden = true
        popup2.isHidden = true
    }
    
    @IBAction func btnOkTime(_ sender: UIButton) {
        let format1 = DateFormatter()
        format1.dateFormat = "HH:mm"//"HH:mm:ss"
        format1.timeZone = TimeZone.current
        tm = format1.string(from: dtp1.date)
        format1.dateFormat = "HH:mm"//"HH:mm:ss a"
        format1.timeZone = TimeZone.current
        let a = format1.string(from: dtp1.date)
        btntime.setTitle(a, for: .normal)
        dtp1.date = Date()
        popup2.isHidden = true
        blurview.isHidden = true
    }
    
    @IBAction func btnOk(_ sender: UIButton)
    {
        let format1 = DateFormatter()
        format1.dateFormat = "dd-MM-yyyy"
        format1.timeZone = TimeZone.current
        dt = format1.string(from: dtp.date)
        btnselectdata.setTitle(dt, for: .normal)
        dtp.date = Date()
        popup1.isHidden = true
        blurview.isHidden = true
    }
    
    @IBAction func btnSelectDate(_ sender: UIButton) {
        self.view.endEditing(true)
        self.btnselectdata.setTitle("", for: .normal)
        lblselectdata.alpha = 0
        self.lblselectdata.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.5, animations: {
            self.vwselectdate.alpha = 1
            self.lblselectdata.alpha = 0.6
            self.lblselectdata.transform = .identity
        }) { (true) in
            animatecenter(VC: self, Popview: self.popup1)
            self.blurview.isHidden = false
        }
    }
    
    @IBAction func btnSelectlocation(_ sender: UIButton)
    {
        self.view.endEditing(true)
        lbllocation.alpha = 0
        print(Pickgpsstr)
        self.btnlocation.setTitle("\(Pickgpsstr)", for: .normal)
        self.lbllocation.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.5, animations: {
            self.vwlocation.alpha = 1
            self.lbllocation.alpha = 0.6
            self.lbllocation.transform = .identity
        }) { (true) in
          //  self.getPlacePickerView()
//            let nc = UINavigationController()
//            let vc = nc.viewControllers[0] as! GGetUserLocationViewController
//            vc.vc = self
//            self.present(vc, animated: true, completion: nil)
             self.performSegue(withIdentifier: "getloc", sender: nil)
//            self.lbllocation.text = Pickgpsstr
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "getloc"
        {
            if let navVC = segue.destination as? UINavigationController
            {
                if let vc = navVC.viewControllers[0] as? GGetUserLocationViewController
                {
                    vc.showvc = true
                    vc.vc = self
                }
            }
        }
    }
    
    @IBAction func btntime(_ sender: UIButton)
    {
        self.view.endEditing(true)
        lbltime.alpha = 0
        self.btntime.setTitle("", for: .normal)
        self.lbltime.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.5, animations: {
            self.vwtime.alpha = 1
            self.lbltime.alpha = 0.6
            self.lbltime.transform = .identity
        }) { (true) in
            animatecenter(VC: self, Popview: self.popup2)
            self.blurview.isHidden = false
        }
    }

    func UserLoad(){
        resertBorder()
        
        self.txtevent.placeholder = "Event Title"
        self.txtabout.placeholder = "About the Event..."
        self.txtduration.placeholder = "Duration (Hours)"
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(Usergesture))
        self.vw1.addGestureRecognizer(gesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    

}

extension AddEventViewController{
   
    
    
    func UserUpdateGoals(){
        if txtevent.text == ""{
            alert3(view: self, msg: "Event title Required")
            return
        }
        
        if txtabout.text == ""{
            alert3(view: self, msg: "Event Description Required")
            return
        }
        if txtduration.text == ""{
            alert3(view: self, msg: "Event Duration Required")
            return
        }
        if btnselectdata.titleLabel?.text == ""{
            alert3(view: self, msg: "Event Date Required")
            return
        }
        if btntime.titleLabel?.text == ""{
            alert3(view: self, msg: "Event Time Required")
            return
        }
        if Picklat == ""{
            alert3(view: self, msg: "Location Required")
            return
        }
        if Picklong == ""{
            alert3(view: self, msg: "Location Required")
            return
        }
        if Pickgpsstr == ""{
            alert3(view: self, msg: "Location Required")
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/event"
        let parameters = [
            "ls_id": "\(objtofollow.id)",
            "title":"\(txtevent.text!)",
            "description":"\(txtabout.text!)",
            "address":"\(Pickgpsstr)",
            "lat":"\(Picklat)",
            "long":"\(Picklong)",
            "date":"\(self.dt)",
            "time":"\(self.tm)",
            "duration":"\(txtduration.text!)"
            ] as [String : Any]
        
        print(parameters)
        
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)","Content-Type":"application/json"]
        Alamofire.request (urlstring ,method : .post, parameters: parameters, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        let message = dic["message"]?.stringValue ?? ""
                        
//                           let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
//                           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
//                            { (UIAlertAction) in
//                                
//                            }))
//                           self.present(alert, animated: true, completion: nil)
                       
                    }
                    else
                    {
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                     DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        objEvent.GetEvents()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
        }
    }
}







extension AddEventViewController{
    
    
    func resertBorder(){
        lblEvent.alpha = 0
        vwevent.alpha = 0
        
        lblabout.alpha = 0
        vwabout.alpha = 0
        
        lblselectdata.alpha = 0
        vwselectdate.alpha = 0
        
        lbllocation.alpha = 0
        vwlocation.alpha = 0
        
        lbltime.alpha = 0
        vwtime.alpha = 0
        
        lblduration.alpha = 0
        vwduration.alpha = 0
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblselectdata.alpha = 0
        vwselectdate.alpha = 0
        
        lbllocation.alpha = 0
        vwlocation.alpha = 0
        
        lbltime.alpha = 0
        vwtime.alpha = 0
        if textField.text != ""{
            return
        }
        if textField == txtevent{
            textField.placeholder = ""
            lblEvent.alpha = 0
            self.lblEvent.transform = CGAffineTransform(translationX: 0, y: 30)
            UIView.animate(withDuration: 0.5, animations: {
                self.vwevent.alpha = 1
                self.lblEvent.alpha = 0.6
                self.lblEvent.transform = .identity
            }) { (true) in
            }
        }
        if textField == txtabout{
            textField.placeholder = ""
            lblabout.alpha = 0
            self.lblabout.transform = CGAffineTransform(translationX: 0, y: 30)
            UIView.animate(withDuration: 0.5, animations: {
                self.vwabout.alpha = 1
                self.lblabout.alpha = 0.6
                self.lblabout.transform = .identity
            }) { (true) in
            }
            
        }
        if textField == txtduration{
            textField.placeholder = ""
            self.lblduration.transform = CGAffineTransform(translationX: 0, y: 30)
            self.lblduration.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.lblduration.alpha = 0.6
                self.vwduration.alpha = 1
                self.lblduration.transform = .identity
            }) { (true) in
            }
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtevent{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Event Title"
            }
        }
        if textField == txtabout{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "About the Event..."
            }
        }
        if textField == txtduration{
            if textField.text == ""{
                resertBorder()
                textField.placeholder = "Duration (Hours)"
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        ScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero //UIEdgeInsetsZero
        ScrollView.contentInset = contentInset
    }
    
    @objc func Usergesture(){
        self.view.endEditing(true)
        lblselectdata.alpha = 0
        vwselectdate.alpha = 0
        
        lbllocation.alpha = 0
        vwlocation.alpha = 0
        
        lbltime.alpha = 0
        vwtime.alpha = 0
    }
    

    
}
