//
//  VehicleCell.swift
//  V-Power
//
//  Created by apple on 05/10/21.
//

import UIKit

class VehicleCell: UITableViewCell {
    
    @IBOutlet weak var lblYrOfReg: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewCard: Card!
    
    @IBOutlet weak var imgContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgContainer.cornerRadius(with: imgContainer.bounds.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(data:VehicleDeatil){
        if let yr  = data.year,let make = data.make,let model = data.model,let evg = data.evRegNumber{
        self.imgContainer.backgroundColor = Theme.menuHeaderColor
            self.img.image =  #imageLiteral(resourceName: "BigCar").tint(with: .white)
            self.lblYear.text = String(yr)
            self.lblModel.text = make + "-" + model
            self.lblYrOfReg.text = evg
    }
    }
}
