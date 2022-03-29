//
//  TextCell.swift
//  ChargePark
//
//  Created by apple on 23/06/1943 Saka.
//

import UIKit
import SkyFloatingLabelTextField
class TextCell: UITableViewCell {
    @IBOutlet var txtText:SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var imgDrop:UIImageView!
    @IBOutlet var btnRight:UIButton!
    
    var tooglePText:((Bool)->()) = {_ in}
    var passwordBool = false
    var confirmPasswordBool = false
    var getTextvalue :((String,Int?) -> ()) = {_,_ in}
    var pickerSource:[String] = []
    var vehicleList:[VehicleList]?
    var modelAndEvId:[String] = []
    var controller:UIViewController!
    lazy var picker: GMPicker = {
        let dPicker = GMPicker()
        return dPicker
    }()
    lazy var datePicker: GMDatePicker = {
        let dPicker = GMDatePicker()
        return dPicker
    }()
    lazy var df : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: BookingStatus ---------------------------------
    func AddDataForBookingStatusCell(data:ShowVehicels){
        self.controller = data.controller
        txtText.placeholder = data.placeHolder
        txtText.iconImage = data.image
        txtText.tag = data.index
        txtText.delegate = self
        btnRight.isHidden = true
        btnRight.isUserInteractionEnabled = false
        if let source = data.addedVehicle,data.index == 0  {
            self.pickerSource = source
            txtText.text = data.selectedVehicle ?? ""
        }
        else if let source = data.addedModel ,data.index == 1 {
            self.modelAndEvId = source
            txtText.text = data.selectedModel ?? ""
        }
        else if let source = data.addedRegNo,data.index == 2  {
            self.pickerSource = source
            txtText.text = data.selectedReg ?? ""
        }
        switch data.index {
        case 0,1:
            imgDrop.isHidden = false
        case 2:
            imgDrop.isHidden = true
        default:
            imgDrop.isHidden = true
        }
    }
    // MARK: AddVehicle ---------------------------------
    func AddDataToCell(_ placeHolder:String,image:UIImage,make:[String]?,model:[VehicleList]? = nil,index:Int,controller:UIViewController,selectedText: String?)  {
        if let source = make,index == 0  {
            self.pickerSource = source
        }
       else if let source = model ,index == 1 {
            self.vehicleList = source
        }
       else if let source = make,index == 2  {
            self.pickerSource = source
        }
        btnRight.isHidden = true
        btnRight.isUserInteractionEnabled = false
        txtText.text = selectedText
        self.controller = controller
        txtText.placeholder = placeHolder
        txtText.iconImage = image
        txtText.tag = index
        txtText.delegate = self
        switch index {
        case 0,1,2:
            imgDrop.isHidden = false
        default:
            imgDrop.isHidden = true
        }
    }
    // MARK: Registration ---------------------------------
    func setDataToCell(_ placeHolder:String,image:UIImage,tag:Int,controller:UIViewController,passwordBool:Bool,confirmPasswordBool:Bool){
        self.controller = controller
        txtText.placeholder = placeHolder
        txtText.autocorrectionType = .no
        txtText.iconImage = image
        txtText.tag = tag
        txtText.delegate = self
        self.passwordBool = passwordBool
        self.confirmPasswordBool = confirmPasswordBool
        if placeHolder == "Password" {
            btnRight.tag = 4
        }
        if placeHolder == "Confirm Password" {
            btnRight.tag = 5
        }
        if placeHolder == "Password" || placeHolder == "Confirm Password" {
            self.btnRight.isUserInteractionEnabled = true
        }else{
            self.txtText.isSecureTextEntry = false
            self.btnRight.isUserInteractionEnabled = false
        }
        if placeHolder == "Password"{
        if self.passwordBool {
            self.imgDrop.image = #imageLiteral(resourceName: "Show")
            self.txtText.isSecureTextEntry = false
        }else{
            self.imgDrop.image = #imageLiteral(resourceName: "Hide")
            self.txtText.isSecureTextEntry = true
        }
      }
    if placeHolder == "Confirm Password" {
        if self.confirmPasswordBool {
            self.imgDrop.image = #imageLiteral(resourceName: "Show")
            self.txtText.isSecureTextEntry = false
        }else{
            self.imgDrop.image = #imageLiteral(resourceName: "Hide")
            self.txtText.isSecureTextEntry = true
        }
    }
        switch tag {
        case 2,9:
        txtText.keyboardType = .numberPad
            imgDrop.isHidden = true
        case 8:
            imgDrop.isHidden = false
        case 4,5:
        imgDrop.isHidden = false
        default:
            imgDrop.isHidden = true
        }
    }
    @IBAction func textChange(_ sender: SkyFloatingLabelTextFieldWithIcon) {
        switch sender.tag {
        case 8:
            print("")
        case 3:
             if self.controller is AddVehicleController || self.controller is RegistrationVC {
             getTextvalue(sender.text ?? "",sender.tag)
             }
        case 0,1,2,4,5,6,7,9:
            if (self.controller is RegistrationVC)   {
            getTextvalue(sender.text ?? "",sender.tag)
            }
        default:
            if !(self.controller is BookingStatusVC)   {
            getTextvalue(sender.text ?? "",sender.tag)
            }
        }
    }
    
    func setupPicker(title:String){
        picker.delegate = self
        picker.titleText = title
        if self.pickerSource.count > 1 {
            picker.setup(for: self.pickerSource)
            picker.show(inVC: self.controller)
            picker.layoutIfNeeded()
        }
    }
    func setupPickerForModel(){
        picker.delegate = self
        picker.titleText = "Selec Model"
        if let list = vehicleList{
            if list.count > 1 {
                let vehicleModels = list.compactMap({$0.model})
                picker.setup(for: vehicleModels)
                picker.show(inVC: self.controller)
                picker.layoutIfNeeded()
            }else if list.count != 1 {
                self.controller.displayAlert(alertMessage: "Select manufacturer first")
            }
        }
    }
    
    func setupPickerForModelBooking(){
        picker.delegate = self
        picker.titleText = "Selec Model"
        if modelAndEvId.count > 1 {
            let vehicleModels = modelAndEvId.compactMap({$0})
            picker.setup(for: vehicleModels)
            picker.show(inVC: self.controller)
            picker.layoutIfNeeded()
        }else if modelAndEvId.count != 1{
            self.controller.displayAlert(alertMessage: "Select vehicle first")
        }
    }
    @IBAction func btnRight(_ sender:UIButton){
        let tag = sender.tag
        switch tag {
        case 4:
            if passwordBool {
                self.tooglePText(!passwordBool)
            }else{
                self.tooglePText(!passwordBool)
            }
           
        case 5:
            if confirmPasswordBool {
                self.tooglePText(!confirmPasswordBool)
            }else{
                self.tooglePText(!confirmPasswordBool)
            }
            
        default:
            print("")
        }
        
    }
}
extension  TextCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 8:
            getTextvalue("Select State",textField.tag)
            return false
        case 0:
            if self.controller is AddVehicleController  {
                setupPicker(title: "Manufacture By")
            }else if self.controller is BookingStatusVC {
                setupPicker(title: "Select Vehicle")
            }else if self.controller is RegistrationVC {
                return true
            }
            return false
        case 1:
            if self.controller is AddVehicleController  {
                setupPickerForModel()
                return false
            }else if self.controller is BookingStatusVC {
                //setupPickerForModelBooking()
                picker.delegate = self
                picker.titleText = "Selec Model"
                if modelAndEvId.count > 1 {
                    let vehicleModels = modelAndEvId.compactMap({$0})
                    picker.setup(for: vehicleModels)
                    picker.show(inVC: self.controller)
                }else if modelAndEvId.count != 1{
                    self.controller.displayAlert(alertMessage: "Select vehicle first")
                }
                return false
            }else{
            return true
            }
        case 2:
            if self.controller is AddVehicleController  {
            setupPicker(title: "Select Year")
                return false
            }else if self.controller is BookingStatusVC {
                
                if pickerSource.count > 1 {
                   // picker.delegate = self
                   // picker.setup(for: pickerSource)
                   // picker.show(inVC: self.controller)
                }else if pickerSource.count == 0{
                    self.controller.displayAlert(alertMessage: "Select vehicle and model first")
                }
                return false
            }else{
                return true
            }
        default:
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case  0,1,2,3,4,5,6,7,9:
            if self.controller is RegistrationVC {
                textField.resignFirstResponder()
                return true
            }else{
            return false
            }
        case 8:
            return false
        default:
            textField.resignFirstResponder()
            return true
        }
    }
}
extension  TextCell:GMPickerDelegate{
    func gmPicker(_ gmPicker: GMPicker, didSelect string: String, at index: Int) {
        print("\(string)\(index)")
        self.getTextvalue(string,index)
    }
    
    func gmPickerDidCancelSelection(_ gmPicker: GMPicker) {
        
    }
    
    
}

