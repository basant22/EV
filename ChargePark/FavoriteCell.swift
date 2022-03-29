//
//  FavoriteCell.swift
//  ChargePark
//
//  Created by apple on 16/12/21.
//

import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var vwBase:UIView!
    @IBOutlet weak var vwLbls:UIView!
    @IBOutlet weak var vwImg:UIView!
    @IBOutlet weak var imgStation:UIImageView!
    @IBOutlet weak var lblStnName:UILabel!
    @IBOutlet weak var lblStnAddress:UILabel!
    @IBOutlet weak var lblStnContact:UILabel!
    @IBOutlet weak var btnLocate:UIButton!
    @IBOutlet weak var btnCall:UIButton!
    static let identifier = "FavoriteCell"
    var dataSource:ResultStation!
    var openMap:(()->()) = {}
    var latValue = 0.0
    var longValue = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let imagLocate = UIImage(systemName: "location.circle")?.tint(with: Theme.menuHeaderColor)
        let imagCall = UIImage(systemName: "phone.circle")?.tint(with: Theme.menuHeaderColor)
        btnLocate.setTitle("", for: .normal)
        btnCall.setTitle("", for: .normal)
        btnLocate.setImage(imagLocate, for: .normal)
        btnCall.setImage(imagCall, for: .normal)
        vwBase.backgroundColor = Theme.menuHeaderColor
        vwBase.cornerRadiusWitBorder(with: 8.0, border: Theme.menuHeaderColor)
        vwImg.cornerRadius(with: 8.0)
        vwLbls.cornerRadius(with: 8.0)
        latValue = Defaults.shared.userLocation["lat"] ?? 0.0
        longValue = Defaults.shared.userLocation["long"] ?? 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpCell(data:ResultStation){
        self.dataSource = data
        lblStnName.text = data.stationname ?? ""
        lblStnAddress.text = data.address ?? ""
        lblStnContact.text = data.contact ?? ""
        self.imgStation.setImage(url: data.icon ?? "")
    }
    @IBAction func btnCall(_ sender:UIButton){
        if let mobileNumber = self.dataSource?.contact {
            if let url = URL(string: "tel://\(mobileNumber)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func btnLocate(_ sender:UIButton){
        self.openMap()
       /* if let latt = self.dataSource?.lattitude,let long = self.dataSource?.longitude {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                if let url = URL(string: "comgooglemaps://?saddr\(latValue ),\(longValue)=&daddr=\(latt),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr\(latValue ),\(longValue))=&daddr=\(latt),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }*/
    }
}
