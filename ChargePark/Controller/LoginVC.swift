//
//  LoginVC.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import UIKit
import SkyFloatingLabelTextField
class LoginVC: UIViewController {

    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnPasswordStatus: UIButton!
    @IBOutlet weak var btnForgerPassword: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwLogo: UIView!
    var logedIn:LogedInManager!
    var isLoginSucces = false
    var userName = ""
    var userNameFromReg:String = ""
    var loader:NewLoader!
    let dispatchQueue = DispatchQueue(label: "myQueue", qos: .utility)
    let semaphore = DispatchSemaphore(value: 0)
    let group:DispatchGroup = DispatchGroup()
    var request:LoginRequest!
    var staus:OnOffSwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.btnLogin.backgroundColor = Theme.menuHeaderColor
        self.btnBack.backgroundColor = Theme.menuHeaderColor
        self.btnLogin.cornerRadius(with: 4.0)
        self.btnBack.cornerRadius(with: 4.0)
        vwLogo.cornerRadius(with: 8.0)
        txtPassword.isSecureTextEntry = true
        staus = OnOffSwitch.on
        txtMobileNumber.delegate = self
        logedIn = LogedInManager()
        if userNameFromReg.count > 0{
            txtMobileNumber.text = userNameFromReg
        }
        if Theme.appName == "VRAJEV Charge"{
            let img = UIImage(systemName: "backward")
            self.btnBack.setImage(img?.tint(with: .white), for: .normal)
        }
        txtMobileNumber.selectedTitleColor = Theme.menuHeaderColor
        txtMobileNumber.selectedLineColor = Theme.menuHeaderColor
        txtPassword.selectedTitleColor = Theme.menuHeaderColor
        txtPassword.selectedLineColor = Theme.menuHeaderColor
        imgLogo.cornerRadius(with: 8.0)
//        txtMobileNumber.text = "9311369543"
//        txtPassword.text = "Pass@123#"
       // txtMobileNumber.text = "7503103938"
        //txtPassword.text = "ss123456"
       /* let rsiz = imgLogo.bounds.width/2
        imgLogo.cornerRadius(with: rsiz)
        imgLogo.layer.borderWidth = 1.0
        imgLogo.layer.borderColor = UIColor.green.cgColor*/
        // Do any additional setup after loading the view.
    }
    func storeLogrdInUser(){
        let rememberUser = RememberUser(context: Prersistance.shared.context)
        rememberUser.logedIn = true
        Prersistance.shared.saveContext()
    }
        
    func moveToNext(){
        userNameFromReg = ""
        //storeLogrdInUser()
        if logedIn.deleteLogedIn() == true{
            print("delete successflly")
        }
        logedIn.createLogedInUser()
      //  self.hideLoader()
        
        DispatchQueue.main.async {
        let homwSy = UIStoryboard(name: "Home", bundle: nil)
        let front = homwSy.instantiateViewController(withIdentifier: "StationNavigation") as? UINavigationController
           // txtMobileNumber
        let rear = homwSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
           // ?.viewControllers.first as? StationViewController
            if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
        self.navigationController?.pushViewController(swRevealVC, animated: true)
        }
      }
    }
    func goToStartCharging(result:ResultChargerBooking){
        if logedIn.deleteLogedIn() == true{
            print("delete successflly")
        }
        logedIn.createLogedInUser()
        userNameFromReg = ""
        let homeSy = UIStoryboard(name: "Home", bundle: nil)
        let bookSy = UIStoryboard(name: "Book", bundle: nil)
        if let front = bookSy.instantiateViewController(withIdentifier: "StrartChargingVC") as? StrartChargingVC{
            front.bookingType = .Active
            Defaults.shared.bookingType = .Active
            front.bookingResult = result
            let rear = homeSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
            // ?.viewControllers.first as? StationViewController
            if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
                self.navigationController?.pushViewController(swRevealVC, animated: true)
            }
        }
    }
 
       
    
    
    func loginRequest(){
      //  self.group.enter()
        let validation = LoginValidation()
        let validationResult = validation.validate(request: request)
        if validationResult.success {
            let apiRequest = ApiPostRequest()
            self.showLoader()
            apiRequest.kindOf(Theme.LoginConnector, requestFor: .LOGIN,request: request, response: LoginResponse.self) { [weak self] (response) in
               // self?.hideLoader()
                    if let res = response,let loginResult = res.result, let _ = res.success,let msg =  res.message{
                   // print("msg = \(msg)")
                    if msg == "INVALIDUSER Check User Name and/or Password" {
                        self?.hideLoader()
                        DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: msg)
                       // self?.group.leave()
                        }
                    }else if let _ =  res.success,msg == "Ok" {
                       // print("login get successfully")
                        self?.isLoginSucces = true
                        if let loginResult = res.result,let token = loginResult.token {
                        Defaults.shared.userLogin = loginResult
                        Defaults.shared.token = "JWT-" + token
                        Utils.saveLoginInfoInUserDefaults(data: loginResult)
                       
                        }
                        self?.userName = loginResult.username ?? ""
                      
                        self?.profileRequest()
                        print("Login get successfully")
                       // self?.group.leave()
                    }else if msg == "AUTHFAILED"{
                        self?.hideLoader()
                        DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "Mobile number or passwrd is wrong")
                          //  self?.group.leave()
                        }
                    }
                    } else  if let res = response,let _ = res.success,let msg =  res.message,msg == "AUTHFAILED"{
                        self?.hideLoader()
                        DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "Mobile number or passwrd is wrong")
                          //  self?.group.leave()
                        }
                    }else{
                        self?.hideLoader()
                        DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "Mobile number or passwrd is wrong")
                           // self?.group.leave()
//                            self?.semaphore.signal()
//                            return
                        }
                    }
                 }
               }else{
            DispatchQueue.main.async {
                self.displayAlert(alertMessage:validationResult.errorMessage!)
               // self.group.leave()
               // self.semaphore.signal()
              //  return
            }
        }
    }
    func profileRequest(){
       // self.group.enter()
        let profileResource = ApiGetRequest()
        profileResource.kindOf(Theme.ShowProfile, requestFor: .PROFILE, queryString: [userName], response: Profile.self) {[weak self] respons in
            if let res = respons,let _ =  res.success,let msg =  res.message, msg == "Ok" {
                if let profile = res.result{
                    print("profile get successfully")
                    Defaults.shared.usrProfile = profile
                    Utils.saveProfileInfoInUserDefaults(data: profile)
                   // self?.group.leave()
                    self?.addUserVehicles()
                }
            }else{
                self?.hideLoader()
               // self?.group.leave()
            }
        }
    }
   
    func addUserVehicles() {
       // self.group.enter()
        let resource = ApiGetRequest()
        resource.kindOf(Theme.VehicleList, requestFor: .VEHICLE_LIST, queryString: [userName], response: AddedVehicle.self) {[weak self] respons in
            //self?.hideLoader()
            if let res = respons,let result = res.result,let msg = res.message,msg == "Ok"{
                Defaults.shared.addedVehicle.result = result
                Utils.saveUserEvsInfoInUserDefaults(data: res)
                print("Vehicles get successfully")
               // self?.group.leave()
               // self?.semaphore.wait()
               
                if Theme.appName == "EV Plugin Charge" {
                    self?.checkForActiveBooking()
                }else{
                    self?.configRequest()
                }
               // if let useName = Defaults.shared.userLogin?.username,useName.count > 0{
                   // self?.moveToNext()
                   
               // }
            }else{
                self?.hideLoader()
               // self?.group.leave()
            }
        }
    }
    func configRequest(){
        //self.group.enter()
        let configReq = ApiGetRequest()
        configReq.kindOf(Theme.AppConfig, requestFor: .APP_CONFIG, queryString: [nil], response: AppConfig.self) {[weak self] respons in
            if let res = respons,let _ =  res.success,let msg =  res.message, msg == "Ok" {
                if let config = res.result{
                Defaults.shared.appConfig = config
                Utils.saveAppInfoInUserDefaults(data: config)
                    print("Config get successfully")
                    self?.checkForActiveBooking()
               // self?.group.leave()
                   // self?.semaphore.wait()
                }
            }else{
                self?.hideLoader()
               // self?.group.leave()
            }
        }
       
    }
    func checkForActiveBooking(){
        Defaults.shared.userType = .logedIn
       // self.group.enter()
        let req = ApiGetRequest()
        req.kindOf(Theme.ActiveBooking, requestFor: .ACTIVE_BOOKING, queryString: [self.userName], response: ChargerBookingResponse.self) { [weak self] respons in
                self?.hideLoader()
            if let res = respons,let success = res.success,let msg = res.message,success == true,msg == Theme.Message{
                if let result = res.result{
                    print("ActiveBooking get successfully")
                   // self?.group.leave()
                   // self?.semaphore.wait()
                    DispatchQueue.main.async {
                        self?.goToStartCharging(result:result)
                    }
                }else{
                    DispatchQueue.main.async {
                       // self?.group.leave()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    print("Don't have activeBooking")
                   // self?.group.leave()
                   // self?.semaphore.wait()
                    if let useName = Defaults.shared.userLogin?.username,useName.count > 0{
                        self?.moveToNext()
                    }
                }
            }
          }
    }
    
    @IBAction func btnLogin_Action(_ sender: UIButton) {
       
        self.request = LoginRequest(username: txtMobileNumber.text!, password: txtPassword.text!)
       /*
        let operationLogin = BlockOperation()
        operationLogin.addExecutionBlock {
            self.loginRequest()
            self.group.wait()
        }
       
        let operationProfile = BlockOperation()
        operationProfile.addExecutionBlock {
            self.profileRequest()
            self.group.wait()
        }
        
        let operationVehicle = BlockOperation()
        operationVehicle.addExecutionBlock {
            self.addUserVehicles()
            self.group.wait()
        }
        let operationConfig = BlockOperation()
        operationConfig.addExecutionBlock {
            self.configRequest()
            self.group.wait()
        }
       
        let operationActive = BlockOperation()
        operationActive.addExecutionBlock {
            self.checkForActiveBooking()
            
        }
        operationProfile.addDependency(operationLogin)
        operationConfig.addDependency(operationVehicle)
       // operationVehicle.addDependency(operationLogin)
        operationActive.addDependency(operationLogin)
        
        
        let oq = OperationQueue()
        oq.addOperation(operationLogin)
        oq.addOperation(operationProfile)
        oq.addOperation(operationVehicle)
        oq.addOperation(operationConfig)
        oq.addOperation(operationActive)
        */
       self.loginRequest()
       
//        dispatchQueue.async {
//            for number in 1...4{
//            switch number {
//            case 0:
//                self.loginRequest()
//            case 1:
//                self.profileRequest()
//            case 2:
//                self.addUserVehicles()
//            case 3:
//                self.configRequest()
//            case 4:
//                self.checkForActiveBooking()
//            default:
//                print("none")
//            }
//                self.semaphore.wait()
//            }
//        }
        
//        operationActive.addDependency(operationVehicle)
//        operationVehicle.addDependency(operationConfig)
//        operationConfig.addDependency(operationProfile)
//        operationProfile.addDependency(operationLogin)
        
        
       
       
        
//        operationProfile.addDependency(operationLogin)
//        operationConfig.addDependency(operationLogin)
//        operationVehicle.addDependency(operationLogin)
//        operationActive.addDependency(operationLogin)
        
       
        
//        operationProfile.addDependency(operationLogin)
//        operationConfig.addDependency(operationProfile)
//        operationVehicle.addDependency(operationConfig)
//        operationActive.addDependency(operationVehicle)
        
      
       
    }
    
    
    @IBAction func btnPasswordStatus_Action(_ sender: UIButton) {
        if staus == .on {
            txtPassword.isSecureTextEntry = false
            btnPasswordStatus.setImage(#imageLiteral(resourceName: "Show"), for: .normal)
        }else{
            txtPassword.isSecureTextEntry = true
            btnPasswordStatus.setImage(#imageLiteral(resourceName: "Hide"), for: .normal)
        }
        staus.toggle()
    }
    @IBAction func btnForgetPassword_Action(_ sender: UIButton) {
        if let userName = self.txtMobileNumber.text{
            if userName.count == 10 {
            self.performSegue(withIdentifier: "ForgetVC", sender: nil)
            }else if userName.count < 10 || userName.count > 10 {
                self.displayAlert(alertMessage: "Please Enter valid mobile number")
            }else if userName.count == 0 {
                self.displayAlert(alertMessage: "mobile number can not be empty")
            }
        }
       
    }
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        print("\(self) id deinitialized")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! ForgetVC
        if let useName = self.txtMobileNumber.text {
            vc.userName = useName
        }else{
            self.displayAlert(alertMessage: "Please fill User Id")
        }
    }
}
extension LoginVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        switch textField {
        case txtMobileNumber:
            guard let preText = textField.text as NSString?,
                  preText.replacingCharacters(in: range, with: string).count <= Theme.MAX_TEXT_LENGTH else {
                return false
            }
        default:
            return true
        }
            return true
        }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
}
