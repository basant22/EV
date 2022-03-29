//
//  AddRfidVC.swift
//  ChargePark
//
//  Created by apple on 05/03/22.
//

import UIKit
import SkyFloatingLabelTextField

class AddRfidVC: UIViewController {

    @IBOutlet weak var btnSubmit:UIButton!
    @IBOutlet weak var viewMain:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtRfid:SkyFloatingLabelTextField!
    var calledAddRfid:((String,UIViewController)->()) = { _,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        self.view.backgroundColor = .black.withAlphaComponent(0.55)
        // Do any additional setup after loading the view.
    }
    func setTheme(){
        viewMain.cornerRadius(with: 8.0)
        btnSubmit.cornerRadius(with: 8.0)
        btnSubmit.setTitle("Submit", for: .normal)
        btnSubmit.backgroundColor = Theme.menuHeaderColor
        btnSubmit.setTitleColor(.white, for: .normal)
    }
    @IBAction func btnSubmit(_ sender:UIButton){
        if (txtRfid.text!.count > 0)  {
            calledAddRfid(txtRfid.text!,self)
        }else{
            self.displayAlert(alertMessage: "Please Enter RFID")
        }
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
extension AddRfidVC:UITextViewDelegate{
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        return true;
    }
}
