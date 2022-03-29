//
//  ButtonCell.swift
//  ChargePark
//
//  Created by apple on 23/06/1943 Saka.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet var btnCell:UIButton!
    var getButtonAction:((Bool)->())! = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpButtonCell(Title:String){
        btnCell.setTitle(Title, for: .normal)
        btnCell.cornerRadius(with: 4.0)
        btnCell.setButtonAttributes()
    }
    @IBAction func btnCell_Action(_ sender: UIButton) {
        getButtonAction(true)
        /*
        switch sender.titleLabel?.text {
        case "Registration":
            getButtonAction()
        case "New to Charge Parks?Register Here":
            getButtonAction()
        default:
            print("")
        }*/
    }
}
