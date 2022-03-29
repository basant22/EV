//
//  VehicleResource.swift
//  V-Power
//
//  Created by apple on 05/10/21.
//

import Foundation

/*
 {
     "result": {
         "userEVId": 2468,
         "username": "7503103938",
         "make": "Bajaj",
         "model": "Chetak",
         "year": 2020,
         "evRegNumber": "123412341234",
         "icon": "https://vapt.energybite.in/assets/images/Bajaj.png"
     },
     "message": "Ok",
     "success": true
 }
 */

struct AddVehicleRequest:Encodable {
    var userEVId :Int
    var year,model,evRegNumber,make,username:String
}
struct AddedVehicle: Codable {
    var result: [VehicleDeatil]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(){
        result = nil
        message = nil
        success = nil
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([VehicleDeatil].self, forKey: .result)
    }
}
struct AddNewVehicle: Codable {
    let result: VehicleDeatil?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(VehicleDeatil.self, forKey: .result)
    }
    
}
struct VehicleDeatil: Codable {
    let year,userEVId:Int?
    let username,make,model,evRegNumber,icon : String?
    enum CodingKeys: String, CodingKey {
        case userEVId,username,make,model,evRegNumber,icon,year
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userEVId = try? values.decode(Int.self, forKey: .userEVId)
        year = try? values.decode(Int.self, forKey: .year)
        username = try? values.decode(String.self, forKey: .username)
        make = try? values.decode(String.self, forKey: .make)
        model = try? values.decode(String.self, forKey: .model)
        evRegNumber = try? values.decode(String.self, forKey: .evRegNumber)
        icon = try? values.decode(String.self, forKey: .icon)
    }
}
struct Vehicle: Codable {
    let result: [VehicleList]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([VehicleList].self, forKey: .result)
    }
}
// MARK: - Result
struct VehicleList: Codable {
    let evTemplateID: Int?
    let make, model: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case evTemplateID = "evTemplateId"
        case make, model, icon
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        evTemplateID =  try? values.decode(Int.self, forKey: .evTemplateID)
        make =  try? values.decode(String.self, forKey: .make)
        model =  try? values.decode(String.self, forKey: .model)
        icon =  try? values.decode(String.self, forKey: .icon)
    }
}

struct AddVehicleValidation  {
    func validate(request: AddVehicleRequest) -> ValidationResult {
       
            if(request.username.count == 0){
                return ValidationResult(success: false, errorMessage: "User name is mandetory ")
            }else if(request.model.count == 0){
                return ValidationResult(success: false, errorMessage: "Please enter model of vehicle ")
            }else if(request.make.count == 0){
                return ValidationResult(success: false, errorMessage: "Please enter manufacture of vehicle ")
            }else if(request.year.count == 0){
                return ValidationResult(success: false, errorMessage: "Please enter model year")
            }else if(request.evRegNumber.count == 0){
                return ValidationResult(success: false, errorMessage: "Please enter registration No.")
            }
            else{
                return ValidationResult(success: true, errorMessage: nil)
            }
    }
}
struct AddVehicleResource{
    
    func addVehicle(request: AddVehicleRequest,connector:String,controller:UIViewController, completionHandler:@escaping (_ result: AddNewVehicle?)->()) {
        let validUrl = Theme.baseUrl + connector
        var urlRequest = URLRequest(url: URL(string: validUrl)!)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try! JSONEncoder().encode(request)

        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: AddNewVehicle.self) { (result) in
            _ = completionHandler(result)
        }

    }
}
struct AddedVehicleResource{
   
    func getAddedVehicleList(connector:String,userName:String,completionHandler:@escaping(_ result:AddedVehicle?)->()){
        let url = Theme.baseUrl + connector
        var urlComponents = URLComponents(string:url)! 
        urlComponents.queryItems = [
             URLQueryItem(name: "username", value: String(userName)),
        ]
        if let url = urlComponents.url{
            let urlRequest = URLRequest(url:url)
                HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: AddedVehicle.self) { (result) in
                    _ = completionHandler(result)
                }
             }
        }
}

