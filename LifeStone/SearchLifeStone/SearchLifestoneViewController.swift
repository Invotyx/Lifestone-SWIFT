//
//  SearchLifestoneViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 23/08/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

var userobjdetail = LovedStone()

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SearchLifestoneViewController: UIViewController,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var lblnodata: UILabel!
    var is_private = 0
    var arrLoved:[LovedStone] = []
    @IBOutlet weak var colview: UICollectionView!
    @IBOutlet var searchbar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblnodata.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //         self.navigationController?.isNavigationBarHidden = false
        if flgsearch
        {
            is_private = 1
            flgsearch = false
            
            
            searchbar.text = replacesubstring()
        }
        else
        {
//            is_private = 0
            is_private = 1
            
        }
        colview.reloadData()
        self.navigationItem.titleView = searchbar
        if searchbar.text == ""
        {
            return
        }
        search()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationItem.titleView = nil
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func replacesubstring() -> String
    {
        let arr = [
            "above", "about", "across", "against", "along", "among", "around", "at", "before", "behind", "below", "beneath", "beside", "between", "beyond", "by",
            "down", "during", "except", "for", "from", "in", "inside", "into", "like", "near", "of", "off", "on", "since", "to", "toward", "through", "under", "until", "up", "upon", "with", "within",
            "can", "could", "have", "might", "must", "need", "ought", "shall", "should", "would","the","they","there","their","so","this","up","an","is","yes","no","you","was","were",
            "born","died","date","death","forever","anniversary","memory","loving","beloved"
        ]
        for item in arr
        {
            searchtxt =  searchtxt.replacingOccurrences(of: "\(item)", with: "")
        }
        return searchtxt
    }
}


extension SearchLifestoneViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLoved.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ForLovedOnesCollectionViewCell
        cell.img.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        cell.title.text = arrLoved[indexPath.row].fName+" "+arrLoved[indexPath.row].lName
        cell.date.text = arrLoved[indexPath.row].departureDate
        cell.dropShadow2(color: .darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true)
        cell.backImg.sd_setImage(with: URL(string: arrLoved[indexPath.row].displayImage!.replacingOccurrences(of: " ", with: "%20")), placeholderImage: UIImage(named: "123"))
        //        sure point is within the image
                cell.backImg.layer.cornerRadius = 15
                cell.backImg.clipsToBounds = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width/2-20), height: (collectionView.bounds.height/2-15))
        //         - (3 * 10))/2
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
        if arrLoved[indexPath.row].isPrivate == 1
        {
            alert3(view: self, msg: "This is Private lifestone. You cannot view its details.")
            return
        }
        if  arrLoved[indexPath.row].is_following == 0
        {
            userobjdetail = arrLoved[indexPath.row]
            //        alert(view: self, msg: "")
            self.performSegue(withIdentifier: "detail", sender: nil)
        }else{
            objtofollow = arrLoved[indexPath.row]
            UserTapped = UserRoleKey.Follow.rawValue
            self.performSegue(withIdentifier: "self", sender: nil)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchbar.endEditing(true)
    }
    
    
    ///////////////// Search bar ///////////////
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return  true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        search()
        searchBar.endEditing(true)
    }
    
    ///////////////////////// UserLogin Function ?????????/
    func search()  {
        
        SVProgressHUD.show(withStatus: "Loading")
        let urlstring = AppDelegate.baseurl+"api/lifestone/search"
        let headers = ["Accept":"application/json","Authorization":"Bearer \(AppDelegate.personalInfo.token)"]
        
        
        
        
        let value = searchbar.text!.split(separator: " ")
        
        var ans = " "
        
        for a in value
        {
            if a.count > 2
            {
                ans = ans + a + " "
                print(ans)
            }
            
        }

        print(ans)
        
        let para = ["search":"\(ans)","is_private":"\(is_private)"]
        
        
        print(para)
        
        
        Alamofire.request (urlstring ,method : .post, parameters: para, encoding
            : JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    let dic = json.dictionaryValue
                    print(dic)
                    let success = dic["success"]?.boolValue ?? false
                    if success == true {
                        self.arrLoved.removeAll()
                        let user = dic["lifestone"]?.array ?? []
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
                            obj.is_following = item["is_following"].int ?? 0
                            self.arrLoved.append(obj)
                        }
                        SVProgressHUD.dismiss()
                    }
                    else{
                        SVProgressHUD.dismiss()
//                        let message = dic["Message"]?.stringValue ?? ""
//                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        if self.arrLoved.count == 0{
                            self.lblnodata.isHidden = false
                        }else{
                            self.lblnodata.isHidden = true
                        }
                        self.colview.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
        }
        
    }
    
    
}
