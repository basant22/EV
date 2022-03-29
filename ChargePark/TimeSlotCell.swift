//
//  TimeSlotCell.swift
//  ChargePark
//
//  Created by apple on 02/12/21.
//

import UIKit

class TimeSlotCell: UICollectionViewCell {
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var lblTimeRange:UILabel!
    @IBOutlet weak var lblTo:UILabel!
    @IBOutlet weak var lblToTime:UILabel!
  
    
    static let identifier = "TimeSlotCell"
    static func nib() -> UINib{
        let nib = UINib(nibName: "TimeSlotCell", bundle: nil)
        return nib
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //viewBack.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
        self.backgroundColor = Theme.menuHeaderColor
        self.contentView.backgroundColor = Theme.menuHeaderColor
        lblTimeRange.textColor = .white
        lblTo.textColor = .white
        lblToTime.textColor = .white
       // viewBack.backgroundColor = Theme.menuHeaderColor
    }
    
    func setupCellData(data:(String,Bool,Bool,Int)){
        if data.0.contains("-"){
            if let fromTime = data.0.components(separatedBy: "-").first,let toTime = data.0.components(separatedBy: "-").last{
                lblTimeRange.text = fromTime
                lblTo.text = "To"
                lblToTime.text = toTime
            }
        }
       
        self.isUserInteractionEnabled = data.1
        if  data.1 == false {
            lblTimeRange.textColor = .lightGray
            lblTo.textColor = .lightGray
            lblToTime.textColor = .lightGray
            viewBack.backgroundColor = .systemGray4
        }else{
            if data.2 == true {
                lblTimeRange.textColor = .white
                lblTo.textColor = .white
                lblToTime.textColor = .white
                viewBack.backgroundColor = .darkGray
            }else{
                lblTimeRange.textColor = .darkGray
                lblTo.textColor = .darkGray
                lblToTime.textColor = .darkGray
                viewBack.backgroundColor = .lightGray
            }
        }
    }
}
