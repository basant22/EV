//
//  ForgetVC.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import UIKit
import SkyFloatingLabelTextField
class ForgetVC: UIViewController {
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var backButton:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    @IBOutlet weak var cardView:UIView!
    @IBOutlet weak var txt1:SkyFloatingLabelTextField!
    @IBOutlet weak var txt2:SkyFloatingLabelTextField!
    @IBOutlet weak var txt3:SkyFloatingLabelTextField!
    @IBOutlet weak var txt4:SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword:SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword:SkyFloatingLabelTextField!
    @IBOutlet weak var btnReset:UIButton!
    @IBOutlet weak var btnShFirst:UIButton!
    @IBOutlet weak var btnShSecond:UIButton!
    var logedIn:LogedInManager!
    var userName:String?
    var password:String?
    var token = ""
    var boolFirst = false
    var boolSecond = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        backButton.action = #selector(back)
        btnReset.cornerRadius(with: 6.0)
        cardView.backgroundColor = .clear
        btnReset.backgroundColor = Theme.menuHeaderColor
        txtPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true
        txt1.delegate = self
        txt2.delegate = self
        txt3.delegate = self
        txt4.delegate = self
        txt1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt3.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txt4.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.logedIn = LogedInManager()
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Re-set your password"
        }
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(textField: UITextField){

        let txt = textField.text
        if txt!.count >= 1{
            switch textField{
            case txt1:
                txt2.becomeFirstResponder()
            case txt2:
                txt3.becomeFirstResponder()
            case txt3:
                txt4.becomeFirstResponder()
            case txt4:
                txt4.resignFirstResponder()
            default:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        forgotPassword()
    }
    @IBAction func showHidePassword(_ sender:UIButton){
        let tag = sender.tag
        switch tag {
        case 1:
            if boolFirst {
                btnShFirst.setImage(#imageLiteral(resourceName: "Hide"), for: .normal)
                boolFirst = false
                txtPassword.isSecureTextEntry = true
            }else{
                btnShFirst.setImage(#imageLiteral(resourceName: "Show"), for: .normal)
                boolFirst = true
                txtPassword.isSecureTextEntry = false
            }
            
        case 2:
            if boolSecond {
                btnShSecond.setImage(#imageLiteral(resourceName: "Hide"), for: .normal)
                boolSecond = false
                txtConfirmPassword.isSecureTextEntry = true
            }else{
                btnShSecond.setImage(#imageLiteral(resourceName: "Show"), for: .normal)
                boolSecond = true
                txtConfirmPassword.isSecureTextEntry = false
            }
        default:
            print("")
        }
    }
    @IBAction func resetPassword(_ sender:UIButton){
        if let tx1 = txt1.text, tx1.count == 0 {
            self.displayAlert(alertMessage: "Please fill OTP you have received")
        }else if let tx2 =  txt2.text, tx2.count  == 0 {
            self.displayAlert(alertMessage: "Please fill OTP you have received")
        }else if let tx3 =  txt3.text, tx3.count  == 0 {
            self.displayAlert(alertMessage: "Please fill OTP you have received")
        }else if let tx4 =  txt4.text, tx4.count == 0 {
            self.displayAlert(alertMessage: "Please fill OTP you have received")
        }else if txtPassword.text?.count ?? 0 == 0 {
            self.displayAlert(alertMessage: "Please enter new password")
        }else if txtConfirmPassword.text?.count ?? 0 == 0{
            self.displayAlert(alertMessage: "Please enter confirm password")
        }else if txtPassword.text != txtConfirmPassword.text{
            self.displayAlert(alertMessage: "Mismatch password enter again")
        }else{
            token = txt1.text! + txt2.text! + txt3.text! + txt4.text!
            resetForgotPassword()
        }
       
    }
  private func saveLoginInfoInUserDefaults(data:ResultLogin){
          guard let data = try? JSONEncoder().encode(data) else {
            fatalError("unable encode as data")
          }
        UserDefaults.standard.set(data, forKey: Theme.LoginInfo)
    }
    func forgotPassword()  {
        let req = ApiGetRequest()
        if let username = userName {
            //ForgotResponse
            self.showLoader()
            req.kindOf(Theme.OTPConnector, requestFor: .FORGOT_PASSWORD_OTP, queryString: [username], response: ForgotResponse.self) {[weak self] respons in
                self?.hideLoader()
                if let res = respons,let msg = res.message,msg == "Ok"{
                    DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "OTP has been sent on mobile number")
                    }
                }
            }
//            }
//            req.getOtpForForgotPassword(username, connector: Theme.OTPConnector) { response in
//                self.hideLoader()
//                if let res = response,let msg = res.message,msg == "Ok"{
//                    DispatchQueue.main.async {
//                        self.displayAlert(alertMessage: "OTP has been sent on mobile number")
//                    }
//
//                }
//            }
        }
    }
    func resetForgotPassword(){
       // let req = ResetPassword()
        let request = ResetPasswordRequest(username:self.userName! , password: txtPassword.text!, token: self.token)
        let reqq = ApiPostRequest()
        reqq.kindOf(Theme.ForgetPConnector, requestFor: .RESET_FORGOT_PASSWORD,request: request, response:LoginResponse.self) { [weak self] respon in
            if let res = respon,let msg = res.message,let succ = res.success, msg == "Ok"{
               // self?.logedIn.deleteLogedIn()
               // self?.logedIn.createLogedInUser()
               // Defaults.shared.userLogin = result
               // self?.saveLoginInfoInUserDefaults(data: result)
                DispatchQueue.main.async {
                 self?.displayAlert(alertMessage: "Password Changed successfully")
                }
        }
//        req.resetPasswordForUser(request: request, loginText:Theme.ForgetPConnector, controller: self) { response in
//            if let res = response,let msg = res.message,let succ = res.success,succ == true{
//                DispatchQueue.main.async {
//                self.displayAlert(alertMessage: msg)
//                }
//            }
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
   
    deinit {
        print("\(self) id deinitialized")
    }
    
    @IBAction func textChange(_ sender: SkyFloatingLabelTextField) {
        
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
extension ForgetVC:UITextFieldDelegate{
    
}
