//
//  AddToFavoriteVC.swift
//  ChargePark
//
//  Created by apple on 17/12/21.
//

import UIKit
import Kingfisher
class AddToFavoriteVC: UIViewController {
    @IBOutlet weak var viewBase:UIView!
    @IBOutlet weak var viewImg:UIView!
    @IBOutlet weak var viewLbl:UIView!
    @IBOutlet weak var viewButton:UIView!
    @IBOutlet weak var StackH:UIStackView!
    @IBOutlet weak var imgVw:UIImageView!
    @IBOutlet weak var lblStnName:UILabel!
    @IBOutlet weak var lblStnAddress:UILabel!
    @IBOutlet weak var lblStnContact:UILabel!
    @IBOutlet weak var lblStnOperator:UILabel!
    @IBOutlet weak var btnProceed:UIButton!
    @IBOutlet weak var btnAddToFav:UIButton!
    @IBOutlet weak var btnClose:UIButton!
    var dataSource:ResultStation!
    var stationLocation:[ResultStation]!
    var dict : [String:Double] = [:]
    var proceedToCharger:((UIViewController)->()) = { _ in}
    var addToFavourite:((UIViewController)->()) = { _ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.55)
        setTheme()
        guard let stnId = dataSource.stationID else {return}
        if let preferredStations = Defaults.shared.usrProfile?.preferredStations {
            if !preferredStations.contains(String(stnId)){
                self.btnAddToFav.isHidden = false
            }else{
                self.btnAddToFav.isHidden = true
            }
        }
//        if Theme.appName == "VRAJEV Charge" {
//            self.btnAddToFav.isHidden = true
//        }
        // Do any additional setup after loading the view.
    }
    func setTheme(){
        let imgClose = UIImage(systemName: "xmark")?.tint(with: Theme.menuHeaderColor)
        let imgFav = UIImage(systemName: "heart")?.tint(with: .white)
        let imgFa = UIImage(systemName: "plus.circle")?.tint(with: .white)
        let imgProc = UIImage(systemName: "arrow.right")?.tint(with: .white)
        let imgPro = UIImage(systemName: "forward")?.tint(with: .white)
        
        self.btnClose.setImage(imgClose, for: .normal)
        self.btnProceed.setImage(imgProc, for: .normal)
        self.btnAddToFav.setImage(imgFav, for: .normal)
        
        self.btnClose.setTitle("", for: .normal)
        self.btnProceed.setTitle(" Proceed", for: .normal)
        self.btnAddToFav.setTitle(" Add To Favourite", for: .normal)
        if Theme.appName == "EV Plugin Charge" {
            self.btnAddToFav.setImage(imgFa, for: .normal)
            self.btnProceed.setImage(imgPro, for: .normal)
            self.btnProceed.setTitle(" Next", for: .normal)
            self.btnAddToFav.setTitle(" Favourite", for: .normal)
        }
    
        
        viewBase.cornerRadius(with: 8.0)
        viewBase.backgroundColor = Theme.menuHeaderColor
        viewImg.cornerRadius(with: 8.0)
        viewLbl.cornerRadius(with: 8.0)
        btnProceed.cornerRadius(with: 10.0)
        btnAddToFav.cornerRadius(with: 10.0)
        btnAddToFav.backgroundColor = Theme.menuHeaderColor
        btnProceed.backgroundColor = Theme.newGreen
        viewButton.backgroundColor = .clear
        setData()
    }
    func setData(){
        if let name = dataSource.stationname , let address = dataSource.address, let contact = dataSource.contact{
            lblStnName.text = name
            lblStnAddress.text = address
            lblStnContact.text = contact
            lblStnOperator.text = ""
            self.imgVw.setImage(url: dataSource.icon ?? "")
        }
    }
    
    @IBAction func closeTheWindow(_sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnProceed(_sender:UIButton){
        self.proceedToCharger(self)
    }
    @IBAction func btnAddToFavorite(_sender:UIButton){
        self.addToFavourite(self)
    }
    
    func sendReqAddToFavorite(stationId:String,stationName:String){
        let req = ApiPostRequest()
        self.showLoader()
        let appendStr = "stationfavorites/\(stationId)"
        req.kindOf(appendStr, requestFor: .FAVORITE_STATIONS, request: Req(), response: FavoriteStations.self) {[weak self] (results) in
            self?.hideLoader()
            if let res = results,let success = res.success,let msg =  res.message, let resultFav = res.result, msg == "Ok" && success == true  {
                 if  resultFav.contains(","){
                     let favStnId = resultFav.components(separatedBy: ",")
                     let intStnArray = favStnId.map { Int($0)!}
                     let favLoca = self?.stationLocation.filter({intStnArray.contains($0.stationID!)})
                     Defaults.shared.favoriteStation = favLoca ?? []
                 }else{
                     let favStnId = resultFav
                     let favLoca = self?.stationLocation.filter({$0.stationID == Int(favStnId)})
                     Defaults.shared.favoriteStation = favLoca ?? []
                 }
                DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "\(stationName) added to favorite station")
                }
            }else{
                DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "There is some probelm to adding!!")
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

}
