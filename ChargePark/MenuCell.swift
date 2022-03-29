//
//  MenuCell.swift
//  Radiush
//
//  Created by Hemant Singh on 05/01/20.
//  Copyright © 2020 Kreative. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
