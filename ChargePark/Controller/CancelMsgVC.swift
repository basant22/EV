//
//  CancelMsgVC.swift
//  ChargePark
//
//  Created by apple on 29/10/21.
//

import UIKit

class CancelMsgVC: UIViewController {
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var btnConfirm:UIButton!
    @IBOutlet weak var brnCancel:UIButton!
    var confirmCancel:(UIViewController)->() = {_ in }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.menuHeaderColor.withAlphaComponent(0.450)
        viewContainer.round(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 18.0, color: Theme.menuHeaderColor)
        btnConfirm.cornerRadius(with: 6.0)
        brnCancel.cornerRadius(with: 6.0)
        btnConfirm.backgroundColor = Theme.menuHeaderColor
        brnCancel.backgroundColor = Theme.newGreen
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnConfirm(_ sender:UIButton){
        confirmCancel(self)
    }
    @IBAction func btnCancel(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
