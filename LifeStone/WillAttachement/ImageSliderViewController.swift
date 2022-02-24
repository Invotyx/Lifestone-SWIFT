//
//  ImageSliderViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 05/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//

import UIKit
import SDWebImage

class ImageSliderViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var colve: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       UserLoad()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func UserLoad(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            var moveto = -1
            for (ind,itm) in arrimages.enumerated(){
                if itm == arrAttactment[seletedIndx].imageURL{
                    moveto = ind
                    break
                }
            }
            let myindx = IndexPath(row: moveto, section: 0)
            self.colve.scrollToItem(at: myindx, at: .right, animated: true)
        })
    }
}


extension ImageSliderViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrimages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! ImagesliderCollectionViewCell
        cell.img.sd_setImage(with: URL(string: arrimages[indexPath.row]), placeholderImage: UIImage(named: "123"))
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width), height: (collectionView.bounds.height))
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionInset
    }

}
