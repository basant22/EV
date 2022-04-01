//
//  ViewController.swift
//  Radiush
//
//  Created by apple on 03/01/20.
//  Copyright © 2020 Kreative. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var tableView:UITableView!
    @IBOutlet var viewBottom:UIView!
    @IBOutlet var lblAppVersion:UILabel!
    var userType:UserType = .logedIn
    var logedIn:LogedInManager!
    //(#imageLiteral(resourceName: "Favorite"),"Favourite Stations","Favourite Stations")
     var menus = [(#imageLiteral(resourceName: "EV Chargeer"),"EV Chargers","EV Chargers"),(#imageLiteral(resourceName: "My Vehicle"),"My Vehicle","My Vehicle"),(#imageLiteral(resourceName: "ChargingSession"),"My Bookings","My Bookings"),(#imageLiteral(resourceName: "Wallet"),"My Wallet","My Wallet"),(#imageLiteral(resourceName: "MyProfile"),"My Profile","My Profile"),(#imageLiteral(resourceName: "Help"),"Help","Help"),(#imageLiteral(resourceName: "Logout"),"Logout","Logout")]
   // (#imageLiteral(resourceName: "Favorite"),"Favourite Stations","Favourite Stations")
    var menusVraj = [(#imageLiteral(resourceName: "EV Chargeer"),"Stations","EV Chargers"),(#imageLiteral(resourceName: "My Vehicle"),"Vehicle Info","My Vehicle"),(#imageLiteral(resourceName: "ChargingSession"),"Booking Info","My Bookings"),(#imageLiteral(resourceName: "Wallet"),"My Pocket","My Wallet"),(#imageLiteral(resourceName: "MyProfile"),"My Info","My Profile"),(#imageLiteral(resourceName: "Help"),"Contact","Help"),(#imageLiteral(resourceName: "Logout"),"Exit","Logout")]
    var menusGoGedi = [(#imageLiteral(resourceName: "EV Chargeer"),"Stations","EV Chargers"),(#imageLiteral(resourceName: "Favorite"),"Favourite Stations","Favourite Stations"),(#imageLiteral(resourceName: "My Vehicle"),"Vehicle Info","My Vehicle"),(#imageLiteral(resourceName: "ChargingSession"),"My Bookings","My Bookings"),(#imageLiteral(resourceName: "Wallet"),"My Wallet","My Wallet"),(#imageLiteral(resourceName: "MyProfile"),"My Profile","My Profile"),(#imageLiteral(resourceName: "Help"),"Contact Us","Help"),(#imageLiteral(resourceName: "Logout"),"Exit","Logout")]
    var menusEVP = [(#imageLiteral(resourceName: "EV Chargeer"),"Stations","EV Chargers"),(#imageLiteral(resourceName: "My Vehicle"),"My Vehicles","My Vehicle"),(#imageLiteral(resourceName: "ChargingSession"),"My Bookings","My Bookings"),(#imageLiteral(resourceName: "Wallet"),"My Wallet","My Wallet"),(#imageLiteral(resourceName: "MyProfile"),"My Profile","My Profile"),(#imageLiteral(resourceName: "Rfid"),"RFID Card","Rfid"),(#imageLiteral(resourceName: "Help"),"Help","Help"),(#imageLiteral(resourceName: "Logout"),"Exit","Logout")]
    var menusE = [(#imageLiteral(resourceName: "EV Chargeer"),"Power Source ","EV Chargers"),(#imageLiteral(resourceName: "My Vehicle"),"Vehicle Brand","My Vehicle"),(#imageLiteral(resourceName: "ChargingSession"),"Bookings","My Bookings"),(#imageLiteral(resourceName: "Wallet"),"My Purse","My Wallet"),(#imageLiteral(resourceName: "MyProfile"),"My Info","My Profile"),(#imageLiteral(resourceName: "Rfid"),"RFID Card","Rfid"),(#imageLiteral(resourceName: "Help"),"Support","Help"),(#imageLiteral(resourceName: "Logout"),"Exit Here","Logout")]
   // (#imageLiteral(resourceName: "Rfid"),"My RFID","Rfid")
    //(#imageLiteral(resourceName: "Rfid"),"My RFID","Rfid")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Theme.appName == "VRAJEV Charge"{
            self.menus = self.menusVraj
        }else if Theme.appName == "GoGedi"{
            self.menus = self.menusGoGedi
        }else if Theme.appName == "EV Plugin Charge"{
            self.menus = self.menusE
        }else if Theme.appName == "StartEVCharge"{
            self.menus = self.menusEVP
        }
         tableView.registerNibs(nibNames:["MenuCell","HeadingCell"])
        self.tableView.separatorColor = .clear
        if let  appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            lblAppVersion.textColor = .white
            lblAppVersion.text = Theme.appName + " " + appVersion
        }
       
        self.view.setGradientBackground(colorTop: Theme.menuHeaderColor, colorBottom: Theme.gradientGreen)
        logedIn = LogedInManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("MenuViewController")
    }
    deinit {
        print("\(self) id deinitialized")
    }
    func removeTimerAndVCIn(){
        if let vc = self.revealViewController().frontViewController as? StrartChargingVC{
            vc.stopStatusTimer(completion: nil)
            vc.stopDurationTimer(completion: nil)
            self.revealViewController().frontViewController = nil
        }
    }
    func removeTimerAndVC(){
        if let vc = self.revealViewController().frontViewController as? StrartChargingVC{
            vc.stopStatusTimer(completion: nil)
            vc.stopDurationTimer(completion: nil)
            self.revealViewController().frontViewController = nil
        }else{
//            UIView.animate(withDuration: 0.3) {
//                self.revealViewController().frontViewController = nil
//            }
            UIView.animate(withDuration: 0.8, delay: 0.0, options: .transitionCrossDissolve) {
                self.revealViewController().frontViewController = nil
            }

        }
    }
    func logingOut(){
        Defaults.shared.userLogin = nil
        Defaults.shared.usrProfile = nil
        Defaults.shared.addedVehicle = AddedVehicle()
        //AddedVehicle(result: nil, message: "", success: nil)
        Defaults.shared.appConfig = nil
        Defaults.shared.token = ""
        Defaults.shared.userType = nil
        Defaults.shared.favoriteStation = []
        Defaults.shared.bookingType = .General
       let value = logedIn.updateLogedInUser(value: false)
        if value == true{
            print("User loged out successfully!!!")
        }
        print("before", UserDefaults.standard.bool(forKey: UserDefaults.Keys.Login_Info.rawValue))
        // Reset User Defaults
        UserDefaults.standard.reset()
        print("after", UserDefaults.standard.bool(forKey: UserDefaults.Keys.Login_Info.rawValue))
        self.logOut()
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
    }
 }

extension MenuViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return menus.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        default:
            return 60
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingCell", for: indexPath) as! HeadingCell
            cell.selectionStyle = .none
            cell.setData()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.lblTitle.textColor = .white
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
        let cell = cell as! HeadingCell
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.imgLogo.image = #imageLiteral(resourceName: "ProfileMenu").tint(with: .white)
            if let useName = Defaults.shared.userLogin?.name,useName.count > 0{
            cell.lblName.text = useName
            }else{
                cell.lblName.text  = "Guest User"
            }
        default:
        let cell = cell as! MenuCell
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
        cell.lblTitle.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        cell.lblTitle.text = menus[indexPath.row].1
        let img:UIImage = menus[indexPath.row].0
            cell.imgMenu.image = img.tint(with: .white)
        }
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            removeTimerAndVC()
            self.performSegue(withIdentifier: "My Profile", sender: nil)
        case 1:
        switch menus[indexPath.row].2 {
        case "EV Chargers":
            self.checkJwtIsExpired(from: "MenuVC") { isNotExpired in
                if isNotExpired {
                    if let aciveBooking = Defaults.shared.bookingType,aciveBooking == .Active{
                        self.displayAlert(alertMessage: "You have already an active booking!")
                    }else{
                        self.removeTimerAndVC()
                        self.performSegue(withIdentifier: self.menus[indexPath.row].2, sender: nil)
                    }
                }else{
                    self.logingOut()
                }
            }
            
        case "Favourite Stations":
            removeTimerAndVC()
            if let aciveBooking = Defaults.shared.bookingType,aciveBooking == .Active{
                self.displayAlert(alertMessage: "You have already an active booking!")
            }else{
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
            }
        case "My Vehicle":
            removeTimerAndVC()
            if let useName = Defaults.shared.userType,useName == .guest{
                self.performSegue(withIdentifier: "Registration", sender: nil)
            }else{
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
            }
        case "My Bookings":
           // if userType == .guest{
            removeTimerAndVC()
            if let useName = Defaults.shared.userType,useName == .guest{
                self.performSegue(withIdentifier: "Registration", sender: nil)
            }else{
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
            }
        case "My Wallet":
            removeTimerAndVC()
           // if userType == .guest{
            if let useName = Defaults.shared.userType,useName == .guest {
                self.performSegue(withIdentifier: "Registration", sender: nil)
            }else{
            Defaults.shared.paymentType = .Pre
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
            }
        case "My Profile":
            removeTimerAndVC()
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
        case "Rfid":
            if let vc = self.revealViewController().frontViewController as? StrartChargingVC{
                vc.stopStatusTimer(completion: nil)
                vc.stopDurationTimer(completion: nil)
                self.revealViewController().frontViewController = nil
            }
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
        case "Help":
            removeTimerAndVC()
            self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
        case "Logout":
            removeTimerAndVC()
            self.logingOut()
            // let story = UIStoryboard(name: "Main", bundle: nil)
           
           // self.performSegue(withIdentifier: menus[indexPath.row].2, sender: nil)
           /* if #available(iOS 13.0, *) {
                let loginVC: UIViewController? = story.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let preLoginVC: UIViewController? = story.instantiateViewController(withIdentifier: "PreLoginVC") as! PreLoginVC
               // let navi = UINavigationController(rootViewController: viewControlle!)
                 //  navigationController?.addChild(preLoginVC!)
                    navigationController?.pushViewController(loginVC!, animated: true)
                    
                    
                }
            else {
                // Fallback on earlier versions
                let vc = story.instantiateViewController(withIdentifier: "PreLoginVC") as! PreLoginVC
                vc.performSegue(withIdentifier: "Login", sender: nil)
            }*/
        
        default:debugPrint("")
        }
        default:debugPrint("")
        }
    }
}

