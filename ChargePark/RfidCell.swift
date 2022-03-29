//
//  RfidCell.swift
//  ChargePark
//
//  Created by apple on 02/12/21.
//

import UIKit

class RfidCell: UITableViewCell {
    @IBOutlet weak var lblRfidT:UILabel!
    @IBOutlet weak var lblRfidV:UILabel!
    @IBOutlet weak var lblRfidST:UILabel!
    @IBOutlet weak var lblRfidSV:UILabel!
    @IBOutlet weak var ViewBase:UIView!
    @IBOutlet weak var ViewImg:UIView!
    @IBOutlet weak var ViewFlip:UIView!
    @IBOutlet weak var ViewBlock:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var btnDeleteRfid:UIButton!
    static let identifier = "RfidCell"
    var isFlip = false
    var deleteSelectedRfid:((Int)->()) = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // ViewImg
      //  ViewFlip.backgroundColor = Theme.menuHeaderColor
//        btnDeleteRfid.setTitle("Delete This RFID", for: .normal)
//        btnDeleteRfid.setTitleColor(.white, for: .normal)
//        btnDeleteRfid.titleLabel?.font = UIFont(name: "System", size: 18.0)
        let img = UIImage(systemName: "lock.slash")
        // let img = #imageLiteral(resourceName: "Delete").tint(with: .white)
        btnDeleteRfid.setImage(img?.tint(with: .white), for: .normal)
       // ViewFlip.isHidden  = true
       // ViewFlip.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
        btnDeleteRfid.setTitle("  BLOCK RFID", for: .normal)
        btnDeleteRfid.setTitleColor(.white, for: .normal)
        ViewBlock.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
        ViewBase.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(data:RfIdResult,indx:Int){
        self.isFlip = data.isFlip
       // btnDeleteRfid.tag = indx
        lblRfidV.text = data.rfid
        lblRfidSV.text = RFIDStatus.init(rawValue: data.status ?? "N")?.description
        img.image = #imageLiteral(resourceName: "LoginHeaderImage")
        btnDeleteRfid.setTitle("  \(data.btnTitle)", for: .normal)
       
        //flip()
    }
    /*
     func flip() {
        let transitionOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .showHideTransitionViews]

        UIView.transition(with: ViewBase, duration: 1.0, options: transitionOptions, animations: {
            if self.isFlip {
                self.ViewBase.isHidden = true
            }else{
                self.ViewBase.isHidden = false
            }
        })

        UIView.transition(with: ViewFlip, duration: 1.0, options: transitionOptions, animations: {
            if self.isFlip {
                self.ViewFlip.isHidden = false
            }else{
                self.ViewFlip.isHidden = true
            }
        })
    }*/
    @IBAction func deleteRfid(_ sender:UIButton){
        deleteSelectedRfid(sender.tag)
    }
}

enum RFIDStatus:String{
    case A
    case I
    case F
    case B
    case R
    case N
    
    var description:String {
        switch self {
        case .A:
            return "Available"
        case .I:
            return "Issued"
        case .F:
            return "Faulty"
        case .B:
            return "Blocked"
        case .R:
            return "Running"
        case .N:
            return "Not Found"
        }
    }
    
}
