//
//  ConfirmBookingViewController.swift
//  V-Power
//
//  Created by apple on 09/10/21.
//

import UIKit
import Kingfisher
class ConfirmBookingVC: UIViewController {
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var view2:UIView!
    @IBOutlet weak var view3:UIView!
    @IBOutlet weak var viewAddress:UIView!
    @IBOutlet weak var viewStation:UIView!
    @IBOutlet weak var viewBalance:UIView!
    @IBOutlet weak var viewBtn:UIView!
    @IBOutlet weak var imgPlug:UIImageView!
    @IBOutlet weak var lblChargerType:UILabel!
    @IBOutlet weak var lblPortNumber:UILabel!
    @IBOutlet weak var lblStationName:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var lblKW:UILabel!
    @IBOutlet weak var lblAvailableTitle:UILabel!
    @IBOutlet weak var lblAvailableBalance:UILabel!
   
    @IBOutlet weak var lblPricePerUnit:UILabel!
    @IBOutlet weak var btnChargeNow:UIButton!
    @IBOutlet weak var btnEstimate:UIButton!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var btnBack:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    @IBOutlet weak var lblHeadingChargerType:UILabel!
    @IBOutlet weak var lblHeadingCapicity:UILabel!
    
    @IBOutlet weak var btnLocate:UIButton!
    var logedIn:LogedInManager!
    var latValue = 0.0
    var longValue = 0.0
    var bookingBy:BookingBy!
    var resultCharger:ResultCharger?
    var selectedStation : SelectedChargerAndPort?
   // var priceperUnit:Int!
    var userBalance = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        logedIn = LogedInManager()
        // Do any additional setup after loading the view.
        latValue = Defaults.shared.userLocation["lat"] ?? 0.0
        longValue = Defaults.shared.userLocation["long"] ?? 0.0
        self.navigation.barTintColor = Theme.menuHeaderColor
        btnBack.action = #selector(back(_:))
        self.navigationController?.isNavigationBarHidden = true
        setTheme()
    }
    fileprivate func setTheme(){
        if #available(iOS 13.0, *) {
            viewContainer.backgroundColor = UIColor.systemGray6
        } else {
            // Fallback on earlier versions
            viewContainer.backgroundColor = .lightGray
        }
        view1.backgroundColor = Theme.newGreen
        view2.backgroundColor = Theme.newGreen
        view3.backgroundColor = Theme.newGreen
        viewStation.backgroundColor = Theme.menuHeaderColor
        viewAddress.backgroundColor = Theme.menuHeaderColor
        viewBalance.backgroundColor = Theme.menuHeaderColor
        viewBtn.backgroundColor = Theme.menuHeaderColor
        lblAddress.textColor = .white
        lblPricePerUnit.textColor = .white
        lblAvailableBalance.textColor = .white
        lblStationName.textColor = .white
        lblChargerType.textColor = .white
        lblPortNumber.textColor = .white
        lblKW.textColor = .white
      //  imgPlug.image = #imageLiteral(resourceName: "LoginHeaderImage")
        
        view1.cornerRadius(with: 6.0)
        view2.cornerRadius(with: 6.0)
        view3.cornerRadius(with: 6.0)
        
        viewStation.cornerRadius(with: 6.0)
        viewBalance.cornerRadius(with: 6.0)
        viewAddress.cornerRadius(with: 6.0)
        
        btnEstimate.cornerRadius(with: 6.0)
        btnChargeNow.cornerRadius(with: 6.0)
        
        btnEstimate.backgroundColor = Theme.newGreen
        btnChargeNow.backgroundColor = Theme.newGreen
        
        btnEstimate.setTitleColor(.white, for: .normal)
        btnChargeNow.setTitleColor(.white, for: .normal)
        
        lblHeadingChargerType.textColor = .white
        lblHeadingCapicity.textColor = .white
       
        btnChargeNow.setTitle("Book Now", for: .normal)
        btnChargeNow.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        btnEstimate.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        if let station = selectedStation,let _ = station.station{
            let img = UIImage(systemName: "location")
            self.btnLocate.setImage(img?.tint(with: .white), for: .normal)
            self.btnLocate.backgroundColor = Theme.menuHeaderColor
            self.btnLocate.addTarget(self, action: #selector(openInGoogleMapForDirection), for: .touchUpInside)
            self.btnLocate.isHidden = false
        }else{
            self.btnLocate.isHidden = true
        }
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Book Your Charger"
        }
        setPagedetail()
    }
    
    fileprivate func setPagedetail(){
        if let usrProfile = Defaults.shared.usrProfile,let balanceamount = usrProfile.balanceamount {
            lblAvailableBalance.text =  Theme.INRSign + " " + String(format:"%.02f",balanceamount)
        }else{
            lblAvailableBalance.text =  Theme.INRSign + " " + "0.00"
        }
        if let  selectedStation = self.selectedStation,let charger = selectedStation.charger,let station = selectedStation.station,let chargingpoint = selectedStation.chargingpoint {
            lblChargerType.text = charger.chargerType
            lblPortNumber.text = "Port \(String(describing: chargingpoint))"
            lblKW.text = charger.outputType
            self.setStationImage(imgUrl: station.icon ?? "")
            if let capicity = charger.chargerCapacity {
                lblStationName.text =  station.stationname
                lblKW.text = String(capicity) + "KW"
                lblAddress.text = station.address
                if let price = charger.price{
                    let chargerPrice = String(price)
                    //self.priceperUnit = Int(price)
                lblPricePerUnit.text = chargerPrice.currencified + "/kwh"
                }else{
                    lblPricePerUnit.text = "N/A"
                }
            }
        }else{
            if let chargerData = resultCharger,let seleStation = selectedStation?.stationByQr{
                lblAddress.text = seleStation.stationAddress ?? "N/A"
                lblStationName.text = seleStation.stationName ?? "N/A"
                lblChargerType.text = chargerData.chargerType ?? "N/A"
                self.setStationImage(imgUrl: seleStation.icon ?? "")
                if let capicity = chargerData.chargerCapacity {
                lblKW.text =  String(capicity) + " KW"
                }
                 
                if let price = chargerData.price{
                    let chargerPrice = String(price)
                lblPricePerUnit.text = chargerPrice.currencified + "/kwh"
                }
                if let portData = chargerData.chargerPort,let portseq = portData.first,let  numSeq = portseq.seqNumber{
              //  if let portseq = chargerData.chargerPort.first,let numSeq = portseq.seqNumber{
                    lblPortNumber.text = "Port-" + String(numSeq)
                }
            }else{
                lblAddress.text = "N/A"
                lblChargerType.text = "N/A"
                lblPortNumber.text = "N/A"
                lblKW.text = "N/A"
                lblStationName.text =  "Station Name"
                lblPricePerUnit.text = "N/A"
            }
        }
    }
    func setStationImage(imgUrl:String){
        let url = URL(string:imgUrl)
        //"https://example.com/high_resolution_image.png")
        let processor = DownsamplingImageProcessor(size: imgPlug.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 8)
        imgPlug.kf.indicatorType = .activity
        imgPlug.kf.setImage(
            with: url,
            placeholder: UIImage(named: "LoginHeaderImage")?.tint(with: .white),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
     @objc func openInGoogleMapForDirection(){
         if let station = selectedStation,let sele = station.station,let lat = sele.lattitude,let long = sele.longitude {
             
         //if let latt = stationDetail?.lattitude,let long = stationDetail?.longitude {
             if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                 if let url = URL(string: "comgooglemaps-x-callback://?saddr\(self.latValue ),\(self.longValue)=&daddr=\(lat),\(long)&directionsmode=driving") {
                     UIApplication.shared.open(url, options: [:])
                 }}
             else {
                 //Open in browser
                 if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr\(self.latValue ),\(self.longValue)=&daddr=\(lat),\(long)&directionsmode=driving") {
                     UIApplication.shared.open(urlDestination)
                 }
             }
         }
     }
   func sendBookingRequest() {
  // userEVId: nil, chargingpoint: nil, chargerName: "", username: ""
       // var request = ChargerBookingRequest(userEVId: nil, chargingpoint: nil, duration: nil, chargerName: nil, username: nil, start_time: nil, scheduleId: nil, status:nil)
       var request = ChargerBookingRequest(requested_stop_duration: nil,requested_stop_time: nil,userEVId: nil, chargingpoint: nil, requested_stop_soc: nil,  chargerName: nil, username: nil, start_time: nil, scheduleId: nil, status: nil, bookedvia: nil, stopchargingby: nil, requested_stop_unit: nil)
       if let  selectedStation = self.selectedStation {
           if selectedStation.bookedUsing == "Duration" {
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId ,let durat = selectedStation.duration {
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.requested_stop_duration = durat
                       request.bookedvia = "A"
                   }
           }else if selectedStation.bookedUsing == "Slot"{
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId ,let sTime = selectedStation.dateTime,let slot = selectedStation.selectedSlots,let stopTime = selectedStation.stopTime  {
                   let schel = (slot.map{String($0)}).joined(separator: ",")
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.start_time = sTime
                       request.requested_stop_time = stopTime
                       request.scheduleId = schel
                       request.status = "B"
                       request.bookedvia = "A"
                       request.stopchargingby = "M"
                   }
           }else if selectedStation.bookedUsing == "QR"{
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId {
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.bookedvia = "Q"
                   }
           }else if selectedStation.bookedUsing == "UNIT" {
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId ,let reqUnit = selectedStation.tas  {
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.requested_stop_unit = Double(reqUnit)
                       request.bookedvia = "A"
                       request.status = "S"
                       request.stopchargingby = "U"
               }
           }else if selectedStation.bookedUsing == "TIME" {
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId ,let time = selectedStation.tas {
                   //,let sTime = selectedStation.dateTime
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.bookedvia = "A"
                       request.status = "S"
                       request.requested_stop_duration = time*60
                       request.stopchargingby = "M"
                       //request.start_time = sTime
                   }
           }else if selectedStation.bookedUsing == "AMOUNT" {
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId ,let reqUnit = selectedStation.unit {
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.requested_stop_unit = reqUnit
                       request.bookedvia = "A"
                       request.status = "S"
                       request.stopchargingby = "A"
                   }
           }else if selectedStation.bookedUsing == "SOC" {
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId ,let soc = selectedStation.tas {
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                       request.requested_stop_soc = soc
                       request.bookedvia = "A"
                   request.status = "S"
                   request.stopchargingby = "S"
                   }
           }
           else{
               if let  selectedStation = self.selectedStation,let charger = selectedStation.charger, let chargerName =  charger.chargerName,let chargingpoint = selectedStation.chargingpoint, let userName = Defaults.shared.userLogin?.username,let userEVId = selectedStation.userEvId {
                       request.chargerName = chargerName
                       request.chargingpoint =  chargingpoint
                       request.username = userName
                       request.userEVId = Int(userEVId)
                   }
                }
             }
   
       let booking = validateBookingRequest()
    let result = booking.validate(data: request)
    if result.success {
        self.showLoader()
        let req = ApiPostRequest()
        req.kindOf(Theme.ChargerBooking, requestFor: .CHARGER_BOOKING, request: request, response: ChargerBookingResponse.self) {[weak self] result in
            self?.hideLoader()
            if let resp = result,let resultCharger = resp.result, let msg = resp.message,let success = resp.success {
                if msg == Theme.Booking_Already_Exist || success == true{
                    DispatchQueue.main.async {
                        self?.goToStartCharging(result:resultCharger)
                       // self?.performSegue(withIdentifier: "Start", sender: resultCharger)
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: Theme.msgBooking)
                    }
                }
            }else{
                
                if let resp = result, let msg = resp.message{
                    let showMsg:String  =  msg == Theme.AlreadyExists ? Theme.Booking_Already_Exist_Msg:""
                    DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: showMsg)
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: Theme.Something_went_wrong)
                    }
                }
            }
        }/*
        let resources = BookingResource()
        resources.chargerBooking(request: request, connector: "booking", controller: self) { (response) in
            self.hideLoader()
            if let resp = response,let resultCharger = resp.result, let msg = resp.message{
               // && msg != "Booking Already Exist"
                if resultCharger.status == "S" || resultCharger.status == "R" {
                    DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Start", sender: resultCharger)
                    }
                }else{
                    let showMsg:String  =  msg == "AlreadyExists" ? "Booking Already Exist":""
                    DispatchQueue.main.async {
                        self.displayAlert(alertMessage: showMsg)
                    }
                }
            }else{
                
                if let resp = response, let msg = resp.message{
                    let showMsg:String  =  msg == "AlreadyExists" ? "Booking Already Exist":""
                    DispatchQueue.main.async {
                    self.displayAlert(alertMessage: showMsg)
                    }
                }else{
                    DispatchQueue.main.async {
                    self.displayAlert(alertMessage: "Something went wrong")
                    }
                }
            }
        }*/
    }else{
        self.displayAlert(alertMessage: result.errorMessage!)
    }
    
    }
    fileprivate func goToStartCharging(result:ResultChargerBooking){
         let homeSy = UIStoryboard(name: "Home", bundle: nil)
         let bookSy = UIStoryboard(name: "Book", bundle: nil)
         if let front = bookSy.instantiateViewController(withIdentifier: "StrartChargingVC") as? StrartChargingVC{
             front.bookingType = .Active
             Defaults.shared.bookingType = .Active
             front.bookingResult = result
            // front.fromBookNow = true
             front.resultCharger = self.resultCharger
             front.selectedStation = self.selectedStation
             
             
             
             let rear = homeSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
             if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
                 self.navigationController?.pushViewController(swRevealVC, animated: true)
             }
         }
     }
   
    func openAddBalanceWindow(){
        let story = UIStoryboard(name: "Payment", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC{
            vc.usingFrom = "Booking"
            vc.donePayment = { [weak self] (done,amt,logout,control) in
                control.dismiss(animated: true) {
                    
                    DispatchQueue.main.async {
                        if logout == "refresh" {
                            self?.lblAvailableBalance.text = Theme.INRSign + String(format:"%.02f",amt)
                        }else{
                            if done && amt >= 10 {
                                self?.sendBookingRequest()
                            }else{
                                self?.lblAvailableBalance.text = Theme.INRSign + String(format:"%.02f",amt)
                                self?.displayAlert(alertMessage: "Amount must be grater than 10")
                            }
                        }
                    }
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    func prepareForBooking()  {
        if let prof = Defaults.shared.usrProfile{
            if let ub = prof.balanceamount{
                let bal = Int(ub)
                if bal < 10{
                    openAddBalanceWindow()
                }else{
                    sendBookingRequest()
                }
            }else{
                openAddBalanceWindow()
            }
        }else{
            sendBookingRequest()
        }
    }
    @IBAction func btnChargeNow_Action(_ sender:UIButton){
        switch self.bookingBy {
        case .General(let isBooking):
            if isBooking == true{
                prepareForBooking()
                }else{
                self.displayAlert(alertMessage: "Booking cant be proceed!")
            }
        case .QrCode(let isBooking):
            if isBooking == true{
                prepareForBooking()
            }else{
                self.displayAlert(alertMessage: "Booking cant be proceed!")
            }
        case .none:
            print("")
        }
        
       
        /*
        DispatchQueue.main.async {
        let paymentSy = UIStoryboard(name: "Payment", bundle: nil)
            if let vc = paymentSy.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC{
                Defaults.shared.paymentType = .Instant
        self.navigationController?.pushViewController(vc, animated: true)
        }
        }*/
       // self.performSegue(withIdentifier: "Payment", sender: nil)
    }
    @objc func back(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? StrartChargingVC,let booking = sender as? ResultChargerBooking{
            vc.bookingResult = booking
            //vc.pricePerUnit = self.priceperUnit
            vc.resultCharger = self.resultCharger
            vc.selectedStation = self.selectedStation
        }
    }
    deinit {
        print("\(self) id deinitialized")
    }
}
