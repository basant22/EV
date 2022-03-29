//
//  TransactionCell.swift
//  ChargePark
//
//  Created by apple on 27/10/21.
//

import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var stackH:UIStackView!
    @IBOutlet weak var stackH1:UIStackView!
   
    @IBOutlet weak var lblTranTitle:UILabel!
    @IBOutlet weak var lblAmountTitle:UILabel!
    @IBOutlet weak var lblstatusTitle:UILabel!
    @IBOutlet weak var lblTranValue:UILabel!
    @IBOutlet weak var lblAmountValue:UILabel!
    @IBOutlet weak var lblstatusValue:UILabel!
    @IBOutlet weak var lblTimestampValue:UILabel!
    @IBOutlet weak var lblTimestampTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.cornerRadius(with: 8.0)
        viewContainer.layer.borderColor = Theme.menuHeaderColor.cgColor
        viewContainer.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setCellData(data:SavePaymentResult){
        if let transactionID = data.transactionID{
            lblTranValue.text =  String(transactionID)
        }
        if let amount = data.amount{
            lblAmountValue.text = "\u{20B9} " + String(amount)
        }
        if let status = data.status{
            if let StatusDescriptio = TStatus(rawValue: status) {
                switch StatusDescriptio {
                case .Paid:
                    lblstatusValue.text = "Paid"
                case .Inprogress:
                    lblstatusValue.text = "Inprogress"
                case .Fail:
                    lblstatusValue.text = "Fail"
                case .Cancelled:
                    lblstatusValue.text = "Cancelled"
                }
            }else{
                lblstatusValue.text = "N/A"
            }
        }else{
            lblstatusValue.text = "N/A"
        }
        if let dateTime = data.lastUpdateTime{
            lblTimestampValue.text = dateTime.convertDate()
            //dateTime.dateFormateForTransaction()
        }else{
            lblTimestampValue.text = "N/A"
        }
    }
}
