//
//  HeadingCell.swift
//  Radiush
//
//  Created by Hemant Singh on 05/01/20.
//  Copyright © 2020 Kreative. All rights reserved.
//

import UIKit

class HeadingCell: UITableViewCell {
    @IBOutlet var imgLogo:UIImageView!
     @IBOutlet var lblName:UILabel!
     @IBOutlet var lblId:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        lblName.textColor = .white
//        lblId.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData()  {
        if let fname =  Defaults.shared.userLogin?.username,fname.isEmpty {
            lblName.text = "Guest"
            lblId.text = ""
        }else{
        lblName.text = Defaults.shared.userLogin?.name ?? ""
        lblId.text = Defaults.shared.userLogin?.username ?? ""
        }
    }
}
