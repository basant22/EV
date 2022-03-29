//
//  EmptyCellCell.swift
//  V-Power
//
//  Created by apple on 06/10/21.
//

import UIKit

class EmptyCellCell: UITableViewCell {
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    static let identifier = "EmptyCellCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
