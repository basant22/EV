//
//  StrartChargingViewController.swift
//  V-Power
//
//  Created by apple on 09/10/21.
//

import UIKit

class StrartChargingVC: UIViewController {
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var view2:UIView!
    @IBOutlet weak var view3:UIView!
    @IBOutlet weak var view4:UIView!
    @IBOutlet weak var view5:UIView!
    @IBOutlet weak var view6:UIView!
    @IBOutlet weak var view7:UIView!
    @IBOutlet weak var view8:UIView!
    @IBOutlet weak var lblStatusOfCharger:UILabel!
    @IBOutlet weak var viewDetails:UIView!
    @IBOutlet weak var lblBookingId:UILabel!
    @IBOutlet weak var lblStartTime:UILabel!
    @IBOutlet weak var lblDuration:UILabel!
    @IBOutlet weak var lblRate_Of_Charging:UILabel!
    @IBOutlet weak var lblUnits_Consumed:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lblLoadOfUnit:UILabel!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var btnBack:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    @IBOutlet weak var viewProgress:UIView!
    @IBOutlet weak var viewImage:UIView!
    @IBOutlet weak var btnStart:UIButton!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var imgConnect:UIImageView!
    @IBOutlet weak var progress:UIProgressView!
   
    var bookingType = BookingType.General
    var resultCharger:ResultCharger?
    var selectedStation : SelectedChargerAndPort?
    var bookingResult : ResultChargerBooking!
    var resultBooing: ResultBookingStatus?
   // var pricePerUnit:Int = 0
    var timeDuration = ("","","")
    var startTime = ""
    var status = ""
    var bookingId = 0
//    var hours = 0
//    var minutes = 0
//    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timerD :Timer!
    //var countRunningStatus = 0
    var timer:Timer!
   // var timerHiding:Timer!
    var duration = (0,0,0)
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        navigation.barTintColor = Theme.menuHeaderColor
        setImageOnConnected(imageName: "Discon")
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Charging Status"
        }
        switch bookingType {
        case .Active:
            if let vc = self.revealViewController().frontViewController as? Self{
                self.bookingType =  vc.bookingType
                self.bookingResult = vc.bookingResult
            }
            if self.revealViewController() != nil{
                self.btnBack.target = self.revealViewController()
                self.btnBack.action = #selector(SWRevealViewController.revealToggle(_:))
                self.btnBack.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
           // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                  }
        case .General:
            self.btnBack.action = #selector(back(_:))
        }
     
        // Do any additional setup after loading the view.
       // if let startTime = bookingResult.startTime,let stopTime = bookingResult.stopTime {
           // self.timeDuration = startTime.dateWithTime(stop:stopTime)
         //   let arrTime:[String] = startTime.getTimeFromDate().components(separatedBy: ":")
           
          // let hh = startTime.convertDateFormat()
           
           
       // }
        setTheme()
        self.counter = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progress.progress = 0.0
        self.progress.tintColor = .white
        
       
        switch bookingType {
        case .Active:
            if let startTime = self.bookingResult.startTime{
                self.startTime = startTime.getTimeFromDate()
                self.setChargerDetails()
              }
            manageAndReqCharger()
        case .General:
            self.btnBack.action = #selector(back(_:))
            if self.bookingId != 0 {
                getBookingInfo(bookingId:self.bookingId)
            }else{
                if let startTime = self.bookingResult.startTime{
                    self.startTime = startTime.getTimeFromDate()
                    self.setChargerDetails()
                  }
            }
        }
    }
    func titleToStart(){
        DispatchQueue.main.async{
        self.btnStart.setTitle(Theme.Start_Charging, for: .normal)
        self.btnStart.setTitleColor(.white, for: .normal)
        self.btnStart.layer.borderWidth = 2.0
        self.btnStart.layer.borderColor = UIColor.white.cgColor
        self.btnStart.backgroundColor = Theme.menuHeaderColor
        self.btnStart.cornerRadius(with: 6.0)
        }
    }
    func titleToStop(SetTitle:String){
        DispatchQueue.main.async{
            self.btnStart.setTitle(SetTitle, for: .normal)
            self.btnStart.setTitleColor(UIColor.red, for: .normal)
            self.btnStart.layer.borderWidth = 2.0
            self.btnStart.layer.borderColor = UIColor.red.cgColor
            self.btnStart.backgroundColor = Theme.menuHeaderColor
            self.btnStart.cornerRadius(with: 6.0)
        }
    }
    
    func setImageOnConnected(imageName:String){
        let img = UIImage(named: imageName)
        self.imgConnect.image = img
    }
    func manageAndReqCharger(){
        if let status = self.bookingResult.status,status == "R"{
            // self.btnBack.isEnabled = false
            
           // titleToStop(SetTitle: Theme.Stop_Charging)
          
                self.callWhenChargerIsStarted()
           // callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Start_Transaction, title: Theme.Stop_Charging)
        }else if let status = self.bookingResult.status,status == "S"{
            titleToStart()
        }else if let status = self.bookingResult.status,status == "C"{
            DispatchQueue.main.async{
            self.btnStart.setTitle(Theme.Stop_Charging, for: .normal)
            self.btnStart.isUserInteractionEnabled = false
            }
           // callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Start_Transaction, title: "Stop")
        }else if let status = self.bookingResult.status,let dttime = self.bookingResult.bookTime ,status == "B"{
            let date = dttime.toDate()
            if Date() == date{
                callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Start_Transaction, title: Theme.Stop_Charging)
            }
        }
    }
    
    fileprivate func setTheme(){
        viewProgress.layer.borderWidth = 2.0
        viewProgress.layer.borderColor = Theme.menuHeaderColor.cgColor
       // viewProgress.backgroundColor = Theme.menuHeaderColor
      //  btnStart.backgroundColor = Theme.menuHeaderColor
        view1.cornerRadius(with: 6.0)
        view2.cornerRadius(with: 6.0)
        view3.cornerRadius(with: 6.0)
        view4.cornerRadius(with: 6.0)
        view5.cornerRadius(with: 6.0)
        view6.cornerRadius(with: 6.0)
        view7.cornerRadius(with: 6.0)
        view8.cornerRadius(with: 6.0)
        titleToStart()
        
       // btnStart.backgroundColor = Theme.menuHeaderColor
       // btnStart.setTitleColor(.white, for: .normal)
       
        
        viewImage.backgroundColor = Theme.menuHeaderColor
        viewProgress.cornerRadius(with: 6.0)
        viewImage.cornerRadius(with: viewImage.bounds.height/2)
        img.image = #imageLiteral(resourceName: "My Vehicle").tint(with: .white)
        if #available(iOS 13.0, *) {
            btnStart.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 19.0, weight: .medium)
        } else {
            // Fallback on earlier versions
            btnStart.titleLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
        }
    }
    func startStatusTimer()
    {
      if timer == nil {
          self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.getStatusWhileChargingVehicle), userInfo: nil, repeats: true)
      }
    }

    func stopStatusTimer(completion:(()->())? = nil){
      if timer != nil {
        timer!.invalidate()
        timer = nil
      }
        completion?()
    }
    func stopDurationTimer(completion:(()->())? = nil){
      if timerD != nil {
        timerD.invalidate()
        timerD = nil
      }
        completion?()
    }
    func callWhenChargerIsStarted(){
       
        DispatchQueue.main.async {
            self.getStatusWhileChargingVehicle()
//            Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { [weak self] _ in
//                self?.getStatusWhileChargingVehicle()
//            })
            self.startStatusTimer()
            if MyGlobalTimer.sharedTimer.duration.2 == 0 {
                MyGlobalTimer.sharedTimer.startTimer()
            }else{
                self.duration = MyGlobalTimer.sharedTimer.duration
                self.counter = MyGlobalTimer.sharedTimer.counter
            }
            self.countDuration()
        }
    }
    
    func getBookingInfo(bookingId:Int){
        let req = ApiGetRequest()
            req.kindOf(Theme.ChargerBookingDetail, requestFor: .BOOKING_INFO, queryString: [String(bookingId)], response: ChargerBookingResponse.self) {[weak self] respons in
                if let res = respons,let success = res.success,let msg = res.message,success == true,msg == Theme.Message{
                    if let result = res.result{
                        self?.bookingResult = result
                        if let startTime = self?.bookingResult.startTime{
                            self?.startTime = startTime.getTimeFromDate()
                            self?.setChargerDetails()
                          }
                          self?.manageAndReqCharger()
                    }else{
                       
                    }
                }
            }
    }
    func calculateGST(gst:Int,amount:Double)->Double{
        var amt = Double(gst)*amount
        amt = amt/100
        return amt
    }
    func calculateAmountWithGST(gst:Double,amount:Double)->Double{
        var amt = gst*amount
        amt = amt/100
        amt = amt + amount
        return amt
    }
    
   
    func setChargerDetails(){
        DispatchQueue.main.async{
            if let bookingId = self.bookingResult.bookingID {
                self.lblBookingId.text = Theme.Booking_Id + String(bookingId)
         }
            self.lblStartTime.text = Theme.Start_Time + self.startTime
        //+ self.startTime
        //" Start Time: " + startTime.0 + ":" + startTime.1 + ":" + startTime.2
            self.lblDuration.text = Theme.Duration
        //+ timeDuration.0 + ":" + timeDuration.1 + ":" + timeDuration.2
           // let price = String(self.pricePerUnit)
            if let pricing = self.bookingResult.pricing,let tx = self.bookingResult.taxes  {
                let value = self.calculateAmountWithGST(gst: tx, amount: pricing)
                self.lblRate_Of_Charging.text = Theme.Rate_Of_Charging + Theme.INRSign + String(format:"%.02f",value )
               // println(String(format:"%.02f", b))
            }else{
                self.lblRate_Of_Charging.text = Theme.Rate_Of_Charging
            }
            //+ price.currencified + "kwh"
            self.lblUnits_Consumed.text = Theme.Units_Consumed + " 0.0"
        //+ price.currencified
            self.lblAmount.text = Theme.Amount
            
            self.lblStatusOfCharger.text = Theme.Charging_Status
            self.lblLoadOfUnit.text = Theme.Load 
          //  price.currencified
        }
    }
    
    @objc func back(_ sender:UIBarButtonItem){
        self.stopStatusTimer()
        self.stopDurationTimer()
        DispatchQueue.main.async {
            self.progress.progress = (self.progress.progress)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func hideButtonForAMinute(){
        DispatchQueue.main.async{
        self.btnStart.isHidden = true
        }
    
    }
    @objc func showButtonAfterAMinute(){
        DispatchQueue.main.async{
            self.btnStart.isHidden = false
        }
    }
    /*
    func startTimer()
    {
        timerD = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
   @objc func updateTimer(){
       if seconds == 1 {
           seconds = 60
       }
       if minutes == 60 {
           minutes = 0
       }
        seconds -= 1
        DispatchQueue.main.async {
            self.lblDuration.text = Theme.Duration + self.timeString(time: TimeInterval(self.seconds))
        }
    }
    func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return  String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }*/
    
    @IBAction func btnStart(_ sender:UIButton){
       // self.performSegue(withIdentifier: "Payment", sender: nil)
        if btnStart.titleLabel?.text == Theme.Start_Charging {
            self.changeTitleAndTarget(title: Theme.Stop_Charging)
        }else if btnStart.titleLabel?.text == "Cancel Booking" {
            self.performSegue(withIdentifier: "Cancel", sender: nil)
        }else if btnStart.titleLabel?.text == "Payment Detail" {
            if let result = resultBooing {
                self.goToStartPayment(result:result)
            }
        }else{
            changeTitleAndTarget(title: Theme.Start_Charging)
        }
    }
    func cancelBooking() {
      
        if let bookingId = self.bookingResult.bookingID {
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.ChangeBookingStatus, requestFor: .CHANGE_BOOKING_STATUS, queryString: [String(bookingId)], response: CancelBooking.self) {[weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ = res.message, let success = res.success,success == true{
                self?.btnBack.isEnabled = true
                Defaults.shared.isBookingCancell = true
            
                Defaults.shared.bookingType = .General
                if self?.timer != nil {
                    self?.timer.invalidate()
                    self?.timer = nil
                }
                MyGlobalTimer.sharedTimer.stopTimer()
                if self?.timerD != nil {
                    self?.timerD.invalidate()
                    self?.timerD = nil
                }
                DispatchQueue.main.async {
                    self?.titleToStop(SetTitle: "Cancelled Successfully")
                }
            }else{
                DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Unable to delete this booking")
                }
            }
        }
    }
    }
    func changeTitleAndTarget(title:String)  {
        if title == Theme.Start_Charging  {
            switch bookingType {
            case .Active:
                callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Stop_Transaction, title: title)
            case .General:
                if selectedStation == nil {
                    callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Stop_Transaction, title: title)
                }else{
                    callForStartCharging(status: Theme.Stop_Transaction,title:title)
                }
                
            }
        }else{
            switch bookingType {
            case .Active:
                callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Start_Transaction, title: title)
            case .General:
                if selectedStation == nil {
                    callFor_StartCharging_OnActiveBooking(result: self.bookingResult, status: Theme.Start_Transaction, title: title)
                }else{
                    callForStartCharging(status: Theme.Start_Transaction,title:title)
                }
               
            }
        }
    }
    func startOrStopCharging(req:StartChargingRequest,status:String,title:String){
        let res = StartChargingResource()
        self.showLoader()
        res.startCharging(request: req, connector:Theme.BookCharger, controller: self) {[weak self] respons in
            if let  res = respons,let _ = res.message,let succes = res.success{
                self?.hideLoader()
                if status == Theme.Start_Transaction && succes == true  {
                    DispatchQueue.main.async {
                        self?.titleToStop(SetTitle:Theme.Stop_Charging)
                        MyGlobalTimer.sharedTimer.startTimer()
                        self?.countDuration {
                        self?.getStatusWhileChargingVehicle()
                        }
//                        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { [weak self] _ in
//                            self?.getStatusWhileChargingVehicle()
//                        })
                        if let self = self{
                            self.startStatusTimer()
                        }
                    }
                }else if status == Theme.Stop_Transaction && succes == true{
                    if self?.timer != nil {
                        self?.timer.invalidate()
                        self?.timer = nil
                    }
                    MyGlobalTimer.sharedTimer.stopTimer()
                    if self?.timerD != nil {
                        self?.timerD.invalidate()
                        self?.timerD = nil
                    }
                   
                    Defaults.shared.bookingType = .General
                    DispatchQueue.main.async {
                       // self?.btnStart.isUserInteractionEnabled = false
                       
//                        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self?.getStatusWhileChargingVehicle), userInfo: nil, repeats: false)
                       // self?.getStatusWhileChargingVehicle()
                      // self?.progress.progress = (self?.progress.progress)!
                      //  self?.displayAlert(alertMessage: "Charging has been stopped")
                    }
                    let seconds = 3.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self?.getStatusWhileChargingVehicle()
                    }
                   
                }else if status == Theme.Start_Transaction && succes == false {
                    DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: Theme.Charger_Not_Started)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    if status == Theme.Start_Transaction{
                        self?.titleToStop(SetTitle:Theme.Stop_Charging)
                    }else if status == Theme.Stop_Transaction{
                        self?.titleToStart()
                    }
                self?.hideLoader()
                }
            }
        }
    }
    func callFor_StartCharging_OnActiveBooking(result:ResultChargerBooking ,status:String,title:String) {
        if let chargerId = result.chargerName,let portNumber = result.chargingpoint{
            let validate = validateStartChargingRequest()
            let req = StartChargingRequest(chargingpoint:String(portNumber), fromStatus: Theme.AVAILABLE, deviceId: chargerId, requestStatus: status)
            let result =  validate.validate(request: req)
              if result.success {
                  self.startOrStopCharging(req: req, status: status, title: title)
              }else{
                  DispatchQueue.main.async{
                  self.displayAlert(alertMessage: result.errorMessage!)
                  }
              }
        }
    }
    func callForStartCharging(status:String,title:String) {
        if let charger =  selectedStation?.charger,let chargerId = charger.chargerName,let portNumber = selectedStation?.chargingpoint{
            let validate = validateStartChargingRequest()
            let req = StartChargingRequest(chargingpoint:String(portNumber), fromStatus: Theme.AVAILABLE, deviceId: chargerId, requestStatus: status)
          let result =  validate.validate(request: req)
            if result.success {
                self.startOrStopCharging(req: req, status: status, title: title)
            }else{
                self.displayAlert(alertMessage: result.errorMessage!)
            }
        }
    }
    
    func countDuration(completion:(()->())? = nil){
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
//            self?.updateCounter()
//        })
        self.timerD = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        completion?()
    }
    @objc func updateCounter() {
        if counter < 60 {
           // print("\(counter) seconds to the end of the world")
            DispatchQueue.main.async {
                self.lblDuration.text = "Duration: " + "\(self.duration.0)h : \(self.duration.1)m : \(self.counter)s"
            }
            counter += 1
            self.duration.2 = counter
            if self.duration.2 == 60 {
                self.duration.1 = 1 + self.duration.1
                self.counter = 0
            }
            if self.duration.1 == 60 {
                self.duration.0 = 1 + self.duration.0
                self.duration.1 = 0
            }
        }
    }
    
    func handleProgressBar(){
        DispatchQueue.main.async{
        self.progress.progress += 0.01
        }
    }
    @objc func getStatusWhileChargingVehicle() {
      //  let res = AfterStartChargingResource()
        if let bookingID = bookingResult.bookingID {
            let bookId = String(bookingID)
            handleProgressBar()
            ApiGetRequest().kindOf(Theme.ChargerStatus, requestFor: .CHANGE_CHARGER_STATUS, queryString: [bookId], response: BookingStatus.self) {[weak self] (respons)  in
                if let res = respons,let result = res.result,let status = result.status ,let msg = res.message,let _ = res.success{
                    if msg == "Ok"  {
                        if result.chargingstatus == "I"{
                            self?.titleToStop(SetTitle:"Cancel Booking")
                        }else  if result.chargingstatus == "R"{
                            self?.titleToStop(SetTitle:Theme.Stop_Charging)
                        }
                        if status == "C" {
                        DispatchQueue.main.async {
                            self?.resultBooing = result
                            self?.btnBack.isEnabled = true
                            self?.bookingType = .General
                            Defaults.shared.bookingType = .General
                            self?.status = status
                            if self?.timer != nil {
                                self?.timer.invalidate()
                                self?.timer = nil
                            }
                            MyGlobalTimer.sharedTimer.stopTimer()
                            if self?.timerD != nil {
                                self?.timerD.invalidate()
                                self?.timerD = nil
                            }
                            self?.progress.progress = 1.0
                            }
                            self?.titleToStop(SetTitle:"Payment Detail")
                        }else if status == "F" {
                            self?.btnBack.isEnabled = true
                            self?.bookingType = .General
                            self?.status = status
                            if self?.timer != nil {
                                self?.timer.invalidate()
                                self?.timer = nil
                            }
                            MyGlobalTimer.sharedTimer.stopTimer()
                            if self?.timerD != nil {
                                self?.timerD.invalidate()
                                self?.timerD = nil
                            }
                        }
                        else if status == "R" {
                                DispatchQueue.main.async {
                                    if let conn = result.eVConnected {
                                        if conn == 0 {
                                            self?.setImageOnConnected(imageName: "Discon")
                                        }else{
                                            self?.setImageOnConnected(imageName: "Conn")
                                        }
                                    }
                                    if let startTime = result.startTime{
                                        self?.lblStartTime.text = Theme.Start_Time +  startTime.getTimeFromDate()
                                    }
                                    if let unitConsumed = result.unit{
                                        self?.lblUnits_Consumed.text = Theme.Units_Consumed + String(unitConsumed)
                                    }
                                    if let amount = result.amount{
                                    let amn = String(format:"%.02f",amount )
                                        self?.lblAmount.text = Theme.Amount + Theme.INRSign + amn
                                    }
                                    if let load = result.load{
                                    self?.lblLoadOfUnit.text = Theme.Load + String(load) + " kW"
                                    }
                                    if let roc = result.price,let unit = result.priceBy{
                                        self?.lblRate_Of_Charging.text = Theme.Rate_Of_Charging +  String(format:"%.02f",roc ) + unit.concatenateUnit()
                                    }
                                    if let status = result.chargingstatus{
                                    switch status {
                                    case "I":
                                        self?.lblStatusOfCharger.text = Theme.Charging_Status + Theme.Initialising
                                        self?.btnBack.isEnabled = true
                                    case "R":
                                        self?.lblStatusOfCharger.text = Theme.Charging_Status + Theme.Charging
                                        self?.btnBack.isEnabled = false
                                    case "E":
                                        self?.lblStatusOfCharger.text = Theme.Charging_Status + Theme.Error_in_charging
                                        self?.btnBack.isEnabled = true
                                    default:
                                        print("")
                                    }
                                    }
                                }
//                                    if self?.countRunningStatus == 1 {
//                                        if let ressult = self?.bookingResult,let  chargerStatus = ressult.status,chargerStatus == "S" {
//                                            self?.hideButtonForAMinute()
//                                            if let self = self{
//                                                self.timerHiding = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.showButtonAfterAMinute), userInfo: nil, repeats: false)
//                                            }
//                                        }
//                                    }
                                //}
                            }
                        }
                    }
                }
            }
        
         /*   res.getStatusWhileCharging(connector: Theme.ChargerStatus, bookingId: bookId) {[weak self] respons in
                if let res = respons,let result = res.result,let status = result.status  ,let msg = res.message,let _ = res.success{
                    if msg == "Ok"  {
                        if status == "C" {
                            self?.btnBack.isEnabled = true
                            self?.bookingType = .General
                            self?.status = status
                            if self?.timer != nil {
                                self?.timer.invalidate()
                            }
                            DispatchQueue.main.async {
                                self?.progress.progress = 1.0
                                self?.goToStartPayment(result:result)
                               // self?.performSegue(withIdentifier: "Payment", sender: result)
                               // self?.displayAlert(alertMessage: "Charger has been Stopeed")
                            }
                        }else if status == "R" {
                           
                            self?.countRunningStatus += 1
                            if let startTime = result.startTime,let unitConsumed = result.unit,let amount = result.amount,let roc = result.price,let status = result.chargingstatus{
                                //,let load = result.load
                                DispatchQueue.main.async {
                                    self?.lblStartTime.text = Theme.Start_Time +  startTime.getTimeFromDate()
                                    self?.lblUnits_Consumed.text = Theme.Units_Consumed + String(unitConsumed)
                                    let amn = String(amount)
                                    self?.lblLoadOfUnit.text = Theme.Load
                                    //+ String(load)
                                    self?.lblAmount.text = Theme.Amount + Theme.INRSign + amn
                                    self?.lblRate_Of_Charging.text = Theme.Rate_Of_Charging + Theme.INRSign  + String(roc)
                                    switch status {
                                    case "I":
                                        self?.lblStatusOfCharger.text = Theme.Charging_Status + Theme.Initialising
                                        self?.btnBack.isEnabled = true
                                        
                                    case "R":
                                        self?.lblStatusOfCharger.text = Theme.Charging_Status + Theme.Charging
                                        self?.btnBack.isEnabled = false
                                         
                                    case "E":
                                        self?.lblStatusOfCharger.text = Theme.Charging_Status + Theme.Error_in_charging
                                        self?.btnBack.isEnabled = true
                                    default:
                                        print("")
                                    }
                                }
//                                    if self?.countRunningStatus == 1 {
//                                        if let ressult = self?.bookingResult,let  chargerStatus = ressult.status,chargerStatus == "S" {
//                                            self?.hideButtonForAMinute()
//                                            if let self = self{
//                                                self.timerHiding = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.showButtonAfterAMinute), userInfo: nil, repeats: false)
//                                            }
//                                        }
//                                    }
                                //}
                            }
                        }
                    }
                }
            }*/
        }
    
    fileprivate func goToStartPayment(result:ResultBookingStatus){
         let paymentSY = UIStoryboard(name: "StartCharging", bundle: nil)
         let menuSy = UIStoryboard(name: "Home", bundle: nil)
         if let front = paymentSY.instantiateViewController(withIdentifier: "PaymentDetailVC") as? PaymentDetailVC{
             front.booking = result
             let rear = menuSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
             if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
                 self.navigationController?.pushViewController(swRevealVC, animated: true)
             }
         }
     }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Cancel"{
            if let vc = segue.destination as? CancelMsgVC {
                vc.confirmCancel = { [weak self] (contrl) in
                    contrl.dismiss(animated: true) {
                        self?.cancelBooking()
                    }
                }
            }
        }
    }
    
    deinit {
        print("\(self) id deinitialized")
    }
}
