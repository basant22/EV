//
//  FavoriteStationVC.swift
//  ChargePark
//
//  Created by apple on 16/12/21.
//

import UIKit

class FavoriteStationVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var navigationCon: UINavigationBar!
    var dict : [String:Double] = [:]
    var latValue:Double = 0.0
    var longValue:Double = 0.0
    var reachedFrom:FavStnFrom = .Menu
    var dataSource:[ResultStation]!
    var chargers:[ResultCharger] = []
    var proceedToNext:((UIViewController,[ResultCharger],ResultStation)->()) = {_,_,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        latValue = Defaults.shared.userLocation["lat"] ?? 0.0
        longValue = Defaults.shared.userLocation["long"] ?? 0.0
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.dataSource = Defaults.shared.favoriteStation
        tableView.registerNibs(nibNames: [FavoriteCell.identifier,EmptyCellCell.identifier])
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
       // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        if reachedFrom == .Menu{
            self.tableView.backgroundColor = .lightGray
            self.navigationCon.isHidden = false
        }else{
            self.navigationCon.isHidden = true
            self.view.backgroundColor = .clear
            self.tableView.backgroundColor = .lightGray.withAlphaComponent(0.55)
        }
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
   
    func profileRequest(stationName:String,completion:@escaping()->()){
       // self.group.enter()
        let userName = Defaults.shared.userLogin?.username ?? ""
        let profileResource = ApiGetRequest()
        profileResource.kindOf(Theme.ShowProfile, requestFor: .PROFILE, queryString: [userName], response: Profile.self) {[weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ =  res.success,let msg =  res.message, msg == "Ok" {
                if let profile = res.result{
                   // print("profile get successfully")
                    Defaults.shared.usrProfile = profile
                    if Utils.getProfileFromUserDefaults() == true{
                        UserDefaults.standard.removeObject(forKey: Theme.ProfileInfo)
                    }else{
                        Utils.saveProfileInfoInUserDefaults(data: profile)
                    }
                    if let resultFav = profile.preferredStations{
                        if  resultFav.contains(","){
                            let favStnId = resultFav.components(separatedBy: ",")
                            let intStnArray = favStnId.map { Int($0)!}
                            let favLoca = Defaults.shared.favoriteStation.filter({intStnArray.contains($0.stationID!)})
                            Defaults.shared.favoriteStation = favLoca
                        }else{
                            let favStnId = resultFav
                            let favLoca = Defaults.shared.favoriteStation.filter({$0.stationID == Int(favStnId)})
                            Defaults.shared.favoriteStation = favLoca
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion()
                       // self?.viewFav.isHidden = false
                       // self?.btnFavStn .isHidden = false
                    //self?.displayAlert(alertMessage: "\(stationName) removed from favorite station")
                    }
                }
            }
        }
    }
    func removFavourite(stationId:Int,stationName:String,onCompletion:@escaping()->()){
       
            let req = ApiPostRequest()
            self.showLoader()
            let appendStr = "removestationfavorites/\(stationId)"
            req.kindOf(appendStr, requestFor: .FAVORITE_STATIONS, request: Req(), response: FavoriteStations.self) {[weak self] (results) in
               
                if let res = results,let success = res.success,let msg =  res.message, let resultFav = res.result, msg == "Ok" && success == true  {
                    self?.profileRequest(stationName: stationName){
                        onCompletion()
                    }
                }else{
                    self?.hideLoader()
                    DispatchQueue.main.async {
                            self?.displayAlert(alertMessage: "There is some probelm to adding!!")
                    }
                }
            }
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Details" {
            if let vc = segue.destination as? StationDetailViewController,let detail = sender as? ResultStation{
                // vc.stationDetail = ResultStation.init()
                vc.chargers =  self.chargers
                vc.stationDetail = detail
                vc.dictUserLatLong = self.dict
                vc.bookingBy = .General(true)
                //print("\(vc.stationDetail?.stationname)")
            }
        }
    }
    
    func sendRequestForChargerByStation(stationId:Int,location:ResultStation){
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.ChargerAtStation, requestFor: .CHARGER_STATUS_AT_STATIONS, queryString: [String(stationId)], response: ChargerResponse.self) { [weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ = res.success,let msg =  res.message, let result = res.result, msg == "Ok" && result.count > 0{
                self?.chargers = result
               
                if self?.reachedFrom == .Menu{
                     DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "Details", sender: location)
                }
                }else{
                    if let slf = self{
                        slf.proceedToNext(slf,slf.chargers,location)
                    }
                }
            }
        }
    }
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
}
extension FavoriteStationVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count > 0 ? dataSource.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
                cell.selectionStyle = .none
            cell.openMap = { [weak self] in
                if let latt = self?.dataSource?[indexPath.row].lattitude,let long = self?.dataSource?[indexPath.row].longitude {
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                        if let url = URL(string: "comgooglemaps://?saddr\(self?.latValue ?? 0.0 ),\(self?.longValue ?? 0.0)=&daddr=\(latt),\(long)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:])
                        }}else {
                        //Open in browser
                            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr\(self?.latValue ?? 0.0 ),\(self?.longValue ?? 0.0))=&daddr=\(latt),\(long)&directionsmode=driving") {
                            UIApplication.shared.open(urlDestination)
                        }
                    }
                }
            }
                 return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCellCell", for: indexPath) as! EmptyCellCell
                cell.selectionStyle = .none
                return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > 0 {
        if let stnId = dataSource[indexPath.row].stationID {
        self.sendRequestForChargerByStation(stationId: stnId, location:dataSource[indexPath.row])
         }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataSource.count > 0 {
            let cell = cell as! FavoriteCell
            cell.setUpCell(data: dataSource[indexPath.row])
        }else{
            let cell = cell as! EmptyCellCell
            self.tableView.backgroundColor = Theme.menuHeaderColor
            cell.backgroundColor = Theme.menuHeaderColor
            cell.contentView.backgroundColor = Theme.menuHeaderColor
            cell.img.image = #imageLiteral(resourceName: "Address").tint(with: .white)
            cell.lblTitle.text = "No Favourite Stations Found"
            cell.lblTitle.textColor = .white
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if dataSource.count > 0 {
            return 180
        }else{
            return self.tableView.bounds.height
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if reachedFrom == .Menu{
            //let vw = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return UIView()
        }else{
            let vw = UIView(frame: CGRect(x: 20, y: 0, width: self.tableView.bounds.width-20, height: 50))
            vw.cornerRadius(with: 6.0)
            let imgVw = UIImageView(frame:CGRect(x: 5, y: 10, width: 30, height: 30))
            imgVw.image = #imageLiteral(resourceName: "Favorite").tint(with: .white)
            let lbl = UILabel(frame:CGRect(x: 40, y: 10, width: vw.bounds.width, height: 30))
            lbl.text = "Favorite Stations"
            lbl.font = UIFont(name: "System-Bold", size: 18.0)
            lbl.textColor = .white
            let btn = UIButton(frame:CGRect(x: vw.frame.size.width-30, y: 5, width: 40, height: 40))
            let img = #imageLiteral(resourceName: "Close").tint(with: .white)
            btn.setImage(img, for: .normal)
            btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
            vw.addSubview(imgVw)
            vw.addSubview(lbl)
            vw.addSubview(btn)
          
            vw.backgroundColor = Theme.menuHeaderColor
            return vw
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if reachedFrom == .Menu{
            return 0
        }else{
            return 50
        }
      }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           // print("Deleted")
            if let stnId = self.dataSource[indexPath.row].stationID,let stnName = self.dataSource[indexPath.row].stationname{
                removFavourite(stationId: stnId, stationName: stnName) {
                    self.dataSource.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
