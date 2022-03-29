//
//  InfoCell.swift
//  ChargePark
//
//  Created by apple on 29/06/1943 Saka.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var imageVw:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblMobileNumber:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBack.backgroundColor = Theme.menuHeaderColor
        imageVw.cornerRadius(with: 40.0)
        imageVw.image = #imageLiteral(resourceName: "ProfileMenu").tint(with: .white)
        lblName.textColor = .white
        lblName.font = UIFont.systemFont(ofSize: 20.0)
        //(name: "HelveticaNeue-Medium", size: 20.0)
        
        lblEmail.textColor = .white
        lblMobileNumber.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData()  {
        if let defaul = Defaults.shared.userLogin,let user = defaul.username{
            lblName.text = user.count > 0 ? user : "Guest User"
        }
        
        lblEmail.text = Defaults.shared.userLogin?.userEmail ?? ""
        lblMobileNumber.text = Defaults.shared.userLogin?.username ?? ""
    }
}
