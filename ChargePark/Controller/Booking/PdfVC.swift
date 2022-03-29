//
//  PdfVC.swift
//  ChargePark
//
//  Created by apple on 27/01/22.
//

import UIKit
import PDFKit
class PdfVC: UIViewController {
   
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewPdf: PDFView!
    @IBOutlet weak var btnCancel: UIButton!
    var pdfURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeader.backgroundColor = Theme.menuHeaderColor
        self.btnCancel.setTitle("", for: .normal)
        let img = UIImage(systemName: "xmark")?.tint(with: .white)
        self.btnCancel.setImage(img, for: .normal)
        // Do any additional setup after loading the view.
        
                
                if let document = PDFDocument(url: pdfURL) {
                    viewPdf.document = document
                }
                
//                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                    self.dismiss(animated: true, completion: nil)
//                }
    }
    
    @IBAction func dismis(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
