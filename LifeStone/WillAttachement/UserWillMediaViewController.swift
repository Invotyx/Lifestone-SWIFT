//
//  UserWillMediaViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var objMedia = UserWillMediaViewController()
var seletedIndx = -1
var arrimages:[String] = []

import UIKit
import AVKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import ImageSlideshow
import SDWebImage
import AVFoundation

class UserWillMediaViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    var slideshow = ImageSlideshow()
    var sdWebImageSource :[SDWebImageSource] = []
    var flgselectAll = false
    var flgedit = false
    
    @IBOutlet weak var colvw: UICollectionView!
    @IBOutlet weak var btedit: UIButton!
    @IBOutlet weak var btselectAll: UIButton!
    @IBOutlet weak var btndelete: UIButton!
    @IBOutlet weak var vwheight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userload()
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
         changeStatus()
       reloadData()
    }
    
    
    @IBAction func btnDelete(_ sender: UIButton) {
        UserDeleteMedia()
    }
    
    @IBAction func btnedit(_ sender: UIButton) {
        if self.flgedit{
            flgedit = false
            btedit.setTitle("EDIT", for: .normal)
            for item in arrAttactment{
                item.ischk = false
            }
            colvw.reloadData()
        }else{
            flgedit = true
            btedit.setTitle("CANCEL", for: .normal)
        }
        changeStatus()
    }
    
    @IBAction func btnSelectAll(_ sender: UIButton) {
        if flgselectAll{
            btselectAll.setTitle("SELECT ALL", for: .normal)
            for item in arrAttactment{
                item.ischk = false
            }
             btedit.setTitle("EDIT", for: .normal)
             flgedit = false
            flgselectAll = false
            colvw.reloadData()
        }else{
            btselectAll.setTitle("DESELECT ALL", for: .normal)
            for item in arrAttactment{
                item.ischk = true
            }
            btedit.setTitle("CANCEL", for: .normal)
            flgedit = true
            flgselectAll = true
            colvw.reloadData()
        }
       changeStatus()
    }
    
}







extension UserWillMediaViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAttactment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! UserWillMediaCollectionViewCell
        cell.thumb.layer.cornerRadius = 10
        if arrAttactment[indexPath.row].type == "image"{
            cell.icon.image = #imageLiteral(resourceName: "image")
            cell.thumb.sd_setImage(with: URL(string: arrAttactment[indexPath.row].imageURL), placeholderImage: UIImage(named: "123"))
        }
        else if arrAttactment[indexPath.row].type == "audio"{
            cell.icon.image = #imageLiteral(resourceName: "music")
            cell.thumb.image = #imageLiteral(resourceName: "au")
        }
        else{
            cell.icon.image = #imageLiteral(resourceName: "video")
            cell.thumb.sd_setImage(with: URL(string: arrAttactment[indexPath.row].thumbURL), placeholderImage: UIImage(named: "123"))
        }
        if arrAttactment[indexPath.row].ischk{
            cell.chkimg.image = #imageLiteral(resourceName: "UnRbtn")
        }else{
            cell.chkimg.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width/2-20), height: (collectionView.bounds.width/2-20))
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
        if flgedit{
            if arrAttactment[indexPath.row].ischk{
                arrAttactment[indexPath.row].ischk = false
            }else{
                arrAttactment[indexPath.row].ischk = true
            }
            self.colvw.reloadData()
        }else{
            if arrAttactment[indexPath.row].type == "video"{
                playLocalVideo(indx: indexPath.row)
            }
            if arrAttactment[indexPath.row].type == "image"{
                seletedIndx = indexPath.row
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
                    {
                    var moveto = -1
                    for (ind,itm) in arrimages.enumerated(){
                        if itm == arrAttactment[seletedIndx].imageURL{
                            moveto = ind
                            break
                        }
                    }
                    self.slideshow.setCurrentPage(moveto, animated: true)
                    let fullScreenController = self.slideshow.presentFullScreenController(from: self)
                    fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
                })
                
            }
            if arrAttactment[indexPath.row].type == "audio"{
                seletedIndx = indexPath.row
                playAudioFile(indx: indexPath.row)
            }
        }
    }
    
    
    
    
    
    
}









extension UserWillMediaViewController{
    
    func userload(){
        objMedia = self
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
    }
    
    func playAudioFile(indx: Int) {
        let audioFileURL = URL(string: arrAttactment[indx].imageURL)
        let playerItem = AVPlayerItem(url: audioFileURL!)
        let player=AVPlayer(playerItem: playerItem)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
        player.play()
    }
    
    
    func playLocalVideo(indx: Int) {
        let videoURL = URL(string: arrAttactment[indx].imageURL)
        let player = AVPlayer(url: (videoURL as URL?)!)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
    
    func setupLongPressGesture()
    {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.colvw.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer)
    {
        let touchPoint = gestureRecognizer.location(in: self.colvw)
        
        if colvw.indexPathForItem(at: touchPoint) != nil
        {
            flgedit = true
            let indx = colvw.indexPathForItem(at: touchPoint)
            arrAttactment[(indx?.row)!].ischk = true
            self.colvw.reloadData()
        }
    }
    
    func changeStatus(){
        if self.flgedit{
            UIView.animate(withDuration: 0.3) {
                self.vwheight.constant  = 60
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.vwheight.constant  = 0
            }
        }
        colvw.layoutIfNeeded()
    }
    
    func  reloadData(){
        DispatchQueue.main.async{
            arrimages.removeAll()
            for item in arrAttactment{
                if item.type == "image"{
                    arrimages.append(item.imageURL)
                }
            }
            self.colvw.reloadData()
            self.sdWebImageSource.removeAll()
            for item in arrimages{
                self.sdWebImageSource.append(SDWebImageSource(urlString: item)!)
            }
            self.slideshow.setImageInputs(self.sdWebImageSource)
            self.colvw.reloadData()
        }
    }
    
}








extension UserWillMediaViewController{
    
    func UserDeleteMedia(){
        
        var UserMedia: [NSMutableDictionary] = []
        for item in arrAttactment {
            if item.ischk{
                let data = NSMutableDictionary()
                data.addEntries(from: ["id" : "\(item.id)"])
                UserMedia.append(data)
            }
        }
        if UserMedia.count == 0{
            alert3(view: self, msg: "No Item Selected to be deleted!")
            return
        }
        SVProgressHUD.show(withStatus: "Deleting...")
        let urlstring = AppDelegate.baseurl+"api/will/attachment/delete"
        let parameters = [
            "attachments":UserMedia
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
                        var temp:[Attachment] = []
                        for item in arrAttactment{
                            if !item.ischk{
                                temp.append(item)
                            }
                        }
                        arrAttactment.removeAll()
                        for item in temp{
                            arrAttactment.append(item)
                        }
                    }
                    else{
                        SVProgressHUD.dismiss()
                        let message = dic["message"]?.stringValue ?? ""
                        alert3(view: self, msg: message)
                    }
                    DispatchQueue.main.async {
                        self.btnedit(self.btedit)
                        self.changeStatus()
                        self.reloadData()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error.localizedDescription)
                }
                
        }
    }
    
}









extension UserWillMediaViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
