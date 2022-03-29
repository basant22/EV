//
//  NewTextCell.swift
//  ChargePark
//
//  Created by apple on 15/10/21.
//

import UIKit
import SkyFloatingLabelTextField
class NewTextCell: UITableViewCell {
    @IBOutlet var txtText:SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var imgDrop:UIImageView!
    var getTextData :((String,Int?) -> ()) = {_,_ in}
    var pickerSource:[String] = []
    var vehicleList:[VehicleList]?
    var model:[String] = []
    var controller:UIViewController!
    lazy var picker: GMPicker = {
        let dPicker = GMPicker()
        return dPicker
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtText.selectedTitleColor = Theme.menuHeaderColor
        txtText.selectedLineColor = Theme.menuHeaderColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(data:ShowVehicels)  {
        self.controller = data.controller
        txtText.placeholder = data.placeHolder
        txtText.iconImage = data.image
        txtText.tag = data.index
        txtText.delegate = self
        self.picker.delegate = self
        if let source = data.addedModel ,data.index == 1 {
            self.model = source
            txtText.text = data.selectedModel ?? ""
        }
    }
}
extension  NewTextCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            if self.controller is BookingStatusVC {
                //setupPickerForModelBooking()
                picker.delegate = self
                picker.titleText = "Selec Model"
                if model.count > 1 {
                    let vehicleModels = model.compactMap({$0})
                    picker.setup(for: vehicleModels)
                    picker.show(inVC: self.controller)
                }else if model.count != 1{
                    self.controller.displayAlert(alertMessage: "Select vehicle first")
                }
            }
            return false
        default:
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1,9:
            return false
        default:
            textField.resignFirstResponder()
            return true
        }
    }
}
extension  NewTextCell:GMPickerDelegate{
    func gmPicker(_ gmPicker: GMPicker, didSelect string: String, at index: Int) {
        print("\(string)\(index)")
        
        self.getTextData(string,index)
    }
    
    func gmPickerDidCancelSelection(_ gmPicker: GMPicker) {
        
    }
    
    
}
