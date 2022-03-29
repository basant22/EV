//
//  TwoButtonCell.swift
//  ChargePark
//
//  Created by apple on 24/06/1943 Saka.
//

import UIKit

class TwoButtonCell: UITableViewCell {
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnGuest:UIButton!
    var getAction:((Int)->())! = {_ in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnLogin.cornerRadius(with: 4)
        btnGuest.cornerRadius(with: 4)
        btnLogin.setTitle("User Login", for: .normal)
        btnGuest.setTitle("Continue As Guest", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func btnLogin_Action(_ sender: UIButton){
        getAction(btnLogin.tag)
        
    }
    @IBAction func btnGuest_Action(_ sender: UIButton){
        getAction(btnGuest.tag)
    }
}
