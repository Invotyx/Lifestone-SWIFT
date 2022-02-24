//
//  CreateLifestonePopupViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 07/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var objpop1 = CreateLifestonePopupViewController()
import UIKit
import Alamofire
import SwiftyJSON


class CreateLifestonePopupViewController: UIViewController {

    @IBOutlet weak var createprofile_img: UIImageView!
    var flggofor = false
    @IBOutlet weak var vw: RoundUIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        objpop1 = self
        self.userGetStones()
    }
    
    func userDismiss(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func btnGoForward(_ sender: UITapGestureRecognizer) {
        if flggofor{
            
             self.performSegue(withIdentifier: "gofor", sender: nil)
        }else{
            
                let message = "Self Lifestone has already been created"
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    print(message)
                }))
                self.present(alert, animated: true, completion: nil)
        }}
    @IBAction func btnback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///////////////////////// UserLogin Function ?????????/
    func userGetStones()  {
        
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
                        let user = data["self_stone"]?.array ?? []
                        if user.count>0{
                            
                        }else{
                            self.flggofor = true
                        }
                    }
                    else{
//                        let message = dic["message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        if self.flggofor{
                            self.createprofile_img.image = UIImage(named: "create-1")
                        }else{
//                            self.createprofile_img.image = #imageLiteral(resourceName: "create-2")
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
    }

    
    
}
