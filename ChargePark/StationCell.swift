//
//  StationCell.swift
//  ChargePark
//
//  Created by apple on 22/09/21.
//

import UIKit

class StationCell: UITableViewCell {
    @IBOutlet weak var lblType:UILabel!
    @IBOutlet weak var lblConnector:UILabel!
    @IBOutlet weak var lblAvail:UILabel!
    @IBOutlet weak var btnBook:UIButton!
    
    @IBOutlet weak var viewCard: Card!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblAvail.cornerRadius(with: 6.0)
        lblAvail.clipsToBounds = true
        btnBook.cornerRadius(with: 6.0)
        btnBook.clipsToBounds = true
        viewCard.cornerRadius(with: 6.0)
        viewCard.layer.borderWidth = 1.0
        viewCard.layer.borderColor = UIColor.systemBlue.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnBook(_ sender:UIButton){
        
    }
}
