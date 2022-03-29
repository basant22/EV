//
//  StationDetailViewController.swift
//  ChargePark
//
//  Created by apple on 22/09/21.
//

import UIKit

class StationDetailViewController: UIViewController {
   
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleBar: UIBarButtonItem!
    @IBOutlet weak var navigationCon: UINavigationBar!
    @IBOutlet weak var viewUpper: UIView!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var lblTab: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewTab: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnLocate: UIButton!
    var chargers : [ResultCharger] = []
    var dictUserLatLong:[String:Double]! = [:]
    var latValue = 0.0
    var longValue = 0.0
    var stationDetail:ResultStation?
    var bookingBy:BookingBy!
    var occoup1:[Int]?
    var occoup2:[Int]?
    var occoup3:[Int]?
    var slotInterval = 30
    var arrayOfTimeSlot : [(String,Bool,Bool,Int)] = []
    var arrayOfTimeSlotNext : [(String,Bool,Bool,Int)] = []
    var arrayOfTimeSlotNextDay : [(String,Bool,Bool,Int)] = []
    var timeSlotData:(ChargerPort,String,Int)!
    lazy var pickerTimeSlot: GMPicker = {
        let dPicker = GMPicker()
        return dPicker
    }()
    lazy var datePicker: GMDatePicker = {
        let dPicker = GMDatePicker()
        return dPicker
    }()
    
    private var isWaiting = false {
        didSet {
            self.updateUI()
        }
    }
    let group = DispatchGroup()
     // group.enter()
     // group.enter()
    override func viewDidLoad() {
        super.viewDidLoad()
        latValue = dictUserLatLong["lat"] ?? 0.0
        longValue = dictUserLatLong["long"] ?? 0.0
        self.pickerTimeSlot.delegate = self
        // Do any additional setup after loading the view.
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        tableView.registerNibs(nibNames: ["bookStationCell"])
        
        if let station = stationDetail {
            lblAddress.text = station.address
        }
        if let station = stationDetail {
            lblStationName.text = station.stationname
        }
        self.viewUpper.backgroundColor = .white
        self.btnCall.setImage(#imageLiteral(resourceName: "Mobile").tint(with: .white), for: .normal)
        //self.btnLocate.setImage(#imageLiteral(resourceName: "Map").tint(with: .white), for: .normal)
        self.btnCall.backgroundColor = Theme.menuHeaderColor
       // self.btnLocate.backgroundColor = Theme.menuHeaderColor
        self.btnCall.cornerRadius(with: 22.0)
        self.btnLocate.cornerRadius(with: 22.0)
        let img = UIImage(systemName: "location")
        self.btnLocate.setImage(img?.tint(with: .white), for: .normal)
        self.btnLocate.backgroundColor = Theme.menuHeaderColor
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Chargers Info"
        }
       /* lblTab.backgroundColor = .red
        viewTab.backgroundColor = .white
        btnInfo.backgroundColor = Theme.menuHeaderColor
        btnNavigate.backgroundColor = Theme.menuHeaderColor*/
        //btnInfo.cornerRadius(with: 4.0)
        //btnNavigate.cornerRadius(with: 4.0)
    }
    private func updateUI() {
        if self.isWaiting {
            let msg = "Getting Slots ..."
            self.showLoader(message: msg)
        } else {
            self.hideLoader {
            self.performSegue(withIdentifier: "TimeSlot", sender: nil)
            }
        }
      }
//    @IBAction func btnInfo(_ sender: UIButton) {
//        UIView.animate(withDuration: 3.0,delay: 0.77) {
//            self.leading.constant = 0
//        }
//
//    }
//    @IBAction func btnNavigation(_ sender: UIButton) {
//        UIView.animate(withDuration: 3.0,delay: 0.77) {
//            self.leading.constant = self.lblTab.bounds.width
//        }
//        openInGoogleMap()
//    }
    
    @IBAction func menuButton(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCall(_ sender: UIButton) {
        if let mobileNumber = stationDetail?.contact {
            if let url = URL(string: "tel://\(mobileNumber)"),
                   UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        }
    }
    @IBAction func btnLocate(_ sender: UIButton) {
        openInGoogleMap()
    }
   fileprivate func openInGoogleMap(){

        if let latt = stationDetail?.lattitude,let long = stationDetail?.longitude {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                if let url = URL(string: "comgooglemaps://?saddr\(latValue ),\(longValue)=&daddr=\(latt),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr\(latValue ),\(longValue))=&daddr=\(latt),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
    
    
    func setDataForUTASBooking(data:(String?,Int?,Double?),charger:ResultCharger,port:ChargerPort){
        var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "", tas: nil, unit: nil)
        if let via = data.0,let tas = data.1,let unit = data.2{
            select.charger = charger
            select.station = self.stationDetail
            select.chargingpoint = port.seqNumber
            select.bookedUsing = via
            select.tas = tas
            select.unit = unit
            select.dateTime = Date().toString()
            self.performSegue(withIdentifier: "Book", sender: select)
        }
    }
    func setDataForTimeSlotBooking(data:([Int],String,String,UIViewController)){
        var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "",tas: nil, unit: nil,stopTime:nil)
        
        select.chargingpoint = self.timeSlotData.0.seqNumber
        select.charger = self.chargers[(self.timeSlotData.2)]
        select.station = self.stationDetail
        select.dateTime = data.1
        select.stopTime = data.2
        select.selectedSlots = data.0
        select.bookedUsing = "Slot"
        self.performSegue(withIdentifier: "Book", sender: select)
    }
    deinit {
        print("\(self) id deinitialized")
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Book"{
        let vc = segue.destination as! BookingStatusVC
        if let station = sender as? SelectedChargerAndPort {
            vc.selectedStation = station
            vc.bookingBy = self.bookingBy
         }
        }else  if segue.identifier == "uta"{
            if let vc = segue.destination as? UtaTabController,let data = sender as? (ChargerPort,Int,ResultCharger) {
                vc.chargerDetail = data.2
                
                vc.doneSelection = {[weak self] (via,val1,val2,controller) in
                    controller.dismiss(animated: true) {
                        self?.setDataForUTASBooking(data: (via,val1,val2), charger: data.2,port:data.0)
                    }
                }
             }
            }else if segue.identifier == "TimeSlot"{
            if let vc = segue.destination as? TabController {
              
                vc.selectionComplete = {[weak self] (arrSlots,seldate,lastdate,control) in
                    control.dismiss(animated: true) {
                        if let slot = arrSlots, let dat = seldate,let datLast = lastdate  {
                            self?.setDataForTimeSlotBooking(data: (slot,dat,datLast,control))
                        }else{
                            var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "",tas: nil, unit: nil)
                            select.chargingpoint = self?.timeSlotData.0.seqNumber
                            select.charger = self?.chargers[(self?.timeSlotData.2)!]
                            select.station = self?.stationDetail
                           // self?.performSegue(withIdentifier: "Book", sender: select)
                        }
                    }
                }
                vc.noSelection = {[weak self] (control) in
                    control.dismiss(animated: true) {
                        var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "",tas: nil, unit: nil)
                        select.chargingpoint = self?.timeSlotData.0.seqNumber
                        select.charger = self?.chargers[(self?.timeSlotData.2)!]
                        select.station = self?.stationDetail
                       // self?.performSegue(withIdentifier: "Book", sender: select)
                    //self?.setDataForTimeSlotBooking(data: (arrSlots,seldate,control))
                    }
                }
                
//                if let viewC1 = vc.viewControllers?.first, let vc1 = viewC1 as? TimeSlotVC{
//                   // vc.selectionComplete
//                    vc1.doneSelection = {[weak self] (arrSlots,seldate,control) in
//                        control.dismiss(animated: true) {
//                        self?.setDataForTimeSlotBooking(data: (arrSlots,seldate,control))
//                        }
//                    }
//                }
//                if let viewC1 = vc.viewControllers?.first, let vc1 = viewC1 as? NextDayTimeVC{
//                    vc1.doneSelection = {[weak self] (arrSlots,seldate,control) in
//                        control.dismiss(animated: true) {
//                            self?.setDataForTimeSlotBooking(data: (arrSlots,seldate,control))
//                        }
//                    }
//                }
//                if let viewC1 = vc.viewControllers?.first, let vc1 = viewC1 as? DayAfterTorowTimeVC{
//                    vc1.doneSelection = {[weak self] (arrSlots,seldate,control) in
//                        control.dismiss(animated: true) {
//                            self?.setDataForTimeSlotBooking(data: (arrSlots,seldate,control))
//                        }
//                    }
//                }
                self.generateTimeSlots(interval: self.slotInterval) { done in
                    if done{
                        vc.stationDetail = self.stationDetail
                        vc.dataSource = self.arrayOfTimeSlot
                        vc.dataSource1 = self.arrayOfTimeSlotNext
                        vc.dataSource2 = self.arrayOfTimeSlotNextDay
                    }
                }
            }
        }else if segue.identifier == "Duration"{
            if let vc = segue.destination as? DurationVC ,let portandindex = sender as? (ChargerPort,Int,ResultCharger){
                if portandindex.2.outputType == "DC" {
                    vc.maxValue = 2
                    vc.interval = 0.5
                    vc.outputType = "DC"
                }
                if portandindex.2.outputType == "AC" {
                    vc.maxValue = 6
                    vc.interval = 1
                    vc.outputType = "AC"
                }
                vc.complete = { [weak self](duration,control) in
                    control.dismiss(animated: true) {
                        if let dur =  duration, dur > 0 {
                            var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "",tas: nil, unit: nil)
                                select.chargingpoint = portandindex.0.seqNumber
                                select.charger = self?.chargers[portandindex.1]
                                select.station = self?.stationDetail
                                select.duration = dur
                                select.bookedUsing = "Duration"
//                            if portandindex.2.outputType == "DC" {
//                                vc.maxValue = 2
//                                vc.interval = 0.5
//                                vc.outputType = "DC"
//                            }
//                            if portandindex.2.outputType == "AC" {
//                                vc.maxValue = 6
//                                vc.interval = 1
//                                vc.outputType = "AC"
//                            }
                            self?.performSegue(withIdentifier: "Book", sender: select)
                        }else{
                            var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "",tas: nil, unit: nil)
                            select.chargingpoint = portandindex.0.seqNumber
                            select.charger = self?.chargers[portandindex.1]
                            select.station = self?.stationDetail
//                            if portandindex.2.outputType == "DC" {
//                                vc.maxValue = 2
//                                vc.interval = 0.5
//                                vc.outputType = "DC"
//                            }
//                            if portandindex.2.outputType == "AC" {
//                                vc.maxValue = 6
//                                vc.interval = 1
//                                vc.outputType = "AC"
//                            }
                           // self?.performSegue(withIdentifier: "Book", sender: select)
                        }
                       
                    }
                }
            }
        }
    }
    
    func calculateHeight(index:Int) -> CGFloat {
        if let port = self.chargers[index].chargerPort,let portFirst = port.first ,let identification_Number = portFirst.identificationNumber ,identification_Number.count > 0 {
            return port.count > 0 ? CGFloat((port.count + 1) * 45) : 0
        }
        return 0
    }
    
    func getOccoupiedSlots(data:(String,String,String),completion:@escaping([Int]?,Bool)->()){
       
        ApiGetRequest().kindOf(Theme.Getbookedschedulebydate, requestFor: .GET_BOOKED_SCHEDULED_BY_DATE, queryString: [data.0,data.1,data.2], response: OccoupiedSlot.self) { [weak self] (respo) in
            if let res = respo,let _ = res.success,let msg = res.message,msg == Theme.Message{
                    if let result = res.result{
                        if result.contains(","){
                            let arrOfOccup = result.components(separatedBy: ",")
                             if arrOfOccup.count > 1 {
                                 let arr:[Int] = arrOfOccup.map({Int($0)!})
                                 completion(arr,true)
                            }
                        }else{
                            if !result.isEmpty {
                                if let arr = Int(result){
                                 completion([arr],true)
                                }
                            }else{
                                completion(nil,true)
                            }
                        }
                    }else{
                        completion(nil,true)
                    }
            }else{
                completion(nil,false)
            }
        }
    }
    func generateTimeSlots(interval:Int,completion:@escaping(Bool)->()){
   // func getMinutesTimeSlotsBetween(startDateTime:Date, _ endDateTime:Date, andSlotInterval interval:Int){
           arrayOfTimeSlot = []
           arrayOfTimeSlotNext = []
           // var timeSlots: [String] = []
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            formatter.dateFormat = "hh:mm a"
        var boolDate :Bool
        var leftHour = 0
        var leftMin = 0
        if let hourNow = Date().tohhmmString().components(separatedBy: ":").first,let left = Int(hourNow){
            leftHour = 24 - (left+1)
        }
        if let minNow = Date().tohhmmString().components(separatedBy: ":").last,let left = Int(minNow){
            leftMin = 60 - left
        }
        let timeNow = Date().tohhmmString().converthhmmamStringToDate()
        var sDate = Date().addMinuits(min: leftMin)
        var eDate = Date().addHour(hour: leftHour+6).addMinuits(min: leftMin)
        let nxtEnd = eDate.addHour(hour: 19)
        //let enddDate = eDate.addingTimeInterval(TimeInterval(interval*interval))
        //let stringFf = formatter.string(from: eDate)
            //.convertToUtcDate()
        for j in 1 ... 2{
            if j==1{
                var i = 0
                while true {
                   // let sDate = startDateTime.addingTimeInterval(TimeInterval(i*interval*60))
                    let endDate = sDate.addingTimeInterval(TimeInterval(interval*60))
                    let stringF = formatter.string(from: sDate)
                    let stringL = formatter.string(from: endDate)
                    if endDate.tohhmmString().converthhmmamStringToDate() > timeNow{
                      boolDate = true
                    }else{
                        boolDate = false
                    }
                    let str = stringF + "-" + stringL
                    if endDate >= eDate {
                        break }
                    arrayOfTimeSlot.append((str,boolDate,false,i))
                    i += 1
                    sDate = endDate
                }
            }else{
                var i = 0
                while true {
                   // let sDate = startDateTime.addingTimeInterval(TimeInterval(i*interval*60))
                    let endDate = eDate.addingTimeInterval(TimeInterval(interval*interval))
                    let stringF = formatter.string(from: eDate)
                    let stringL = formatter.string(from: endDate)
//                    if endDate.tohhmmString().converthhmmamStringToDate() > timeNow{
//                      boolDate = true
//                    }else{
//                        boolDate = false
//                    }
                    let str = stringF + "-" + stringL
                    if endDate >= nxtEnd {
                        break }
                    arrayOfTimeSlotNext.append((str,true,false,i))
                    i += 1
                    eDate = endDate
                }
            }
        }
        completion(true)
        }
   /* func generateTimeSlots(interval:Int,completion:@escaping(Bool)->()){
       
        arrayOfTimeSlot = []
        arrayOfTimeSlotNext = []
        arrayOfTimeSlotNextDay = []
        // let nextDay = Date().adding(Day: 1).converthhmmStringToDate()
        let timeNow = Date().tohhmmString().converthhmmStringToDate()
       
       
        //let etime = "23:55"
        let etimeInDate = "23:55".converthhmmStringToDate()
      //  let etimeInDate1 = "23:55".converthhmmStringToDate().addInHHMM(Day: 1)
       // let etimeInDate2 = "23:55".converthhmmStringToDate().addInHHMM(Day: 1)
       
        var nxTime:Date
        var boolDate :Bool
        let isSelected = false
        for i in 1 ... 3{
            var stime = "06:30"
            var nxtTime = ""
            var slotNumber = 0
            if i == 1 || i == 2 || i == 3 {
                
                repeat{
                    nxtTime = stime.converthhmmStringToDate().adding(minutes: interval)
                    if stime.converthhmmStringToDate() > timeNow{
                      boolDate = true
                    }else{
                        boolDate = false
                    }
                    
                    let timeSlot = "\(stime.converthhmmStringToDate().ampmString()) - \(nxtTime.converthhmmStringToDate().ampmString())"
                    if i == 1 {
                        arrayOfTimeSlot.append((timeSlot,boolDate,isSelected,slotNumber))
                        
                    }
                    if i == 2 {
                        arrayOfTimeSlotNext.append((timeSlot,true,isSelected,slotNumber))
                    }
                    if i == 3 {
                        arrayOfTimeSlotNextDay.append((timeSlot,true,isSelected,slotNumber))
                    }
                    stime = nxtTime
                   // stime = stime.converthhmmStringToDate().adding(minutes: 5)
                    nxTime = nxtTime.converthhmmStringToDate()
                    slotNumber += 1
                }while(nxTime < etimeInDate)
            }
        }
        if let arr = self.occoup1{
            let aa = ((self.arrayOfTimeSlot.filter({arr.contains($0.3) }).map({$0.3})))
            aa.map({self.arrayOfTimeSlot[$0].1 = false})
        }
        if let arr = self.occoup2{
            let aa = ((self.arrayOfTimeSlotNext.filter({arr.contains($0.3) }).map({$0.3})))
            aa.map({self.arrayOfTimeSlotNext[$0].1 = false})
        }
        if let arr = self.occoup3{
            let aa = ((self.arrayOfTimeSlotNextDay.filter({arr.contains($0.3) }).map({$0.3})))
            aa.map({self.arrayOfTimeSlotNextDay[$0].1 = false})
        }
        completion(true)
//        let arr = [27,28]
//        let aa = (self.arrayOfTimeSlot.filter({arr.contains($0.3)}).map({$0.3}))
//        aa.map({self.arrayOfTimeSlot[$0].1 = false})
       
    }*/
    /*func generateTimeSlots(interval:Int,completion:@escaping(Bool)->()){
       
        arrayOfTimeSlot = []
        arrayOfTimeSlotNext = []
        arrayOfTimeSlotNextDay = []
        // let nextDay = Date().adding(Day: 1).converthhmmStringToDate()
        let timeNow = Date().tohhmmString().converthhmmStringToDate()
       
       
        //let etime = "23:55"
        let dt = Date().to_dd_mm_yyyy_String() + " 12:55:00 PM"
        let etimeInDate = dt.toNewDate().convertToUtcDate()
       // let etimeInDate = "23:55".converthhmmStringToDate()
      //  let etimeInDate1 = "23:55".converthhmmStringToDate().addInHHMM(Day: 1)
       // let etimeInDate2 = "23:55".converthhmmStringToDate().addInHHMM(Day: 1)
       
        var nxTime:Date
        var boolDate :Bool
        let isSelected = false
       // for i in 1 ... 1{
        var stime = Date().to_dd_mm_yyyy_String() + " 06:30:00 AM"
       let stTime = stime.toNewDate().convertToUtcDate()
           // var stime = "06:30"
            var nxtTime = ""
            var slotNumber = 0
          //  if i == 1 || i == 2 || i == 3 {
                
                repeat{
                  //  nxtTime = stime.converthhmmStringToDate().adding(minutes: interval)
                    nxtTime = stTime!.adding(minutes: interval)
                    if stime.converthhmmStringToDate() > timeNow{
                      boolDate = true
                    }else{
                        boolDate = false
                    }
                    
                    let timeSlot = "\(stime.converthhmmStringToDate().ampmString()) - \(nxtTime.converthhmmStringToDate().ampmString())"
                   // if i == 1 {
                        arrayOfTimeSlot.append((timeSlot,boolDate,isSelected,slotNumber))
                    //}
//                    if i == 2 {
//                        arrayOfTimeSlotNext.append((timeSlot,true,isSelected,slotNumber))
//                    }
//                    if i == 3 {
//                        arrayOfTimeSlotNextDay.append((timeSlot,true,isSelected,slotNumber))
//                    }
                    stime = nxtTime
                   // stime = stime.converthhmmStringToDate().adding(minutes: 0)
                   // nxTime = nxtTime.converthhmmStringToDate()
                    nxTime = (nxtTime.toNewDate().convertToUtcDate())!
                    slotNumber += 1
                }while(nxTime < etimeInDate!)
            //}
        //}
        if let arr = self.occoup1{
            let aa = ((self.arrayOfTimeSlot.filter({arr.contains($0.3) }).map({$0.3})))
            aa.map({self.arrayOfTimeSlot[$0].1 = false})
        }
        if let arr = self.occoup2{
            let aa = ((self.arrayOfTimeSlotNext.filter({arr.contains($0.3) }).map({$0.3})))
            aa.map({self.arrayOfTimeSlotNext[$0].1 = false})
        }
        if let arr = self.occoup3{
            let aa = ((self.arrayOfTimeSlotNextDay.filter({arr.contains($0.3) }).map({$0.3})))
            aa.map({self.arrayOfTimeSlotNextDay[$0].1 = false})
        }
        completion(true)
//        let arr = [27,28]
//        let aa = (self.arrayOfTimeSlot.filter({arr.contains($0.3)}).map({$0.3}))
//        aa.map({self.arrayOfTimeSlot[$0].1 = false})
       
    }*/
    func generateTimeSlot(timeSlot:String,interval:Int){
        var arrayOfTimeSlot : [String] = []
        if timeSlot.contains("-"){
            if let strtTime = timeSlot.components(separatedBy: "-").first,let endTime = timeSlot.components(separatedBy: "-").last{
                var stime = strtTime.trimmingCharacters(in: .whitespaces)
                let etime = endTime.trimmingCharacters(in: .whitespaces)
                var nxtTime = ""
                repeat{
                    nxtTime = (stime.converthhmmStringToDate().adding(minutes: interval))
                    let timeSlot = "\(stime) - \(nxtTime)"
                    arrayOfTimeSlot.append(timeSlot)
                    stime = nxtTime
                }while(nxtTime != etime)
            }
        }
        self.performSegue(withIdentifier: "TimeSlot", sender: arrayOfTimeSlot)
        //setupPicker(title: "Select Time Slot",dataSource: arrayOfTimeSlot)
    }
    func setupPicker(title:String,dataSource:[String]){
        self.pickerTimeSlot.titleText = title
        self.pickerTimeSlot.setup(for: dataSource)
        self.pickerTimeSlot.show(inVC: self)
       
    }
}
extension StationDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chargers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookStationCell", for: indexPath) as! bookStationCell
        
//        cell.showTmeSlotView = {[weak self] in
//            self?.performSegue(withIdentifier: "TimeSlot", sender: nil)
//        }
        cell.scheduleCharging = { [weak self] (port,slot,index) in
            self?.timeSlotData = (port,slot,index)
            self?.slotInterval =  port.slotInterval ?? 60
        if let chargerName = self?.chargers[indexPath.row].chargerName,let chargerPort = port.seqNumber{
            let date = Date().to_dd_mm_yyyy_String()
            let dateNext = Date().add_hh_mm_yyyy(day: 1)
            let dateNextDay = Date().add_hh_mm_yyyy(day: 2)
            self?.group.enter()
            self?.group.enter()
            self?.group.enter()
            self?.isWaiting = true
            self?.getOccoupiedSlots(data: (chargerName,String(chargerPort),date), completion: { (arrOccp,done) in
                if done{
                    if let arr = arrOccp  {
                        self?.occoup1 = arr
                    }
                    self?.group.leave()
                   // self?.performSegue(withIdentifier: "TimeSlot", sender: nil)
                }else{
                    self?.group.leave()
//                    DispatchQueue.main.async {
//                        self?.displayAlert(alertMessage: "Unable to find occupied slots")
//                    }
                }
            })
            self?.getOccoupiedSlots(data: (chargerName,String(chargerPort),dateNext), completion: { (arrOccp,done) in
                if done{
                    if let arr = arrOccp  {
                        self?.occoup2 = arr
//                    let aa = ((self?.arrayOfTimeSlot.filter({arr.contains($0.3)}).map({$0.3})))!
//                    aa.map({self?.arrayOfTimeSlotNext[$0].1 = false})
                    }
                    self?.group.leave()
                   // self?.performSegue(withIdentifier: "TimeSlot", sender: nil)
                }else{
                    self?.group.leave()
//                    DispatchQueue.main.async {
//                        self?.displayAlert(alertMessage: "Unable to find occupied slots")
//                    }
                }
            })
            self?.getOccoupiedSlots(data: (chargerName,String(chargerPort),dateNextDay), completion: { (arrOccp,done) in
                if done{
                    if let arr = arrOccp  {
                        self?.occoup3 = arr
//                    let aa = ((self?.arrayOfTimeSlot.filter({arr.contains($0.3)}).map({$0.3})))!
//                    aa.map({self?.arrayOfTimeSlotNextDay[$0].1 = false})
                    }
                    self?.group.leave()
                   // self?.performSegue(withIdentifier: "TimeSlot", sender: nil)
                }else{
                    self?.group.leave()
//                    DispatchQueue.main.async {
//                        self?.displayAlert(alertMessage: "Unable to find occupied slots")
//                    }
                }
            })
            self?.group.notify(queue: .main, execute: {
                // Step3: Update the UI
                self?.isWaiting = false
              })
            }
        }
        cell.selectedStation = { [weak self] (port,index,charger) in
            if Theme.appName == "V-Power" || Theme.appName == "VRAJEV Charge" || Theme.appName == "GoGedi"{
            var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil, userEvId: nil, selectedSlots: nil, duration: nil, dateTime: nil, station: nil, stationByQr: nil,bookedUsing: "",tas: nil, unit: nil)
            select.chargingpoint = port.seqNumber
            select.charger = self?.chargers[index]
            select.station = self?.stationDetail
            self?.performSegue(withIdentifier: "Book", sender: select)
            }else if Theme.appName == "StartEVCharge" || Theme.appName == "EV Plugin Charge"{
                self?.performSegue(withIdentifier: "uta", sender: (port,index,charger))
            }else {
                self?.performSegue(withIdentifier: "Duration", sender: (port,index,charger))
            }
           }
        cell.setChargerDetail(charger: self.chargers[indexPath.row],index: indexPath.row,controller: self)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // let cell = cell as! bookStationCell
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 4, width: Int(self.view.bounds.width), height: 40))
        vw.backgroundColor = Theme.menuHeaderColor
        let lblType = UILabel(frame: CGRect(x: 0, y: 2, width: Int(self.view.bounds.width), height: 36))
       // let lblType = UILabel(frame: CGRect(x: 0, y: 3, width: 60, height: 36))
        //let width:Int = Int(self.view.bounds.width/2) - 60
       // let lblConnector = UILabel(frame: CGRect(x: 61, y: 3, width: width, height: 36))
        //let lblAvail = UILabel(frame: CGRect(x: width+60, y: 3, width: width, height: 36))
        lblType.text = "Connector's Availability Status"
//        lblType.text = "Type"
//        lblConnector.text = "Connector"
//        lblAvail.text = "Status"
        
        lblType.labelDesign()
//        lblConnector.labelDesign()
//        lblAvail.labelDesign()
//        lblAvail.textAlignment = .left
        vw.addSubview(lblType)
//        vw.addSubview(lblConnector)
//        vw.addSubview(lblAvail)
        return vw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.calculateHeight(index: indexPath.row) == 0 ? 0: (80 + self.calculateHeight(index: indexPath.row))
    }
}
struct SelectedChargerAndPort {
    var charger:ResultCharger?
    var chargingpoint:Int?
    var userEvId:Int?
    var selectedSlots:[Int]?
    var duration:Int?
    var dateTime:String?
    var station:ResultStation?
    var stationByQr:Station?
    var bookedUsing = ""
    var tas:Int?
    var unit:Double?
    var stopTime:String?
}

extension StationDetailViewController:GMPickerDelegate{
    func gmPicker(_ gmPicker: GMPicker, didSelect string: String, at index: Int) {
        
    }
    
    func gmPickerDidCancelSelection(_ gmPicker: GMPicker) {
        
    }
}
