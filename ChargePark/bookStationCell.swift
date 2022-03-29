//
//  bookStationCell.swift
//  ChargePark
//
//  Created by apple on 23/09/21.
//

import UIKit

class bookStationCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblType:UILabel!
    @IBOutlet weak var lblConnector:UILabel!
    @IBOutlet weak var lblAvail:UILabel!
    @IBOutlet weak var btnBook:UIButton!
    @IBOutlet weak var btnScheduleBook:UIButton!
    @IBOutlet weak var viewCard: Card!
    var chargerPort:[ChargerPort] = []
    var selectedCharger:ChargerPort!
    var resultCharger:ResultCharger!
    var controller:UIViewController!
    var showTmeSlotView:(()->()) = { }
    var scheduleCharging:((ChargerPort,String,Int)->()) = {_,_,_ in}
    var selectedStation:((ChargerPort,Int,ResultCharger)->()) = {_,_,_ in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        lblAvail.cornerRadius(with: 8.0)
//        lblAvail.clipsToBounds = true
        btnBook.cornerRadius(with: 6.0)
        btnScheduleBook.cornerRadius(with: 6.0)
       // btnBook.backgroundColor = Theme.menuHeaderColor
       // btnScheduleBook.backgroundColor = Theme.menuHeaderColor
        btnBook.clipsToBounds = true
        btnScheduleBook.clipsToBounds = true
        btnBook.setTitle("Charge Now", for: .normal)
        btnBook.setTitleColor(.white, for: .normal)
        btnScheduleBook.setTitle("Pre Book", for: .normal)
        btnScheduleBook.setTitleColor(.white, for: .normal)
        viewCard.cornerRadius(with: 8.0)
//        viewCard.layer.borderWidth = 1.0
//        viewCard.layer.borderColor = Theme.menuHeaderColor.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(nibNames: ["ChargerStatusCell"])
        if Theme.appName == "V-Power" || Theme.appName == "VRAJEV Charge" || Theme.appName == "GoGedi"{
            btnScheduleBook.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setChargerDetail(charger:ResultCharger,index:Int,controller:UIViewController)  {
        self.resultCharger = charger
        self.controller = controller
        if let port = charger.chargerPort {
            self.chargerPort = port
        }
        btnBook.tag = index
        btnScheduleBook.tag = index
        btnBook.backgroundColor = Theme.newGreen
        btnScheduleBook.backgroundColor = Theme.newGreen
       let data = self.chargerPort.first(where: {$0.isSele == true})
        if data != nil {
            btnBook.isUserInteractionEnabled = false
            btnScheduleBook.isUserInteractionEnabled = false
            btnBook.backgroundColor = Theme.menuHeaderColor
            btnScheduleBook.backgroundColor = Theme.menuHeaderColor
        }else{
            btnBook.isUserInteractionEnabled = false
            btnScheduleBook.isUserInteractionEnabled = false
            
        }
      //  let boolValu =   self.chargerPort.filter({$0.isSele == true}).map({$0.isSele}).first(where: {$0 == true})
//        if  self.chargerPort[indexPath.row-1].isSele == true{
//            self.btnBook.isUserInteractionEnabled = true
//            self.btnBook.backgroundColor = Theme.menuHeaderColor
//        }
        btnBook.isUserInteractionEnabled = false
        lblConnector.text = ""
        lblType.text = charger.outputType ?? ""
        //lblConnector.text = charger.connector ?? ""
        lblAvail.text = charger.chargerType ?? ""
            //charger.status == "A" ? "Available":"Unavailable"
      //  lblAvail.backgroundColor = charger.status ?? "" == "A" ? UIColor.systemGreen : UIColor.red
    }
    @IBAction func btnScheduleBook(_ sender:UIButton){
        //let hour = Date().toString().convertDateFormat()
        self.scheduleCharging(self.selectedCharger,self.resultCharger.operationalHours ?? "",sender.tag)
    }
    @IBAction func btnBook(_ sender:UIButton){
        self.selectedStation(self.selectedCharger,sender.tag,self.resultCharger)
    }
}

extension bookStationCell:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return chargerPort.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargerStatusCell", for: indexPath) as! ChargerStatusCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.selectedPort = { seqNo,selectedIndex in
            for (indx,_) in self.chargerPort.enumerated() {
                if selectedIndex == indx {
                    self.selectedCharger = self.chargerPort[selectedIndex]
                    self.chargerPort[selectedIndex].isSele = true
                    
                    if let vc = self.controller as? StationDetailViewController{
                        
                       // for (i,_) in vc.chargers.enumerated(){
                        vc.chargers[self.btnBook.tag].chargerPort = self.chargerPort
                       // }
                    }
                    self.btnBook.isUserInteractionEnabled = true
                    self.btnBook.backgroundColor = Theme.menuHeaderColor
                    self.btnScheduleBook.isUserInteractionEnabled = true
                    self.btnScheduleBook.backgroundColor = Theme.menuHeaderColor
                }else{
                    self.chargerPort[indx].isSele = false
                }
            }
            self.tableView.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ChargerStatusCell
        cell.btnTimeSlot.isHidden = true
        if indexPath.row == 0{
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.cornerRadius(with: 6.0)
            cell.lblSeqNo.textColor = .darkGray
            cell.lblStatus.textColor = .darkGray
            cell.lblSeqNo.font = UIFont.systemFont(ofSize: 18)
            cell.lblStatus.font = UIFont.systemFont(ofSize: 18)
           // cell.lblSeqNo.textAlignment = .center
            cell.lblSeqNo.text = "Ports"
            cell.lblStatus.text = ""
           
           // cell.btnSelect.isUserInteractionEnabled = false
            cell.btnSelect.setImage(UIImage(), for: .normal) 
        }else{
           
            cell.btnTimeSlot.isUserInteractionEnabled = false
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.clear.cgColor
            //cell.btnSelect.isUserInteractionEnabled = true
            if self.chargerPort[indexPath.row-1].isSele == true{
                self.btnBook.isUserInteractionEnabled = true
                self.btnBook.backgroundColor = Theme.menuHeaderColor
                
                self.btnScheduleBook.isUserInteractionEnabled = true
                self.btnScheduleBook.backgroundColor = Theme.menuHeaderColor
            }
        cell.setDataForCell(data: chargerPort[indexPath.row - 1],stationData: self.resultCharger,index: indexPath.row - 1)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
extension bookStationCell:ShowTimeSlots{
    func timeSlot() {
        self.showTmeSlotView()
    }
}
