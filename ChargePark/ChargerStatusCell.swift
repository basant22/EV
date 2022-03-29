//
//  ChargerStatusCell.swift
//  V-Power
//
//  Created by apple on 03/10/21.
//

import UIKit
protocol ShowTimeSlots:AnyObject{
    func timeSlot()
}
class ChargerStatusCell: UITableViewCell {

    @IBOutlet weak var lblSeqNo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnTimeSlot: UIButton!
    @IBOutlet weak var vwBlur: UIView!
    
    weak var delegate:ShowTimeSlots!
    var isSel = false
    var chargerPort:[ChargerPort] = []
    var index:Int!
    var selectedPort:((Int,Int)->()) = { _,_ in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnTimeSlot.isHidden = true
        btnTimeSlot.isUserInteractionEnabled = false
        btnTimeSlot.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
        btnTimeSlot.setTitleColor( .white, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDataForCell(data:ChargerPort,stationData:ResultCharger, index:Int)  {
        self.index = index
        if let seqNo = data.seqNumber,let connec = stationData.connector, let _ = stationData.chargerType {
            lblSeqNo.text = String(seqNo) + " - (" + String(connec) + ")"
            lblStatus.text = ""
            btnSelect.tag = index
        }
       
        if let status = data.isBusy,status == false {
            btnSelect.isUserInteractionEnabled = true
            let Ima = #imageLiteral(resourceName: "UncRadio").tint(with: Theme.menuHeaderColor)
            btnSelect.setImage(Ima, for: .normal)
            vwBlur.isHidden = true
        }
        if let status = data.isBusy,status == true {
            btnSelect.isUserInteractionEnabled = false
            let Ima = #imageLiteral(resourceName: "CheRadio").tint(with: .lightGray)
           btnSelect.setImage(Ima, for: .normal)
            vwBlur.isHidden = false
            vwBlur.addBlur()
        }
        if let isSel =  data.isSele {
            isSel == true ?  btnSelect.setImage(#imageLiteral(resourceName: "CheRadio").tint(with: Theme.menuHeaderColor), for: .normal):btnSelect.setImage(#imageLiteral(resourceName: "UncRadio").tint(with: Theme.menuHeaderColor), for: .normal)
        }
        
       // lblStatus.isHidden = true
//        if let status = data.isBusy {
//            lblStatus.text = status.toString()
//            if status.toString() == Theme.UNAVAILABLE {
//                btnSelect.isUserInteractionEnabled = false
//                lblStatus.textColor = .red
//            }else{
//                btnSelect.isUserInteractionEnabled = true
//                lblStatus.textColor = Theme.menuHeaderColor
//            }
//        }
        
        
       
        
       
    }
    @IBAction func btnSelect_Action(_ sender: UIButton) {
        self.selectedPort(sender.tag,self.index)
//        if isSel == false {
//            isSel = true
//
//        }else{
//            isSel = false
//        }
    }
    @IBAction func btnTimeSlot_Action(_ sender: UIButton) {
        delegate.timeSlot()
    }
}
