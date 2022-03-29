//
//  AddFundVC.swift
//  ChargePark
//
//  Created by apple on 27/10/21.
//

import UIKit
import SkyFloatingLabelTextField

class AddFundVC: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var txtFund: SkyFloatingLabelTextField!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    var arrOfFunds = [50,100,150,200,250,300,350,400]
    var fund = ""
    var payHandler:((Int,UIViewController)->()) = {_,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
  internal func setTheme(){
      txtFund.selectedTitleColor = Theme.menuHeaderColor
      txtFund.selectedLineColor = Theme.menuHeaderColor
    //  lblHeading.text = "\u{20B9} ADD FUND"
     // txtFund.iconImage = UIImage(named: "Rupees")?.tint(with: Theme.menuHeaderColor)
      txtFund.placeholder = "\u{20B9}" + "Add Amount"
      btnCancel.setTitle("", for: .normal)
     // let img = UIImage(named: "Cancel")
      let img = UIImage(systemName: "xmark.circle")
       btnCancel.setImage(img!.tint(with: Theme.menuHeaderColor), for: .normal)
       txtFund.keyboardType = .numberPad
       viewContainer.layer.borderWidth = 1.0
       viewContainer.layer.borderColor = Theme.menuHeaderColor.cgColor
       viewContainer.backgroundColor = .white
        viewContainer.cornerRadiusWitBorder(with: 12.0, border: Theme.menuHeaderColor)
       viewContainer.round(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12.0, color: Theme.menuHeaderColor)
      btnPay.setTitleColor(.white, for: .normal)
       btnPay.backgroundColor = Theme.menuHeaderColor
       btnPay.round(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12.0, color: Theme.menuHeaderColor)
          //.cornerRadius(with: 6.0)
      btn1.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn1.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn2.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn2.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn3.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn3.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn4.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn4.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn5.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn5.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn6.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn6.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn7.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn7.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
      btn8.setTitleColor(Theme.menuHeaderColor, for: .normal)
      btn8.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
    }
   
    @IBAction func addToPay(_ sender:UIButton){
          fund = String(arrOfFunds[sender.tag - 1])
          txtFund.text =  fund
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPay(_ sender: UIButton) {
        if txtFund.text?.count == 0 {
            self.displayAlert(alertMessage: "Fund is not added")
        }else{
            if let txt = txtFund.text,let amount = Int(txt),amount != 0 {
            self.payHandler(amount,self)
            }
        }
    }
    deinit{
        print("\(self) is deinit")
    }
}
extension AddFundVC:UITextViewDelegate{
   // textFieldShouldBeginEditing(<#T##UITextField#>)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        return true
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
}
