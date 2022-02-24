//
//  OpenPdfViewController.swift
//  LifeStone
//
//  Created by Wajih Invotyx on 11/09/2019.
//  Copyright © 2019 Invotyx. All rights reserved.
//
var str = ""
import UIKit
import PDFKit
import SVProgressHUD

class OpenPdfViewController: UIViewController {
    
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        act.isHidden = false
        act.startAnimating()
        DispatchQueue.main.async
        {
            
            self.loadpdf()
        }
        
        
    }
  
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func loadpdf(){
        
        self.pdfView.autoScales = true
        // Load Sample.pdf file.
        //        let fileURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf")
        let url = URL(string: str)
        //        pdfView.document = PDFDocument(url: url!)
        
        if let pdf = PDFDocument(url: url!){
            print("andy ala burger")
            self.pdfView.document =  pdf
            act.stopAnimating()
            act.isHidden = true
        }else{
            alert3(view: self, msg: "No file found")
            act.isHidden = true
            act.stopAnimating()
        }
    }
    
}
