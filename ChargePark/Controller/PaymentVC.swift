//
//  PaymentVC.swift
//  ChargePark
//
//  Created by apple on 24/10/21.
//

import UIKit
import Razorpay
import PaytmNativeSDK
class PaymentVC: UIViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleButton: UIBarButtonItem!
    @IBOutlet weak var navigationCon: UINavigationBar!
    @IBOutlet weak var viewLabels: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btnAddFund: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnTransactionHistory: UIButton!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var lblUserBalance: UILabel!
    @IBOutlet weak var lblRFID: UILabel!
    typealias Razorpay = RazorpayCheckout
    var razorpay: Razorpay!
    var alert:UIAlertController!
    var addedAmount:Int = 0
    var transactionId:Int!
    var type:String!
    var addFundDetails:AddFundDetails!
    var paymentData:[String:Any] = [:]
    var username = ""
    var usingFrom = ""
    var userBalance = 0.0
    var savePaytm:SavePatmRespo!
    let appInvoke = AIHandler()
    var logedIn:LogedInManager!
    var donePayment:(Bool,Double,String,UIViewController)->() = { _,_,_,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        logedIn = LogedInManager()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        btnAddFund.setTitle("Add Fund", for: .normal)
        btnTransactionHistory.setTitle("Transaction History", for: .normal)
        lblRFID.text = ""
        if let login = Defaults.shared.userLogin,let userId = login.username {
            lblUserId.text = "UserId: " + "\(userId)"
            username = userId
        }else{
            lblUserId.text = "UserId: "
        }
        if let usrProfile = Defaults.shared.usrProfile,let balanceamount = usrProfile.balanceamount {
            lblUserBalance.text = "Account Balance: " + Theme.INRSign + String(format:"%.02f",balanceamount)
        }else{
            lblUserBalance.text = "Account Balance: " + Theme.INRSign + "0.00"
        }
        if let key = Defaults.shared.appConfig?.rzrpayKeyid{
          //  self.razorpay = Razorpay.initWithKey(key, andDelegate: self)
            self.razorpay  =  Razorpay.initWithKey(key, andDelegateWithData: self)
        }
        
        
        if self.usingFrom == "Booking" {
            btnCancel.isHidden = false
            menuButton.isEnabled = false
        }else{
            menuButton.isEnabled = true
            btnCancel.isHidden = true
        }
        
        if Theme.appName == "VRAJEV Charge"{
            self.titleButton.title = "My Pocket"
        }
        if Theme.appName == "EV Plugin Charge"{
            self.titleButton.title = "My Purse"
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setTheme()
        if let paymentType = Defaults.shared.paymentType {
            switch paymentType {
            case .Instant:
                menuButton.image = #imageLiteral(resourceName: "Back").tint(with: .white)
                menuButton.action = #selector(back)
            case .Pre:
                menuButton.image = #imageLiteral(resourceName: "ic_menu_white")
                if  self.revealViewController() != nil{
                    menuButton.target = self.revealViewController()
                    menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                    menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }
            }
        }
    }
    func setTheme(){
        self.view.backgroundColor = .lightGray
        self.btnRefresh.cornerRadius(with: 8.0)
        self.btnRefresh.backgroundColor = Theme.menuHeaderColor
        self.btnRefresh.setTitleColor(.white, for: .normal)
        
        viewLabels.cornerRadius(with: 6.0)
        viewLabels.backgroundColor = .white
        viewLabels.layer.borderColor = Theme.menuHeaderColor.cgColor
        viewLabels.layer.borderWidth = 1.0
       
        viewButtons.cornerRadius(with: 6.0)
        viewButtons.backgroundColor = .white
        viewButtons.layer.borderColor = Theme.menuHeaderColor.cgColor
        viewButtons.layer.borderWidth = 1.0
        
        btnAddFund.cornerRadius(with: 6.0)
        btnAddFund.setTitleColor(.white, for: .normal)
        btnAddFund.backgroundColor = Theme.menuHeaderColor
        
        btnTransactionHistory.cornerRadius(with: 6.0)
        btnTransactionHistory.setTitleColor(.white, for: .normal)
        btnTransactionHistory.backgroundColor = Theme.newGreen
        
        btnCancel.setTitle("Done", for: .normal)
//        let img =  UIImage(systemName: "xmark")?.tint(with: .white)
//        btnCancel.setImage(img, for: .normal)
        btnCancel.backgroundColor = Theme.menuHeaderColor
        btnCancel.cornerRadius(with: 8.0)
    }
    deinit{
        print("\(self) is deinit")
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         if segue.identifier == "AddFund"{
             if let vc = segue.destination as? AddFundVC{
                 vc.payHandler = { [weak self] amount,controller in
                     controller.dismiss(animated: true) {
                         if amount >= 1 {
                             self?.addedAmount = amount
                             if Theme.appName == "EV Plugin Charge" {
                                 self?.addFundUsingPaytm()
                             }else{
                             self?.addFund()
                             }
                            //
                         }else{
                             self?.view.makeToast("Amount must be equal or grater than ruppess 1.")
                         }
                     }
                 }
             }
         }else if segue.identifier == "Transaction"{
             if let vc = segue.destination as? TransactionVC{
                 if let results = sender as? [SavePaymentResult]{
                     vc.transaction = results
                 }
             }
         }
     }
     
    @IBAction func btnCancel(_ sender:UIButton){
        if let usrProfile = Defaults.shared.usrProfile,let balanceamount = usrProfile.balanceamount {
            self.userBalance = balanceamount
        }
        
        self.donePayment(true,self.userBalance,"",self)
    }
    @IBAction func btnAddFund(_ sender:UIButton){
       // showAlertWithText()
        self.checkJwtIsExpired(from: "PaymentVC") { isNotExpired in
            if isNotExpired {
                self.performSegue(withIdentifier: "AddFund", sender: nil)
            }else{
                self.logedOut()
            }
        }
       
       // someView.round(corners: [.topLeft, .topRight], radius: 5)
    }
    
    
    
    @IBAction func btnTransactionH(_ sender:UIButton){
        self.checkJwtIsExpired(from: "PaymentVC") { isNotExpired in
            if isNotExpired {
                self.getTransaction()
            }else{
                self.logedOut()
            }
        }
    }
    
    @IBAction func btnRefresh(_ sender:UIButton){
        self.checkJwtIsExpired(from: "PaymentVC") { isNotExpired in
            if isNotExpired {
                self.profileRequest(from:"self")
            }else{
                self.logedOut()
            }
        }
       
    }
    
    func showAlertWithText(){
        alert = UIAlertController(title: Theme.appName, message: "", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter amount"
            textField.keyboardType = .numberPad
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                if textField.text?.count ?? 0 > 0{
                    self.addedAmount = Int(textField.text ?? "0")!
                }
                if self.addedAmount >= 1 {
                    if Theme.appName == "EV Plugin Charge" {
                        self.addFundUsingPaytm()
                    }else{
                    self.addFund()
                    }
                }else{
                    self.view.makeToast("Amount must be equal or grater than ruppess 1.")
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                                                (action : UIAlertAction!) -> Void in })
            self.alert.addAction(saveAction)
            self.alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
    func validateRazorpayBody() -> ValidationResult {
        if (self.paymentData["order_id"] as! String).count < 0{
            return ValidationResult(success: false, errorMessage: "OrderId is not added")
        }else if (self.paymentData["currency"] as! String).count < 0 {
            return ValidationResult(success: false, errorMessage: "Currency is not added")
        }else{
            return ValidationResult(success: true, errorMessage: nil)
        }
    }
    internal func showPaymentForm(){
        let validate = validateRazorpayBody()
        if validate.success {
            self.razorpay.open(self.paymentData, displayController: self)
        }else{
            self.displayAlert(alertMessage: validate.errorMessage!)
        }
    }
    
    func addFundUsingPaytm(){
        if let userLogin =  Defaults.shared.userLogin,let userName = userLogin.username{
            let userInfoReq:UserInfo = UserInfo(userID: userName)
           // let requestPost:PaytmLoad = PaytmLoad(amount: String(self.addedAmount), type: "stag", userInfo: userInfoReq)
            let requestPost:PaytmLoad = PaytmLoad(amount: String(self.addedAmount), type: "prod", userInfo: userInfoReq)
            ApiPostRequest().kindOf(Theme.AddFundPaytm, requestFor: .MAKE_PAYMENT, request: requestPost, response: AddFund.self) { [weak self] (response) in
                if let res = response,let msg = res.message,let succ = res.success,succ == true{
                    if let result = res.result,let amount = result.amount,let orderId = result.pgOrderID{
                        self?.addFundDetails = result
                        self?.hitInitiateTransactionAPI(.staging, details: result, token: msg,userName:userName)
                       
                       // let merchantId = "UklUtQ11666271101062"
//                        let env = EnablePaymentMode(mode: "UPI", channelse: ["UPIPUSH"])
//                       let url = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=\(orderId)"
//
//                       DispatchQueue.main.async {
//
//                        self.appInvoke.callProcessTransactionAPI(selectedPayModel: AINativeInhouseParameterModel.init(withTransactionToken: msg, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: .none, paymentModes: .wallet, redirectionUrl: "https://securegw.paytm.in/theia/paytmCallback"), delegate: self)
//                    }
                    }
                }
            }
        }
    }
    func addFund(){
//        let myNormalAttributedTitle = NSAttributedString(string: "Done",
//                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
//        self.btnCancel.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        let req = ApiPostRequest()
        let requestPost:AddFundRequest = AddFundRequest(amount: self.addedAmount * 100, paymentId: "12345")
        //self.showLoader()
        req.kindOf(Theme.AddFund, requestFor: .MAKE_PAYMENT,request: requestPost, response: AddFund.self) {[weak self] (response) in
            //  self.hideLoader()
            if let res = response,let msg = res.message,let _ = res.success,msg == "Ok"{
                if let result = res.result,let amt = result.amount,let orderId = result.pgOrderID{
                    self?.addFundDetails = result
                    self?.paymentData["amount"] = amt * 100
                    self?.paymentData["order_id"] = orderId
                    self?.paymentData["currency"] = "INR"
                    
                    if let login = Defaults.shared.userLogin,let username =
                        login.username,let email = login.userEmail{
                        self?.paymentData["prefill"] = ["contact":username,"email":email]
                    }
                    self?.paymentData["image"] = Theme.RazorImage
                    self?.paymentData["theme"] = ["color": Theme.RazorPayColor]
                    DispatchQueue.main.async {
                        self?.showPaymentForm()
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.displayAlert(alertMessage:msg)
                    }
                }
            }
        }
    }
    func profileRequest(from:String){
        let profileResource = ApiGetRequest()
        profileResource.kindOf(Theme.ShowProfile, requestFor: .PROFILE, queryString: [username], response: Profile.self) {[weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ =  res.success,let msg =  res.message, msg == "Ok" {
                if let profile = res.result{
                    Defaults.shared.usrProfile = profile
                    Utils.saveProfileInfoInUserDefaults(data: profile)
                    DispatchQueue.main.async {
                        if let usrProfile = Defaults.shared.usrProfile,let balanceamount = usrProfile.balanceamount {
                            self?.userBalance = balanceamount
                            self?.lblUserBalance.text = "Account Balance: " + Theme.INRSign + String(format:"%.02f",balanceamount)
                            
                            if from == "api" && self?.usingFrom == "Booking"  {
//                                let myNormalAttributedTitle = NSAttributedString(string: "Done Payment",
//                                                                                 attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
//                                self?.btnCancel.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                                self?.donePayment(true,balanceamount,"",self!)
                               
                            }else if from == "api" && self?.usingFrom == ""{
                                self?.displayAlert(alertMessage: "Payment Successfull")
                            }else if from == "self" && self?.usingFrom == "Booking"  {
                                self?.donePayment(true,balanceamount,"refresh",self!)
                            }
                        }else{
                            self?.lblUserBalance.text = "Account Balance: " + Theme.INRSign + "0.00"
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    if from == "api" {
                        self?.displayAlert(alertMessage: "Payment Successfull")
                    }else{
                        self?.displayAlert(alertMessage: "Unable to update user balance")
                    }
                }
            }
        }
    }
    
    
    func logedOut(){
        let value = self.logedIn.updateLogedInUser(value: false)
        if value == true{
            print("User loged out successfully!!!")
        }
        self.removAllData { done in
            if done {
                self.logOut()
            }
        }
    }
    func getTransaction(){
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.Transaction, requestFor: .PAYMENT_DETAILS, queryString: [nil], response: PaymentDetails.self) { [weak self] respons in
            self?.hideLoader()
            if let res = respons,let success = res.success,let msg = res.message {
                  if success == true && msg == "Ok" {
                      if let results =  res.result , results.count > 0{
                          DispatchQueue.main.async {
                             // self?.donePayment(false,0.0,"Logout",self!)
                          self?.performSegue(withIdentifier: "Transaction", sender: results)
                          }
                      }else{
                          DispatchQueue.main.async {
                          self?.displayAlert(alertMessage: "Unable to found any transaction.")
                          }
                      }
                  }else{
                      DispatchQueue.main.async {
                          if msg == "No user found"{
//                              if self?.usingFrom == "Booking" {
//                                  self?.donePayment(false,0.0,"Logout",self!)
//                              }else{
//                                  self?.logedOut()
//                              }
                              self?.logedOut()
//                          self?.displayAlert(alertMessage:"Error while getting transaction history")
//                          }else{
//                              self?.displayAlert(alertMessage:msg)
                          }
                      }
                  }
            }
        }
    }
    func savePaytm(data:SavePatmRespo,payTmOrderId:String){
        ApiPostRequest().kindOf(Theme.SavePayments, requestFor: .SAVE_PAYMENT, request: data, response: SavePayments.self) {[weak self] respons in
           
            if let res = respons,let succes = res.success , let _ = res.message{
                if let result = res.result,let orderId = result.pgOrderID,payTmOrderId == orderId && succes == true{
                    self?.profileRequest(from:"api")
                }else if let result = res.result,let orderId = result.pgOrderID, succes == true && orderId.count == 0{
                    self?.hideLoader()
                    DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Payment Failed")
                    }
                }else{
                    self?.hideLoader()
                    DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Payment Failed")
                    }
                }
            }else{
                self?.hideLoader()
                DispatchQueue.main.async {
                self?.displayAlert(alertMessage: "Payment Failed")
                }
            }
        }
    }
    func savePayments(_ razorPayReturns:(String?,String?,String)){
        let request:SavePaymentRequest
        if let transactionId = self.addFundDetails.transactionID,let amount = self.paymentData["amount"] as? Int,let pgPaymentId = razorPayReturns.0,let signature = razorPayReturns.1 {
                request = SavePaymentRequest(transactionId: transactionId,amount:amount,pgPaymentId: pgPaymentId,pgSIgnature:signature,status:razorPayReturns.2,type: "RZRWeb")
           
            let requestType = ApiPostRequest()
            self.showLoader()
            requestType.kindOf(Theme.SavePayments, requestFor: .SAVE_PAYMENT, request: request, response: SavePayments.self) {[weak self] respons in
               
                if let res = respons,let succes = res.success , let _ = res.message{
                    if let pId = razorPayReturns.0,let result = res.result,let PayId = result.pgPaymentID,PayId == pId && succes == true{
                        self?.profileRequest(from:"api")
                    }else if let result = res.result,let PayId = result.pgPaymentID, succes == true && PayId.count == 0{
                        self?.hideLoader()
                        DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "Payment Failed")
                        }
                    }else{
                        self?.hideLoader()
                        DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "Payment Failed")
                        }
                    }
                }else{
                    self?.hideLoader()
                    DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Payment Failed")
                    }
                }
             }
            }else{
                self.displayAlert(alertMessage: "Payment Failed")
            }
    }
}
extension PaymentVC : RazorpayPaymentCompletionProtocolWithData{
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
       // print("error: ", code)
       // print("Response is: ", (String(describing: response)))
        
        if let paymentId = response?["razorpay_payment_id"] as? String,let rezorSignature = response?["razorpay_signature"] as? String{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.savePayments((paymentId,rezorSignature,"F"))
            }
        }else{
            self.displayAlert(alertMessage: "Payment failed")
        }
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
       // print("success: ", payment_id)
          
           // print("Response is: ", (String(describing: response)))
            
          // let paymentId = response?["razorpay_payment_id"] as! String
          // let rezorSignature = response?["razorpay_signature"] as! String
          // print("rezorSignature", rezorSignature)
          // print(" paymentId", paymentId)
        if let paymentId = response?["razorpay_payment_id"] as? String,let rezorSignature = response?["razorpay_signature"] as? String{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.savePayments((paymentId,rezorSignature,"P"))
            }
        }else{
            self.displayAlert(alertMessage: "Something went wrong")
        }
    }
}
/*
extension PaymentVC : RazorpayPaymentCompletionProtocol {

    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.savePayments((nil,"F"))
        }
    }

    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        let razorPayReturns = (payment_id,"P")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Put your code which should be executed with a delay here
            self.savePayments(razorPayReturns)
        }
    }
}*/
extension PaymentVC: AIDelegate {
 
    func didFinish(with success: Bool, response: [String : Any], error: String?, withUserCancellation hasUserCancelledTransaction: Bool) {
        
        print("paytm response = \(response)")
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
          //  self.present(alert, animated: true, completion: nil)
        }
        let log = "\(response)"
        //response.converToJson()
        if response["STATUS"] as! String == "TXN_SUCCESS"{
           
            if let pgPayId = response["TXNID"] as? String,let ORDERID = response["ORDERID"] as? String,let transId =  self.addFundDetails.transactionID,let amount = self.addFundDetails.amount  {
                let id = String(transId)
                let data = SavePatmRespo(transactionId: id, pgPaymentId: pgPayId, pgSIgnature: "", status: "P", amount: amount, pgLog: log)
                self.savePaytm(data: data,payTmOrderId:ORDERID)
            }
        }else{
            if let transId =  self.addFundDetails.transactionID{
                let id = String(transId)
                let data = SavePatmRespo(transactionId: id, pgPaymentId:nil, pgSIgnature: nil, status: "F", amount: nil, pgLog: log)
                self.savePaytm(data: data,payTmOrderId:"")
            }

        }
            
       // let alert = UIAlertController(title: success ? "Success" : "Fail", message: String(describing: response), preferredStyle: .alert)
       // alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
          //  self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPaymentController(_ controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
}
extension PaymentVC {
    func hitInitiateTransactionAPI(_ env: AIEnvironment, details: AddFundDetails,token:String,userName:String) {
       // let merchantId = "UklUtQ11666271101062"
        let merchantId = "khosla72281552635980"
        
        let orderId = details.pgOrderID
      //  let env = EnablePaymentMode(mode: "UPI", channelse: ["UPIPUSH"])
    //   let url = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=\(orderId!)"
        let url = "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=\(orderId!)"
    
        //(self.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : self.orderIdTextField.text!
       
        let amount = details.amount
        
        
        
        DispatchQueue.main.async {
            self.appInvoke.openPaytm(selectedPayModel: AINativeInhouseParameterModel.init(withTransactionToken: token, orderId: orderId!, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: .none, paymentModes: .wallet, redirectionUrl: url), merchantId: merchantId, orderId: orderId! , txnToken: token, amount: String(amount!), callbackUrl: url, delegate: self, environment: .production)
           // (withTransactionToken: "", orderId: orderId!, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: .none, paymentModes: .upi, redirectionUrl: url)
        }
    }
}
    
