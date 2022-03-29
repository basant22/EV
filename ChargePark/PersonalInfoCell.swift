//
//  PersonalInfoCell.swift
//  ChargePark
//
//  Created by apple on 29/06/1943 Saka.
//

import UIKit

class PersonalInfoCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblValue:UILabel!
    @IBOutlet weak var lblLine:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func setPersonalInfo()  {
//        lblTitle.text = ""
//        lblValue.text = ""
//    }
}
