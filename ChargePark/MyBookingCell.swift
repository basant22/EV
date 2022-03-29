//
//  MyBookingCell.swift
//  ChargePark
//
//  Created by apple on 20/10/21.
//

import UIKit

class MyBookingCell: UITableViewCell {
    @IBOutlet weak var viewCard:Card!
    @IBOutlet weak var viewUperL:UIView!
    @IBOutlet weak var viewUperR:UIView!
    @IBOutlet weak var viewUperM:UIView!
    
    @IBOutlet weak var viewDwnM:UIView!
    @IBOutlet weak var viewDwnL:UIView!
    @IBOutlet weak var viewDwnR:UIView!
    
    @IBOutlet weak var lblBookingTitle:UILabel!
    @IBOutlet weak var lblAmountTitle:UILabel!
    @IBOutlet weak var lblDateTitle:UILabel!
    @IBOutlet weak var lblDurationTitle:UILabel!
    @IBOutlet weak var lblUnitConsTitle:UILabel!
    
    @IBOutlet weak var lblBookingValue:UILabel!
    @IBOutlet weak var lblAmountValue:UILabel!
    @IBOutlet weak var lblDateValue:UILabel!
    @IBOutlet weak var lblDurationValue:UILabel!
    @IBOutlet weak var lblUnitConsValue:UILabel!
    @IBOutlet weak var btnCPStatus:UIButton!
    @IBOutlet weak var btnCancel:UIButton!
    var bookingId:Int!
    var pdfUrl:URL!
    var cancelBooking:((Int)->()) = {_ in }
    var showPdf:((URL)->()) = {_ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnCancel.isHidden = true
        viewCard.layer.borderWidth = 1.0
        viewCard.layer.borderColor = Theme.menuHeaderColor.cgColor
        viewCard.cornerRadius(with: 12.0)
        self.viewCard.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = Theme.menuHeaderColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    func drawDottedLin(){
        
        let  path = UIBezierPath()

        let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
        path.move(to: p0)

        let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
        path.addLine(to: p1)
       
        let  dashes: [ CGFloat ] = [ 16.0, 32.0 ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)

        path.lineWidth = 8.0
        path.lineCapStyle = .butt
        UIColor.magenta.set()
        path.stroke()
    }
    func setCellForStartAndBooked(data:Booking,tag:Int){
        let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY-4)
        let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY-4)
        drawDottedLine(start: p0, end: p1, view: self.viewCard)
       
        lblDateTitle.text = "Station Name"
        lblDurationTitle.text = "Charger Name"
        lblUnitConsTitle.text = "Port Number"
        
        if let stationName =  data.stationName{
            lblDateValue.text = stationName
        }else{
            lblDateValue.text = "N/A"
        }
        if let chargerName =  data.chargerName{
            lblDurationValue.text = chargerName
        }else{
            lblDurationValue.text = "N/A"
        }
        if let chargingPoint =  data.chargingPoint{
            lblUnitConsValue.text = String(chargingPoint)
        }else{
            lblUnitConsValue.text = "N/A"
        }
        if let bookingID =  data.bookingID{
            lblBookingValue.text = String(bookingID)
        }else{
            lblBookingValue.text = "N/A"
        }
   
        viewUperR.isHidden = false
        lblAmountTitle.isHidden = true
        lblAmountValue.isHidden = true
        btnCPStatus.isHidden = false
        btnCancel.isHidden = false
        btnCancel.tag = tag
        btnCPStatus.tag = tag
        let img = UIImage(named: "Cancel")?.tint(with: .black)
        btnCancel.setImage(img, for: .normal)
        self.btnCPStatus.setTitle("Cancel Booking", for: .normal)
        if data.status == "S" || data.status == "B" || data.status == "R" {
            lblAmountTitle.isHidden = false
            lblAmountValue.isHidden = false
            lblAmountTitle.text = "Booking Status"
            lblAmountValue.text = "New Booking"
        }
//        else if data.status == "R" {
//           // btnCancel.isHidden = true
//           // btnCancel.isUserInteractionEnabled = false
//            lblAmountTitle.isHidden = false
//            lblAmountValue.isHidden = false
//            lblAmountTitle.text = "Booking Status"
//            lblAmountValue.text = "Initialising"
//        }
    }
    
    func setCellData(data:Booking,tag:Int){
        let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY-4)
        let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY-4)
        self.btnCancel.tag = tag
        self.btnCPStatus.tag = tag
        drawDottedLine(start: p0, end: p1, view: self.viewCard)
        self.bookingId = data.bookingID
        self.viewCard.backgroundColor = .white
        if let bookingId =  data.bookingID{
            lblBookingValue.text = String(bookingId)
        }else{
            lblBookingValue.text = "N/A"
        }
        if let amount =  data.amount{
            lblAmountValue.text = Theme.INRSign +  String(amount)
        }else{
            lblAmountValue.text = "N/A"
        }
        if let startTime =  data.startTime{
            lblDateValue.text = startTime.convertDateFormater()
        }else{
            lblDateValue.text = "N/A"
        }
        if let startTime =  data.startTime,let stopTime = data.stopTime{
            var timeDuration = ("","","")
             timeDuration = startTime.dateWithTime(stop:stopTime)
            lblDurationValue.text = timeDuration.0 + ":" + timeDuration.1 + ":" + timeDuration.2
        }else{
            lblDurationValue.text = "N/A"
        }
//        if let startReading =  data.startReading,let stopReading = data.stopReading{
//            let diff = startReading - stopReading
//            lblUnitConsValue.text = String(diff)
//        }else{
//            lblUnitConsValue.text = "N/A"
//        }
        if let unit = data.unit{
            lblUnitConsValue.text = String(unit)
        }else{
            lblUnitConsValue.text = "N/A"
        }
//        btnCPStatus.isHidden = false
        btnCancel.isHidden = true
        if let status = data.status {
            if status == "C" {
                btnCPStatus.isHidden = false
                btnCancel.isHidden = false
//                if data.isDownloaded == false {
//                    if !(pdfFileAlreadySaved(fileName: String(self.bookingId))).0{
//                        btnCancel.setTitle("Download Invoice", for: .normal)
//                        let img = UIImage(named: "Download")?.tint(with: Theme.navigationBgc)
//                        btnCancel.setImage(img, for: .normal)
//                        self.btnCPStatus.setTitle("Download Invoice", for: .normal)
//                        self.btnCPStatus.titleLabel?.textColor = UIColor.black
//                        self.btnCPStatus.isUserInteractionEnabled = true
//                    }
//                }else{
//                    btnCancel.setTitle("Downloaded", for: .normal)
//                    let img = UIImage(named: "Download")?.tint(with: .lightGray)
//                    btnCancel.setImage(img, for: .normal)
//                    self.btnCPStatus.setTitle("Show Invoice", for: .normal)
//                    self.btnCPStatus.titleLabel?.textColor = UIColor.black
//                    self.btnCPStatus.isUserInteractionEnabled = true
//                    if let url = (pdfFileAlreadySaved(fileName: String(self.bookingId))).1 {
//                        pdfUrl = url
//                    }
//                }
               
                if !(pdfFileAlreadySaved(fileName: String(self.bookingId))).0{
                    btnCancel.setTitle("Download Invoice", for: .normal)
                    let img = UIImage(named: "Download")?.tint(with: Theme.navigationBgc)
                    btnCancel.setImage(img, for: .normal)
                    self.btnCPStatus.setTitle("Download Invoice", for: .normal)
                    self.btnCPStatus.titleLabel?.textColor = UIColor.black
                    self.btnCPStatus.isUserInteractionEnabled = true
                }else{
                    btnCancel.setTitle("Downloaded", for: .normal)
                    let img = UIImage(named: "Download")?.tint(with: .lightGray)
                    btnCancel.setImage(img, for: .normal)
                    self.btnCPStatus.setTitle("Show Invoice", for: .normal)
                    self.btnCPStatus.titleLabel?.textColor = UIColor.black
                    self.btnCPStatus.isUserInteractionEnabled = true
                    if let url = (pdfFileAlreadySaved(fileName: String(self.bookingId))).1 {
                        pdfUrl = url
                    }
                }
            }
            if status == "P"{
                self.btnCPStatus.setTitle("Download Invoice", for: .normal)
                self.btnCPStatus.titleLabel?.textColor = UIColor.black
                self.btnCPStatus.isUserInteractionEnabled = true
            }
            if status == "D"{
                self.btnCPStatus.setTitle("Cancelled", for: .normal)
                self.btnCPStatus.setTitleColor(UIColor.red, for: .normal)
                self.btnCPStatus.isUserInteractionEnabled = false
            }
        }
    }
    @IBAction func btnCancel(_ sender:UIButton){
        switch sender.titleLabel?.text {
        case "Downloaded":
            showPdf(self.pdfUrl)
        case "Download Invoice":
            cancelBooking(sender.tag)
//            if !(pdfFileAlreadySaved(fileName: String(self.bookingId))).0{
//                cancelBooking(sender.tag)
//            }else{
//                if let url = (pdfFileAlreadySaved(fileName: String(self.bookingId))).1{
//                    showPdf(url)
//                }
//            }
        default:
            cancelBooking(sender.tag)
        }
    }
    @IBAction func btnCPStatus(_ sender:UIButton){
        let title = sender.titleLabel?.text
        switch title {
        case "PayNow":
            print("PayNow")
        case "Show Invoice":
            showPdf(self.pdfUrl)
        case "Download Invoice":
            cancelBooking(sender.tag)
            print("Download Invoice")
        case "Cancel Booking":
            cancelBooking(sender.tag)
//            if !(pdfFileAlreadySaved(fileName: String(self.bookingId))).0 {
//                cancelBooking(sender.tag)
//            }else{
//                if let url = (pdfFileAlreadySaved(fileName: String(self.bookingId))).1{
//                    showPdf(url)
//                }
//            }
        default:
            print("")
        }
    }
}
func pdfFileAlreadySaved(fileName:String)-> (Bool,URL?) {
    var status = false
    var appN = Theme.appName
    if Theme.appName == "EV Plugin Charge" {
        appN = "EV-Plugin"
    }
    if #available(iOS 10.0, *) {
        do {
            let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            for url in contents {
                
                if url.description.contains("\(appN)-\(fileName).pdf") {
                    status = true
                    print("Already downloaded")
                    return (status,url)
                }
            }
        } catch {
            print("could not locate pdf file !!!!!!!")
        }
    }
    return (status,nil)
}
