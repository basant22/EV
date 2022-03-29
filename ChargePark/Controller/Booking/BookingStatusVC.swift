//
//  BookingStatusVC.swift
//  V-Power
//
//  Created by apple on 07/10/21.
//

import UIKit

class BookingStatusVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var btnBack:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    @IBOutlet weak var btnAddVehicle:UIButton!
    var chargerAndPort:String?
    var selectedStation : SelectedChargerAndPort?
    var resultCharger:ResultCharger?
    var vehicles:[VehicleDeatil]? = []
    var dataSource:[ShowVehicels] = []
    var bookingBy:BookingBy!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.action = #selector(btnBack_Action(_:))
        self.navigation.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Select Your Vehicle"
        }
       
        // Do any additional setup after loading the view.
        self.btnAddVehicle.isHidden = true
        self.btnAddVehicle.isUserInteractionEnabled = false
        tableView.registerNibs(nibNames: ["TextCell","NewTextCell","ButtonCell"])
//        self.btnAddVehicle.cornerRadius(with: 6.0)
//        self.btnAddVehicle.backgroundColor = Theme.menuHeaderColor
//        self.btnAddVehicle.setImage(#imageLiteral(resourceName: "BigCar").tint(with: .white), for: .normal)
//        self.btnAddVehicle.setTitle("Add Vehicle", for: .normal)
//        self.btnAddVehicle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        let data = [(#imageLiteral(resourceName: "Car"),"Select Vehicle"),(#imageLiteral(resourceName: "Car"),"Select Model"),(#imageLiteral(resourceName: "Registration"),"Select Registration Number"),(UIImage(),"Proceed")]
        for (i,valu) in data.enumerated(){
                let vehicles = Defaults.shared.addedVehicle.result?.compactMap({$0.make}).unique.sorted()
            let showV = ShowVehicels(image: valu.0, placeHolder: valu.1, index: i, addedVehicle: vehicles,addedModel: nil,addeduserEVId: nil,addedRegNo: nil,selectedModel: nil,selectedVehicle:nil,selectedReg: nil,selectedUserEvId:nil, controller: self)
            dataSource.append(showV)
        }
    }
    @objc func btnBack_Action(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddVehicle_Avtion(_ sender:UIButton){
        let homwStory = UIStoryboard(name: "Home", bundle: nil)
        if let vc = homwStory.instantiateViewController(withIdentifier: "AddVehicleController") as? AddVehicleController{
            vc.view.backgroundColor = Theme.menuHeaderColor.withAlphaComponent(0.55)
        self.present(vc, animated: true, completion: nil)
        }
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChargeNow"{
            let vc = segue.destination as? ConfirmBookingVC
            if let userEvId = self.dataSource[1].selectedUserEvId {
                self.selectedStation?.userEvId = Int(userEvId)
                vc?.selectedStation = self.selectedStation
                vc?.resultCharger = self.resultCharger
                vc?.bookingBy = self.bookingBy
            }
        }
    }
    deinit {
        print("\(self) id deinitialized")
    }
}
extension BookingStatusVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 3,4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
           
            cell.selectionStyle = .none
            cell.getButtonAction = {[weak self] (done) in
                if indexPath.row == 4 {
                    let homwStory = UIStoryboard(name: "Home", bundle: nil)
                    if let vc = homwStory.instantiateViewController(withIdentifier: "AddVehicleController") as? AddVehicleController{
                        vc.controller = self
                        vc.view.backgroundColor = Theme.menuHeaderColor.withAlphaComponent(0.55)
                        vc.addVehileToList = {[weak self] (result,vehicle,control) in
                            control.dismiss(animated: true) {
                                self?.vehicles?.append(result)
                               // Defaults.shared.addedVehicle.result?.append(result)
                                //= self?.vehicles
                              //  Utils.saveUserEvsInfoInUserDefaults(data: Defaults.shared.addedVehicle)
                                if let res =  Defaults.shared.addedVehicle.result,res.count > 1 {
                                        let vehicles = Defaults.shared.addedVehicle.result?.compactMap({$0.make}).unique.sorted()
                                            self?.dataSource[0].addedVehicle = vehicles
                                    }
                                    self?.tableView.reloadData()
                                    self?.tableView.layoutIfNeeded()
                                    let vehicl:String = vehicle + " added succesfully"
                                    self?.displayAlert(alertMessage: vehicl)
                            }
                        }
                    self?.present(vc, animated: true, completion: nil)
                    }
                }else{
                    cell.selectionStyle = .none
                    switch self?.bookingBy{
                    case .General,.QrCode:
                        if let data = self?.dataSource{
                        let vehicleSource = validateAddedVehicle()
                        let result =  vehicleSource.validate(data: data)
                        if result.success{
                        self?.performSegue(withIdentifier: "ChargeNow", sender: nil)
                        }else{
                            self?.displayAlert(alertMessage: result.errorMessage!)
                        }
                    }
                    case .none:
                        print("")
                    }
                    
                   // self.sendBookingRequesr()
                }
               
            }
            return cell
        default:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cell.selectionStyle = .none
                cell.getTextvalue = { [weak self] (value,index) in
                    if let model = Defaults.shared.addedVehicle.result?.filter({$0.make == value}).compactMap({$0.model}){
                        if model.count == 1 {
                            self?.dataSource[1].selectedModel = model.first
                        }else{
                            if let val =  self?.dataSource[1].selectedModel,!val.isEmpty{
                                self?.dataSource[1].selectedModel = ""
                            }
                            if let val =  self?.dataSource[2].selectedReg,!val.isEmpty{
                                self?.dataSource[2].selectedReg = ""
                            }
                        }
                        self?.dataSource[0].selectedVehicle = value
                        self?.dataSource[1].addedModel = model
                    }
                    if let userEVId = Defaults.shared.addedVehicle.result?.filter({$0.make == value}).compactMap({$0.userEVId}){
                        if userEVId.count == 1 {
                            self?.dataSource[1].selectedUserEvId = String(userEVId.first!)
                        }
                           self?.dataSource[1].addeduserEVId = userEVId
                    }
                    self?.tableView.reloadData()
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewTextCell", for: indexPath) as! NewTextCell
                cell.selectionStyle = .none
                
                cell.getTextData = { [weak self] (value,indx) in
                    if let regNum = Defaults.shared.addedVehicle.result?.filter({$0.model == value && $0.make == self?.dataSource[0].selectedVehicle}).compactMap({$0.evRegNumber}){
                        if regNum.count == 1 {
                            self?.dataSource[2].selectedReg = regNum.first
                        }else{
                            self?.dataSource[2].selectedReg = regNum[indx!]
                        }
                        if let evId = self?.dataSource[1].addeduserEVId{
                         self?.dataSource[1].selectedUserEvId = String(evId[indx!])
                            
                         }
                        self?.dataSource[2].addedRegNo = regNum
                        self?.dataSource[1].selectedModel = value
                    }
                    self?.tableView.reloadData()
                }
                return cell
            case 2:
               
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cell.selectionStyle = .none
               
                cell.getTextvalue = { [weak self] (value,index) in
                self?.dataSource[2].selectedReg = value
                self?.tableView.reloadData()
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            let cell = cell as! ButtonCell
            cell.btnCell.setTitle(" Proceed", for: .normal)
            
            cell.btnCell.setImage(#imageLiteral(resourceName: "Battry").tint(with: .white), for: .normal)
            cell.btnCell.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.btnCell.setTitleColor(.white, for: .normal)
            cell.btnCell.backgroundColor = Theme.menuHeaderColor
            cell.btnCell.cornerRadius(with: 6.0)
        case 4:
            let cell = cell as! ButtonCell
            if let vehicle = Defaults.shared.addedVehicle.result, vehicle.count == 0{
                cell.btnCell.setTitle("Add your  vehicle", for: .normal)
            }else{
                cell.btnCell.setTitle("Add more vehicle", for: .normal)
            }
            cell.btnCell.setImage(#imageLiteral(resourceName: "BigCar").tint(with: .white), for: .normal)
            cell.btnCell.imageEdgeInsets.left = -10
            cell.btnCell.cornerRadius(with: 6.0)
            cell.btnCell.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.btnCell.setTitleColor(.white, for: .normal)
            cell.btnCell.backgroundColor = Theme.menuHeaderColor
        default:
       
            switch indexPath.row {
            case 0:
                let cell = cell as! TextCell
                if let vehicle =  Defaults.shared.addedVehicle.result?.compactMap({$0.make}),vehicle.count == 1 {
                    self.dataSource[0].addedVehicle = vehicle
                    self.dataSource[0].selectedVehicle = vehicle.first
                    if let model =  Defaults.shared.addedVehicle.result?.compactMap({$0.model}),model.count == 1 {
                        self.dataSource[1].addedModel = model
                        self.dataSource[1].selectedModel = model.first
                        }
                    if let userEVId = Defaults.shared.addedVehicle.result?.filter({$0.make == self.dataSource[0].selectedVehicle}).compactMap({$0.userEVId}){
                        if userEVId.count == 1 {
                            self.dataSource[1].selectedUserEvId = String(userEVId.first!)
                        }
                    }
                    
                    
                    if let regNo = Defaults.shared.addedVehicle.result?.filter({$0.model == self.dataSource[1].selectedModel && $0.make == self.dataSource[0].selectedVehicle}).compactMap({$0.evRegNumber}),regNo.count == 1{
                        self.dataSource[2].selectedReg = regNo.first
                        self.dataSource[2].addedRegNo = regNo
                    }
                    }
                cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
//                else{
//                    cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
//                }
               // cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
            case 1:
                let cell = cell as! NewTextCell
                if let model =  Defaults.shared.addedVehicle.result?.compactMap({$0.model}),model.count == 1 {
                    self.dataSource[0].selectedModel = model.first
                    self.dataSource[0].addedModel = model
                }
                cell.setData(data: self.dataSource[indexPath.row])
//                else{
//                    cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
//                }
                //cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
            case 2:
                let cell = cell as! TextCell
                if let regNo = Defaults.shared.addedVehicle.result?.filter({$0.model == self.dataSource[1].selectedModel && $0.make == self.dataSource[0].selectedVehicle}).compactMap({$0.evRegNumber}),regNo.count == 1{
                    self.dataSource[2].selectedReg = regNo.first
                    self.dataSource[2].addedRegNo = regNo
                }
                cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
//                else{
//                    cell.AddDataForBookingStatusCell(data: self.dataSource[indexPath.row])
//                }
               
            default:
                print("")
            }
           
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

struct ShowVehicels {
    let image:UIImage
    let placeHolder:String
    let index:Int
    var addedVehicle:[String]?
    var addedModel:[String]?
    var addeduserEVId:[Int]?
    var addedRegNo:[String]?
    var selectedModel:String?
    var selectedVehicle:String?
    var selectedReg:String?
    var selectedUserEvId:String?
    let controller:UIViewController?
}

