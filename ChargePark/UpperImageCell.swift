//
//  UpperImageCell.swift
//  ChargePark
//
//  Created by apple on 24/06/1943 Saka.
//

import UIKit

class UpperImageCell: UITableViewCell {
    @IBOutlet weak var bigImage:UIImageView!
    @IBOutlet weak var smallImage:UIImageView!
    @IBOutlet weak var vwImage:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwImage.cornerRadius(with: 8.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
