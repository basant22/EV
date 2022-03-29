//
//  ControllerExtension.swift
//  ChargePark
//
//  Created by apple on 23/06/1943 Saka.
//

import Foundation
import UIKit

extension RegistrationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
                self.registraRequest.firstName = value
                cell.txtText.text = value
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
                self.registraRequest.lastName = value
                cell.txtText.text = value
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
                self.registraRequest.username = value
                cell.txtText.text = value
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
                self.registraRequest.email = value
                cell.txtText.text = value
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.tooglePText = { boolValue in
                self.passwordBool = boolValue
                self.tableView.reloadData()
            }
            cell.getTextvalue = { value,_ in
                self.password = value
                self.registraRequest.password = value
                cell.txtText.text = value
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.tooglePText = { boolValue in
                self.confirmPasswordBool = boolValue
                self.tableView.reloadData()
            }
            cell.getTextvalue = { value,_ in
                self.confirmPassword = value
               // self.registraRequest.password = value
                self.registraRequest.confPassword = value
                cell.txtText.text = value
            }
            
           
            return cell
        /*
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
                self.registraRequest.address = value
                cell.txtText.text = value
            }
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
                self.registraRequest.city = value
                cell.txtText.text = value
            }
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
              cell.selectionStyle = .none
            
            cell.getTextvalue = {_,_ in
                if #available(iOS 13.0, *) {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StateVC") as! StateVC
                    self.present(vc, animated: true, completion: nil)
                    vc.selectedState = { state in
                        self.registraRequest.state = state
                        cell.txtText.text = state
                    }
                }else{
                    let st = UIStoryboard(name: "Main", bundle: nil)
                    let vc = st.instantiateViewController(withIdentifier:"StateVC") as! StateVC
                    self.present(vc, animated: true, completion: nil)
                    vc.selectedState = { state in
                        self.registraRequest.state = state
                        cell.txtText.text = state
                    }
                }
            }
                
                
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
              cell.selectionStyle = .none
            cell.getTextvalue = { value,_ in
            self.registraRequest.pincode = value
            cell.txtText.text = value
            }
            return cell*/
            /*
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.selectionStyle = .none
            //cell.setUpButtonCell(Title: "Registration")
            cell.btnCell.cornerRadius(with: 6.0)
            cell.btnCell.setTitle("Registration", for: .normal)
            cell.btnCell.backgroundColor = Theme.menuHeaderColor
            cell.btnCell.setTitleColor(.white, for: .normal)
            cell.btnCell.titleLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
            cell.getButtonAction = {
                self.userRegistration(request: self.registraRequest)
            }
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.selectionStyle = .none
            cell.btnCell.cornerRadius(with: 6.0)
            cell.btnCell.setTitleColor(Theme.menuHeaderColor, for: .normal)
            cell.btnCell.setTitle("Already Registerd ? Login Here", for: .normal)
            cell.btnCell.backgroundColor = .clear
            cell.btnCell.layer.borderColor = Theme.menuHeaderColor.cgColor
            cell.btnCell.layer.borderWidth = 1.0
           // cell.btnCell.setTitleColor(.white, for: .normal)
            cell.btnCell.titleLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
            //cell.btnCell.setAttributedTitle(AttrubutedString.creatAttributedStringOfSize(18.0,"Already Registerd ?", " Login Here"), for: .normal)
            cell.getButtonAction = {
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
            return cell*/
            default:
            print("")
            }
           return UITableViewCell()
        }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            if let cell = cell as? TextCell{
                
                switch indexPath.row {
                case 0:
                    cell.txtText.text = self.registraRequest.firstName
                case 1:
                    cell.txtText.text = self.registraRequest.lastName
                case 2:
                    cell.txtText.text = self.registraRequest.username
                case 3:
                    cell.txtText.text = self.registraRequest.email
                case 4:
                    cell.txtText.text = self.registraRequest.password
                case 5:
                    cell.txtText.text = self.registraRequest.confPassword
                default:
                    print("")
                }
                cell.setDataToCell( self.dataSource[indexPath.row].1, image:self.dataSource[indexPath.row].0,tag: indexPath.row,controller: self as! RegistrationVC,passwordBool: self.passwordBool,confirmPasswordBool: self.confirmPasswordBool)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func userRegistration(request:RegistrationRequest) {
        let validation = RegistrationValidation()
        let validationResult = validation.validate(request:request)
        if validationResult.success {
           // let regRes = RegistrationResource()
            let api = ApiPostRequest()
            self.showLoader(message: "Registration...")
            api.kindOf(Theme.RegistrationConnector, requestFor: .REGISTRATION, request: request, response: RegistrationResponse.self) { [weak self] (response) in
                self?.hideLoader()
                DispatchQueue.main.async {
                    if let res = response,let _ = res.success,let msg =  res.message{
                        if msg  == "User already exists " {
                            self?.displayAlert(alertMessage: msg)
                        }else if msg  == "Ok"{
                            self?.performSegue(withIdentifier: "Login", sender: request.username)
                           // self?.displayAlert(alertMessage: "User registered successfully.")
                        }
                    }else{
                        
                    }
                }
            }
            
            
          /*  regRes.registerUer(request: request, loginText: Theme.RegistrationConnector) { [weak self] (response) in
                self?.hideLoader()
                DispatchQueue.main.async {
                    if let res = response,let _ = res.success,let msg =  res.message{
                        if msg  == "User already exists " {
                            self?.displayAlert(alertMessage: msg)
                        }else if msg  == "Ok"{
                            self?.displayAlert(alertMessage: "User registered successfully.")
                        }
                    }else{
                        
                    }
                }
            }*/
            
        }else{
            DispatchQueue.main.async {
                self.displayAlert(alertMessage: validationResult.errorMessage!)
            }
        }
    }
}
