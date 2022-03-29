//
//  AddVehicleController.swift
//  V-Power
//
//  Created by apple on 05/10/21.
//

import UIKit

class AddVehicleController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigationCon: UINavigationBar!
   // @IBOutlet weak var menuButton: UIBarButtonItem!
    var addVehicleReq:AddVehicleRequest?
    var vehicleList:[VehicleList]?
    var controller:UIViewController?
    var dataSource:[(UIImage,String,[String]?,[VehicleList]?,String?)] = []
    var listOfYear:[String] = ["2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010",]
    var addedVehicle:VehicleDeatil!
    var addVehileToList:((VehicleDeatil,String,UIViewController)->()) = {_,_,_ in}
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        if  self.revealViewController() != nil{
//                  menuButton.target = self.revealViewController()
//                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//              }
        if Theme.appName == "VRAJEV Charge"{
            self.title = "Add Your Vehicle"
        }
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        addVehicleReq = AddVehicleRequest(userEVId: 0, year: "", model: "", evRegNumber: "", make: "", username: "")
        tableView.registerNibs(nibNames: ["TextCell","ButtonCell"])
       // self.dataSource = [(#imageLiteral(resourceName: "Car"),"Vehicle Manufacture",nil,nil),(#imageLiteral(resourceName: "Name"),"Model",nil,nil),(#imageLiteral(resourceName: "Mobile"),"Year of Production",self.listOfYear,nil),(#imageLiteral(resourceName: "Email"),"Registration No.",nil,nil),(UIImage(),"Add Your EV",nil,nil),(UIImage(),"Cancel",nil,nil)]
        // Do any additional setup after loading the view.
        loadVehicles()
    }
    func loadVehicles()  {
        let vehicleResource = vehicleResource()
        vehicleResource.getVehicleList(connector: "evtemplates") { [weak self] (response) in
            if let res = response,let vehicleResult = res.result,let msg =  res.message,msg == "Ok" && vehicleResult.count > 0 {
                self?.vehicleList = vehicleResult
                let vehicleModels = vehicleResult.compactMap({$0.make}).unique.sorted()
                self?.dataSource = [(#imageLiteral(resourceName: "City"),"Vehicle Manufacture",vehicleModels,nil,nil),(#imageLiteral(resourceName: "Car"),"Model",nil,nil,nil),(#imageLiteral(resourceName: "Calander"),"Year of Production",self?.listOfYear,nil,nil),(#imageLiteral(resourceName: "Registration"),"Registration No.",nil,nil,nil),(UIImage(),"Add Your EV",nil,nil,nil),(UIImage(),"Cancel",nil,nil,nil)]
                if let user = Defaults.shared.userLogin, let userName = user.username{
                    self?.addVehicleReq?.username = userName
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
 
    fileprivate func addVehicleCall()  {
        let validation = AddVehicleValidation()
        let resource = AddVehicleResource()
        if let request = self.addVehicleReq {
            let status =  validation.validate(request: request)
            if status.success {
                self.showLoader()
                resource.addVehicle(request: request, connector:Theme.AddVehicle, controller: self) {[weak self] (response) in
                    self?.hideLoader()
                    if let res = response,let result = res.result, let _ = res.success,let msg =  res.message,msg == "Ok"{
                        self?.loadUserAddedVehicles(data:result)
                    }else{
                        DispatchQueue.main.async {
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }else{
                self.displayAlert(alertMessage: status.errorMessage!)
            }
        }
    }
    fileprivate func loadUserAddedVehicles(data:VehicleDeatil){
        if let useName = Defaults.shared.userLogin?.username,useName.count > 0{
            ApiGetRequest().kindOf(Theme.VehicleList, requestFor: .VEHICLE_LIST, queryString: [useName], response: AddedVehicle.self) {[weak self] (response) in
                self?.hideLoader()
                if let res = response,let result = res.result,let msg = res.message,msg == "Ok"{
                    Defaults.shared.addedVehicle.result = result
                    Utils.saveUserEvsInfoInUserDefaults(data: Defaults.shared.addedVehicle)
                    DispatchQueue.main.async {
                            self?.dismiss(animated: true, completion: nil)
                        if let manuf = data.make,let model = data.model,let sel = self{
                            let veh:String = manuf + " " + model
                            sel.addVehileToList(data,veh,sel)
                        }
                    }
                }else{
                    Defaults.shared.addedVehicle.result?.append(data)
                    DispatchQueue.main.async {
                            self?.dismiss(animated: true, completion: nil)
                        if let manuf = data.make,let model = data.model,let sel = self{
                            let veh:String = manuf + " " + model
                            sel.addVehileToList(data,veh,sel)
                        }
                    }
                }
            }
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
extension AddVehicleController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { [weak self] (value,index) in
                if let list = self?.vehicleList?.filter({ $0.make == value}){
                    
                    if list.count == 1 {
                        self?.addVehicleReq?.model = (list.first?.model)!
                        self?.dataSource[1].4 = list.first?.model
                        self?.addVehicleReq?.userEVId = (list.first?.evTemplateID)!
                    }else{
                        if let val =  self?.dataSource[1].4,!val.isEmpty{
                            self?.dataSource[1].4 = ""
                        }
                        if let val =  self?.dataSource[3].4,!val.isEmpty{
                            self?.dataSource[3].4 = ""
                        }
                    }
                    self?.addVehicleReq?.make = value
                    self?.dataSource[0].4 = value
                    self?.dataSource[1].3 = list
                    self?.tableView.reloadData()
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { [weak self] (value,index) in
                if let userEVId = self?.vehicleList?[index!].evTemplateID {
                    self?.addVehicleReq?.model = value
                    self?.dataSource[1].4 = value
                    self?.addVehicleReq?.userEVId = userEVId
                    self?.tableView.reloadData()
                }
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { [weak self] (value,index) in
                self?.addVehicleReq?.year = value
                self?.dataSource[2].4 = value
                self?.tableView.reloadData()
                }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = {[weak self] (value,index) in
                self?.addVehicleReq?.evRegNumber = value
                self?.dataSource[3].4 = value
               // self.tableView.reloadData()
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.selectionStyle = .none
            cell.getButtonAction = {[weak self] (done) in
                if done {
                self?.addVehicleCall()
                }
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.selectionStyle = .none
            cell.getButtonAction = { [weak self] (done) in
//                if let control =  self.controller,control is BookingStatusVC {
//                    self.dismiss(animated: true, completion: nil)
//                }else{
//                self.navigationController?.popViewController(animated: true)
//                }
                if done {
                self?.dismiss(animated: true, completion: nil)
                }
            }
            return cell
        default:
           print("")
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let cell = cell as! TextCell
            cell.AddDataToCell(dataSource[indexPath.row].1, image: dataSource[indexPath.row].0, make: dataSource[indexPath.row].2, model: nil, index: indexPath.row,controller: self,selectedText: dataSource[indexPath.row].4)
        case 1:
            let cell = cell as! TextCell
            cell.AddDataToCell(dataSource[indexPath.row].1, image: dataSource[indexPath.row].0, make: nil, model: dataSource[indexPath.row].3, index: indexPath.row,controller: self,selectedText: dataSource[indexPath.row].4)
        case 2:
            let cell = cell as! TextCell
            cell.AddDataToCell(dataSource[indexPath.row].1, image: dataSource[indexPath.row].0, make: dataSource[indexPath.row].2, model: nil, index: indexPath.row,controller: self,selectedText: dataSource[indexPath.row].4)
        case 3:
            let cell = cell as! TextCell
            cell.AddDataToCell(dataSource[indexPath.row].1, image: dataSource[indexPath.row].0, make: nil, model: nil, index: indexPath.row,controller: self,selectedText: dataSource[indexPath.row].4)
        case 4:
            let cell = cell as! ButtonCell
            cell.btnCell.setTitle("Add Your Vehicle", for: .normal)
            cell.btnCell.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            cell.btnCell.cornerRadius(with: 6.0)
            cell.btnCell.backgroundColor = Theme.menuHeaderColor
            cell.btnCell.setTitleColor(.white, for: .normal)
           
        case 5:
            let cell = cell as! ButtonCell
            cell.btnCell.setTitle("Cancel", for: .normal)
            cell.btnCell.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            cell.btnCell.setTitleColor(Theme.menuHeaderColor, for: .normal)
            cell.btnCell.backgroundColor = .clear
            cell.btnCell.cornerRadius(with: 6.0)
            cell.btnCell.layer.borderWidth = 1.0
            cell.btnCell.layer.borderColor = Theme.menuHeaderColor.cgColor
        default:
            print("")
            
        }
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 70))
        viewHeader.backgroundColor = Theme.menuHeaderColor
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 10, width: self.tableView.bounds.width, height: 30))
        labelTitle.text = "SELECT YOUR EV DETAILS"
        labelTitle.textColor = .white
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.systemFont(ofSize: 20.0)
        labelTitle.tintColor = Theme.menuHeaderColor
        viewHeader.addSubview(labelTitle)
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
