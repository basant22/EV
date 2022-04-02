//
//  ProfileVC.swift
//  ChargePark
//
//  Created by apple on 28/06/1943 Saka.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var titleBar: UIBarButtonItem!
    var titlesAndValue:[(String,String)]!
    var vehCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        self.navigation.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        tableView.registerNibs(nibNames: ["InfoCell","PersonalInfoCell"])
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "My Info"
        }
        if let veh = Defaults.shared.usrProfile?.vehicles,let vehiNme = veh.first,vehiNme != ""{
            self.vehCount = veh.count
        }
        titlesAndValue = [("No. of Vehicle",String(self.vehCount)),("Total Charging Durations",String(Defaults.shared.usrProfile?.totalChargingDuration ?? 0)),("Type of Vehicel","N/A"),("Total Consuption",String(Defaults.shared.usrProfile?.totalConsumption ?? 0)),("Home Address",Defaults.shared.usrProfile?.address ?? "N/A")]
//        tableView.rowHeight = 250
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
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
extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if Theme.appName == "EV Plugin Charge" {
                return titlesAndValue.count
            }else{
                return 1
            }
        default:
            if Theme.appName == "EV Plugin Charge" {
                return 1
            }else{
                return titlesAndValue.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if Theme.appName == "EV Plugin Charge" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell", for: indexPath) as! PersonalInfoCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
                return cell
            }
//            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
//            return cell
        default:
            if Theme.appName == "EV Plugin Charge" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell", for: indexPath) as! PersonalInfoCell
                return cell
            }
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell", for: indexPath) as! PersonalInfoCell
//            return cell
        }
    
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if Theme.appName == "EV Plugin Charge" {
                let cell = cell as! PersonalInfoCell
                //cell.setPersonalInfo()
                cell.lblTitle.text = titlesAndValue[indexPath.row].0
                cell.lblValue.text = titlesAndValue[indexPath.row].1
            }else{
                let cell = cell as! InfoCell
                cell.setData()
            }
          
        default:
            if Theme.appName == "EV Plugin Charge" {
                let cell = cell as! InfoCell
                cell.setData()
            }else{
                let cell = cell as! PersonalInfoCell
                //cell.setPersonalInfo()
                cell.lblTitle.text = titlesAndValue[indexPath.row].0
                cell.lblValue.text = titlesAndValue[indexPath.row].1
            }
           // cell.layoutIfNeeded()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            if Theme.appName == "EV Plugin Charge" {
                return UIView()
            }else{
                let headervw = UIView(frame: CGRect(x: 10, y: 10, width: 180, height: 30))
                let lbl = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 30))
                lbl.text = "Personal information"
                lbl.font = UIFont.systemFont(ofSize: 20.0)
                    //UIFont(name: "HelveticaNeue-Medium", size: 20.0)
                lbl.textColor = Theme.menuHeaderColor
                let img = UIImageView(frame: CGRect(x:headervw.bounds.width + 14, y:3, width: 22, height: 22))
                img.image = #imageLiteral(resourceName: "Pencil").tint(with: Theme.menuHeaderColor)
                headervw.addSubview(lbl)
                headervw.addSubview(img)
                return headervw
            }
        default:
            if Theme.appName == "EV Plugin Charge" {
                let headervw = UIView(frame: CGRect(x: 10, y: 10, width: 180, height: 30))
                let lbl = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 30))
                lbl.text = "Personal information"
                lbl.font = UIFont.systemFont(ofSize: 20.0)
                    //UIFont(name: "HelveticaNeue-Medium", size: 20.0)
                lbl.textColor = Theme.menuHeaderColor
                let img = UIImageView(frame: CGRect(x:headervw.bounds.width + 14, y:3, width: 22, height: 22))
                img.image = #imageLiteral(resourceName: "Pencil").tint(with: Theme.menuHeaderColor)
                headervw.addSubview(lbl)
                headervw.addSubview(img)
                return headervw
            }else{
                return UIView()
            }
           
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            if Theme.appName == "EV Plugin Charge" {
                return 0
            }else{
                return 40
            }
           
        default:
            if Theme.appName == "EV Plugin Charge" {
                return 40
            }else{
                return 0
            }
        }
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//            return UITableView.automaticDimension
//        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0{
                if Theme.appName == "EV Plugin Charge" {
                    return 77
                }else{
                    return 210
                }
               
            }else if indexPath.section == 1{
                if Theme.appName == "EV Plugin Charge" {
                    return 210
                }else{
                    return 77
                }
            }
            return 0
           // return UITableView.automaticDimension
        }

//        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            cell.layoutIfNeeded()
//        }
    
}
