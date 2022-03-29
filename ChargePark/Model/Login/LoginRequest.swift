//
//  LoginRequest.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import Foundation

struct LoginRequest : Encodable{
   // var opId = 0
    var username,password: String
}
struct ValidationResult{
    let success: Bool
    let errorMessage: String?
}
struct LoginValidation  {
    func validate(request: LoginRequest) -> ValidationResult {
        if(request.username.count > 0 && request.password.count > 0){
            if(request.username.count == 10){
                return ValidationResult(success: true, errorMessage: nil)
            }else{
                return ValidationResult(success: false, errorMessage: "Please enter valid credentials")
            }
        }else if(request.username.count == 0){
            return ValidationResult(success: false, errorMessage: "Please enter mobile number")
        }else if(request.password.count == 0){
            return ValidationResult(success: false, errorMessage: "Please enter password")
        }
        return ValidationResult(success: false, errorMessage: "Please enter valid credentials")
    }
}
struct LoginResource{
    
    func authenticateUser(request: LoginRequest,loginText:String,controller:UIViewController, completionHandler:@escaping (_ result: LoginResponse?)->()) {
        let validUrl = Theme.baseUrl + loginText
        var urlRequest = URLRequest(url: URL(string: validUrl)!)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: LoginResponse.self) { (result) in
            _ = completionHandler(result)
        }

    }
}

