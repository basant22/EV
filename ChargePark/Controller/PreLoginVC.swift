//
//  PreLoginVC.swift
//  ChargePark
//
//  Created by apple on 23/06/1943 Saka.
//

import UIKit

class PreLoginVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
//    @IBOutlet weak var viewUpper:UIView!
//    @IBOutlet weak var activityInd:UIActivityIndicatorView!
   private let group = DispatchGroup()
    var logedIn:LogedInManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNibs(nibNames: ["UpperImageCell","LabelCell","TwoButtonCell","ButtonCell"])
        // Do any additional setup after loading the view.
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            self.navigationController!.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true
        tableView.rowHeight = 250
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        self.logedIn = LogedInManager()
    }
   /* func isUserAlreadyLogedIn() -> Bool{
        
       // let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       // debugPrint(path[0])
        var rmc = false
        do {
            guard let result = try Prersistance.shared.context.fetch(RememberUser.fetchRequest()) as? [RememberUser] else {return false}
            if let remUsr = result.first{
                rmc = remUsr.logedIn
            }
            return rmc
           // result.forEach({debugPrint($0.logedIn)})
        } catch let error {
            debugPrint(error)
        }
        return rmc
    }*/
    override func viewWillAppear(_ animated: Bool) {
            self.tableView.layoutSubviews()
       
//            viewUpper.isUserInteractionEnabled = false
//            viewUpper.backgroundColor = UIColor.clear
            if logedIn.isUserLogedIn() == true{
                self.showLoader()
      //  if let login = Defaults.shared.userLogin,let name = login.username,!name.isEmpty {
//                activityInd.isHidden = false
//                viewUpper.isHidden = false
//
//                activityInd.startAnimating()
//                viewUpper.isUserInteractionEnabled = true
//                viewUpper.backgroundColor = .black.withAlphaComponent(0.770) //Theme.menuHeaderColor.withAlphaComponent(0.770)
                
                let operationLogin = BlockOperation()
                operationLogin.addExecutionBlock {
                    self.group.enter()
                    Utils.getLoginFromUserDefaults()
                    self.group.leave()
                }
                let operationProfile = BlockOperation()
                operationProfile.addExecutionBlock {
                    self.group.enter()
                    Utils.getProfileFromUserDefaults()
                    self.group.leave()
                }
                let operationVehicle = BlockOperation()
                operationVehicle.addExecutionBlock {
                    self.group.enter()
                    Utils.getUserEvsFromUserDefaults()
                    self.group.leave()
                }
                let operationAppInfo = BlockOperation()
                operationAppInfo.addExecutionBlock {
                    self.group.enter()
                    Utils.getAppFromUserDefaults()
                    self.group.leave()
                }
                let operQ = OperationQueue()
                operQ.addOperation(operationLogin)
                operQ.addOperation(operationProfile)
                operQ.addOperation(operationVehicle)
                operQ.addOperation(operationAppInfo)
            }else{
                self.hideLoader()
                //activityInd.tintColor = .white
               // self.navigationController?.isNavigationBarHidden = true
//                activityInd.stopAnimating()
//                activityInd.isHidden = true
//                viewUpper.isHidden = true
               // viewUpper.isUserInteractionEnabled = false
               // viewUpper.backgroundColor = UIColor.clear
            }
    }
    override func viewDidAppear(_ animated: Bool) {
        if logedIn.isUserLogedIn() == true{
            if let username =  Defaults.shared.userLogin?.username{
                print("USER_NAME = \(username)")
                self.checkJwtIsExpired(from: "PreLogin") { isValidJwt in
                    if isValidJwt{
                        self.moveToNext(userName: username)
                    }else{
                        //self.moveToNext(userName: username)
                        
                        let value = self.logedIn.updateLogedInUser(value: false)
                        if value == true{
                            print("User loged out successfully!!!")
                        }
                        self.removAllData { [weak self] (done) in
                            self?.hideLoader(completion: {
                                self?.performSegue(withIdentifier: "Login", sender: nil)
                            })
                        }
                    }
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    func moveToNext(userName:String){
        //"9736463697"
        let req = ApiGetRequest()
        req.kindOf(Theme.ActiveBooking, requestFor: .ACTIVE_BOOKING, queryString: [userName], response: ChargerBookingResponse.self) { [weak self] respons in
                self?.hideLoader()
            if let res = respons,let success = res.success,let msg = res.message,success == true,msg == Theme.Message{
                if let result = res.result{
                    DispatchQueue.main.async {
                        self?.goToStartCharging(result:result)
                    //self?.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.goToMapView()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self?.goToMapView()
                }
            }
          }
        }
    func goToStartCharging(result:ResultChargerBooking){
        let homeSy = UIStoryboard(name: "Home", bundle: nil)
        let bookSy = UIStoryboard(name: "Book", bundle: nil)
       // if let vc = bookSy.instantiateViewController(withIdentifier: "StrartChargingVC") as? StrartChargingVC{
           
            
       if let front = bookSy.instantiateViewController(withIdentifier: "StrartChargingVC") as? StrartChargingVC{
            front.bookingType = .Active
           Defaults.shared.bookingType = .Active
           Defaults.shared.userType = .logedIn
            front.bookingResult = result
            // txtMobileNumber
            let rear = homeSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
            // ?.viewControllers.first as? StationViewController
            if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
                self.navigationController?.pushViewController(swRevealVC, animated: true)
            }
           }
         }
    func goToMapView(){
        let homwSy = UIStoryboard(name: "Home", bundle: nil)
       // let front = homwSy.instantiateViewController(withIdentifier: "StationNavigation") as? UINavigationController
        let front = homwSy.instantiateViewController(withIdentifier: "StationViewController") as? StationViewController
        Defaults.shared.userType = .logedIn
        // txtMobileNumber
        let rear = homwSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
      
        // ?.viewControllers.first as? StationViewController
        if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
            self.navigationController?.pushViewController(swRevealVC, animated: true)
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
    deinit {
        print("\(self) id deinitialized")
    }
}
extension PreLoginVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UpperImageCell", for: indexPath) as! UpperImageCell
//            if indexPath.row == 0 {
//               // cell.bigImage.image = #imageLiteral(resourceName: "Banner")
//                cell.smallImage.isHidden = true
//            }
//            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpperImageCell", for: indexPath) as! UpperImageCell
               cell.smallImage.isHidden = false
           /* let rsiz = cell.smallImage.bounds.width/2
            cell.smallImage.cornerRadius(with: rsiz)
            cell.smallImage.layer.borderWidth = 1.0
            cell.smallImage.layer.borderColor = UIColor.green.cgColor*/
                 cell.bigImage.isHidden = true
                 cell.smallImage.image = #imageLiteral(resourceName: "LoginHeaderImage")
                 cell.selectionStyle = .none
                 return cell
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            if indexPath.row == 1 {
                
                cell.lbl?.text = "Welcome to \(Theme.appName)"
                cell.lbl?.textColor = Theme.menuHeaderColor
                cell.lbl?.font = UIFont(name: "HelveticaNeue", size: 22.0)
            }else{
                cell.lbl?.text = Theme.PunchLine
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoButtonCell", for: indexPath) as! TwoButtonCell
            cell.btnLogin.backgroundColor = Theme.menuHeaderColor
            cell.btnGuest.backgroundColor = Theme.newGreen
            cell.getAction = { tag in
                switch tag {
                case 1:
                    self.performSegue(withIdentifier: "Login", sender: nil)
                case 2:
                    let homwSy = UIStoryboard(name: "Home", bundle: nil)
                   // let front = homwSy.instantiateViewController(withIdentifier: "StationNavigation") as? UINavigationController
                    let front = homwSy.instantiateViewController(withIdentifier: "StationViewController") as? StationViewController
                    Defaults.shared.userType = .guest
                    let rear = homwSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
                   
                       // ?.viewControllers.first as? StationViewController
                    if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
                    self.navigationController?.pushViewController(swRevealVC, animated: true)
                 }
                default:
                    print("")
                }
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.btnCell.setAttributedTitle(AttrubutedString.creatAttributedStringOfSize( 18.0,"New to \(Theme.appName)?", "Register Here"), for: .normal)
            cell.getButtonAction = {[weak self] (done) in
                self?.performSegue(withIdentifier: "Registration", sender: nil)
            }
            return cell
        default:
            print("")
        }
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0,1:
//            if indexPath.row == 0 {
//                return 200
//            }
//            return 150
//        case 2,3:
//            if indexPath.row == 2 {
//                return 50
//            }
//            return 150
//        case 4:
//                return 50
//        case 5:
//            return 100
//        default:
//            print("")
//        }
//        return 0
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            if indexPath.row == 1{
//                return 120
//            }else
            if indexPath.row == 3{
                return 70
            }
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.layoutIfNeeded()
        }
//    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
