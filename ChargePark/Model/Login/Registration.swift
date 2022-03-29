//
//  Registration.swift
//  ChargePark
//
//  Created by apple on 24/06/1943 Saka.
//

import Foundation

struct RegistrationResponse :Codable{
    let result: ResultRegistration?
    let message: String?
    let success: Bool?
}
struct ResultRegistration: Codable{
let balanceamount,opID: Int?
let address, city, email, firstName,lastName,state, userType,pincode,username: String?

enum CodingKeys: String, CodingKey {
    case balanceamount = "Balanceamount"
    case address, city, email, firstName, lastName,pincode, state, userType, username
    case opID = "opId"
}
}
struct RegistrationRequest : Encodable{
    var username,firstName,lastName,email,password:String
    var confPassword = ""
//    var firstName,lastName,pincode,password,address,city,state,email,username : String
    var opId,type : Int
    /*{"firstName":"avinash","lastName":"test","pincode":"201306","password":"Pulsar-123#","address":"test","city":"delhi","opId":1411,"state":"DADRA & NAGAR HAVELI","type":1,"email":"info@linuxmantra.com","username":"9873687551"}*/
}

struct RegistrationValidation {
    func validate(request: RegistrationRequest) -> ValidationResult {
        if request.firstName.isEmpty {
            return ValidationResult(success: false, errorMessage: "Plese enter first name")
        }else if request.lastName.isEmpty {
            return ValidationResult(success: false, errorMessage: "Plese enter last name")
        }else if request.username.isEmpty {
            return ValidationResult(success: false, errorMessage: "Plese enter mobile number")
        }else if request.username.count < 10 {
            return ValidationResult(success: false, errorMessage: "Plese enter valid mobile number")
        }else if request.email.isEmpty {
            return ValidationResult(success: false, errorMessage: "Plese enter email")
        }else if request.email.isValidEmail == false {
            return ValidationResult(success: false, errorMessage: "Plese enter valid email")
        }else if request.password.isEmpty {
            return ValidationResult(success: false, errorMessage: "Plese enter password")
        }else if request.password.count <= 7  {
            return ValidationResult(success: false, errorMessage: "Passwords must be 8(min) character")
        }else if request.confPassword.count == 0 {
            return ValidationResult(success: false, errorMessage: "Plese enter confirm password")
        }else if request.confPassword != request.password {
            return ValidationResult(success: false, errorMessage: "Passwords mismatch")
        }
//        else if request.address.isEmpty {
//            return ValidationResult(success: false, errorMessage: "Plese enter address")
//        }else if request.city.isEmpty {
//            return ValidationResult(success: false, errorMessage: "Plese enter city")
//        }else if request.state.isEmpty {
//            return ValidationResult(success: false, errorMessage: "Plese enter state")
//        }else if request.pincode.isEmpty {
//            return ValidationResult(success: false, errorMessage: "Plese enter pin code")
//        }
//        else if request.pincode.isValidPinCode() {
//            return ValidationResult(success: false, errorMessage: "Plese enter valid pin code")
//        }
        return ValidationResult(success: true, errorMessage: nil)
    }
}
struct RegistrationResource{
    
    func registerUer(request: RegistrationRequest,loginText:String, completionHandler:@escaping (_ result: RegistrationResponse?)->()) {
        let validUrl = Theme.baseUrl + loginText
        var urlRequest = URLRequest(url: URL(string: validUrl)!)
        urlRequest.httpMethod = "post"
       // urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        // let req:Data = try! JSONEncoder().encode(request)
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: RegistrationResponse.self) { (result) in
            _ = completionHandler(result)
        }
        
       /* HttpUtility.shared.performDataTask(urlRequest: urlRequest) { data in
            do{
                let realData = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                completionHandler(realData)
            }catch let jsonErr{
                print(jsonErr)
            }
        }*/
        
        
      //  Network.postServiceRequest(loginText, body: req, requestFor: "Registration", authToken: "") { msg, response, error in
           // print(response)
       // }
    //}
}
/*
struct States{
    var allStaesOfIndia:[String]!
    mutating func getAllStaes(){
        self.allStaesOfIndia = [("AP","Andhra Pradesh"),("AR","Arunachal Pradesh"),"AS|Assam","BR|Bihar","CT|Chhattisgarh","GA|Goa","GJ|Gujarat","HR|Haryana","HP|Himachal Pradesh","JK|Jammu and Kashmir","JH|Jharkhand","KA|Karnataka",
                                "KL|Kerala",
                                "MP|Madhya Pradesh",
                                "MH|Maharashtra",
                                "MN|Manipur",
                                "ML|Meghalaya",
                                "MZ|Mizoram",
                                "NL|Nagaland",
                                "OR|Odisha",
                                "PB|Punjab",
                                "RJ|Rajasthan",
                                "SK|Sikkim",
                                "TN|Tamil Nadu",
                                "TG|Telangana",
                                "TR|Tripura",
                                "UT|Uttarakhand",
                                "UP|Uttar Pradesh",
                                "WB|West Bengal",
                                "AN|Andaman and Nicobar Islands",
                                "CH|Chandigarh",
                                "DN|Dadra and Nagar Haveli",
                                "DD|Daman and Diu",
                                "DL|Delhi",
                                "LD|Lakshadweep",
                                "PY|Puducherry"]

    }
    func removePipeFromList() -> [String] {
        let state = allStaesOfIndia.map({$0.split(separator: "|").last})
    }
    
}
*/ 
}
struct ForgetPasswordRequest:Encodable {
    var username,password,token :String?
}
struct ForgotPasswordResource {
    func forgotPassword(request: ForgetPasswordRequest,connector:String, completionHandler:@escaping (_ result: RegistrationResponse?)->()) {
        let validUrl = Theme.baseUrl + connector
        var urlRequest = URLRequest(url: URL(string: validUrl)!)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: RegistrationResponse.self) { (result) in
            _ = completionHandler(result)
        }
    }
}
