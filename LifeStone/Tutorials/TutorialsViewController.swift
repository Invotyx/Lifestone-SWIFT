//
//  TutorialsViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 04/07/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
class Tut{
    var title,image,des:String
    init() {
        self.title = ""
        self.image = ""
        self.des = ""
    }
    init(title:String,image:String,des:String) {
        self.title = title
        self.image = image
        self.des = des
    }
}

import UIKit

class TutorialsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pagecontrol: CustomPageControl!
    var arrtut:[Tut] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrtut.append(Tut.init(title: "About LifeStone", image: "Square", des: " Discover new ways to preserve your memories with this app."))
        arrtut.append(Tut.init(title: "Establish Family Pond", image: "Square", des: " Discover new ways to preserve your memories with this app."))
        arrtut.append(Tut.init(title: "Upload Media Files", image: "Media", des: " Discover new ways to preserve your memories with this app."))
         arrtut.append(Tut.init(title: "Manage Multiple Profiles", image: "Persons", des: " Discover new ways to preserve your memories with this app."))
        
    }
    
    
    @IBAction func btnSkipAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pagecontrol.numberOfPages = arrtut.count
        return arrtut.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! TutorialCollectionViewCell
        cell.lbltitle.text = arrtut[indexPath.row].title
        cell.lbldes.text = arrtut[indexPath.row].des
        cell.img.image = UIImage(named: arrtut[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pagecontrol.currentPage = indexPath.row
        pagecontrol.transform = CGAffineTransform(scaleX: 2, y: 2)
        if indexPath.row == arrtut.count-1{
            btnSkip.setTitle("Done", for: .normal)
        }else{
            btnSkip.setTitle("Skip", for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (UIScreen.main.bounds.width), height: (collectionView.bounds.height))
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
    
    

}




