//
//  VehicleListViewController.swift
//  V-Power
//
//  Created by apple on 05/10/21.
//

import UIKit

class VehicleListViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var navigationCon: UINavigationBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var titleBar: UIBarButtonItem!
    var vehicles:[VehicleDeatil]? = []
    private let group = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
       // self.title = "My Vehicles"
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        tableView.backgroundColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        tableView.registerNibs(nibNames: ["VehicleCell","EmptyCellCell"])
        // Do any additional setup after loading the view.
        // btnAdd.backgroundColor = Theme.menuHeaderColor
        // btnAdd.cornerRadius(with: btnAdd.bounds.height)
        addButton.action = #selector(addYourVehicle(_:))
        btnAdd.setImage(#imageLiteral(resourceName: "Add").tint(with: Theme.emptyColor), for: .normal)
        self.loadUserAddedVehicles()
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Vehicles Info"
        }
        if Theme.appName == "EV Plugin Charge"{
            self.titleBar.title = "Vehicle Report"
        }
    }
    
   fileprivate func loadUserAddedVehicles(){
      
       if let useName = Defaults.shared.userLogin?.username,useName.count > 0{
           self.showLoader()
           ApiGetRequest().kindOf(Theme.VehicleList, requestFor: .VEHICLE_LIST, queryString: [useName], response: AddedVehicle.self) {[weak self] (response) in
               self?.hideLoader()
               if let res = response,let result = res.result,let msg = res.message,msg == "Ok"{
                   self?.vehicles = result
                   Defaults.shared.addedVehicle.result = self?.vehicles
                   DispatchQueue.main.async {
                       self?.tableView.reloadData()
                   }
               }
           }
       }
       /* let resource = AddedVehicleResource()
      if let useName = Defaults.shared.userLogin?.username,useName.count > 0{
            self.showLoader()
        resource.getAddedVehicleList(connector:Theme.VehicleList, userName: useName) { response in
                self.hideLoader()
                if let res = response,let result = res.result,let msg = res.message,msg == "Ok"{
                    self.vehicles = result
                    Defaults.shared.addedVehicle.result = self.vehicles
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }else{
            self.displayAlert(alertMessage: "Are you guest user ? Please register!")
        }*/
    }
   @objc func addYourVehicle(_ sender:UIBarButtonItem){
       if let useName = Defaults.shared.userLogin?.username,useName.count > 0{
        self.performSegue(withIdentifier: "Add", sender: nil)
       }else{
           self.displayAlert(alertMessage: "Are you guest user ? Please register!")
       }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! AddVehicleController
        vc.addVehileToList = {[weak self] (dataOfvehicle,veh,control) in
            control.dismiss(animated: true){
                self?.vehicles?.append(dataOfvehicle)
                Defaults.shared.addedVehicle.result = self?.vehicles
                Utils.saveUserEvsInfoInUserDefaults(data: Defaults.shared.addedVehicle)
                self?.tableView.reloadData()
                let msg:String = veh + "addded successfully"
                self?.displayAlert(alertMessage:msg)
            }
        }
    }
    
    @IBAction func addVehicle(_ sender:UIButton){
        self.performSegue(withIdentifier: "Add", sender: nil)
    }
    deinit {
        print("\(self) id deinitialized")
    }
}
extension VehicleListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vehicle = self.vehicles,vehicle.count > 0 {
            return vehicle.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let vehicle = self.vehicles,vehicle.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath) as! VehicleCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCellCell", for: indexPath) as! EmptyCellCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let vehicle = self.vehicles,vehicle.count > 0 {
        let cell = cell as! VehicleCell
            if let data = self.vehicles{
            cell.setupCell(data:data[indexPath.row])
        }
        }else {
            let cell = cell as! EmptyCellCell
           // self.tableView.backgroundColor = Theme.menuHeaderColor
            cell.backgroundColor = Theme.menuHeaderColor
            cell.contentView.backgroundColor = Theme.menuHeaderColor
            cell.backgroundColor = Theme.menuHeaderColor
           // cell.backgroundColor = Theme.emptyColor
            cell.img.image =  #imageLiteral(resourceName: "My Vehicle").tint(with: .white)
            cell.lblTitle.textColor = .white
            cell.lblTitle.text = "No vehicles found please add."
            cell.selectionStyle = .none
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let vehicle = self.vehicles,vehicle.count > 0{
        return 110
        }else{
            return self.tableView.bounds.height
        }
    }
    
}
