//
//  LabelCell.swift
//  ChargePark
//
//  Created by apple on 24/06/1943 Saka.
//

import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet weak var lbl:UILabel!
    @IBOutlet weak var view:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(data:ResultChargerBooking,startTime:(String,String,String),timeDuration:(String,String,String),rate:String,consumed:String,amount:String,index:Int){
        lbl.textAlignment = .left
        if let bookingId = data.bookingID, index == 0 {
            lbl.text = " Booking Id: " + String(bookingId)
        }
        if index == 1{
            lbl.text = " Start Time: " + startTime.0 + ":" + startTime.1 + ":" + startTime.2
            
        }
        if index == 2{
            lbl.text = " Duration: " + timeDuration.0 + ":" + timeDuration.1 + ":" + timeDuration.2 
        }
        if index == 3{
            lbl.text = " Rate Of Charging: " + rate.currencified + "kwh"
        }
        if index == 4{
            lbl.text = " Units Consumed: " + rate.currencified
        }
        if index == 5{
            lbl.text = " Amount: " + rate.currencified
        }
    }
}
