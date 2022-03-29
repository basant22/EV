//
//  StationRequest.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import Foundation
struct ResetPasswordRequest:Encodable {
    var username,password,token:String
}
struct ForgotResponse:Codable {
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
    }
}

struct ForgotPassword {
    func getOtpForForgotPassword(_ userName:String,connector:String, completionHandler:@escaping (_ result: ForgotResponse?)->()) {
        let url = Theme.baseUrl + connector
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: userName),
        ]
        if let url = urlComponents.url{
            let urlRequest = URLRequest(url:url)
            
            HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: ForgotResponse.self) { (result) in
                _ = completionHandler(result)
            }
        }
    }
}

struct ResetPassword {
    
    func resetPasswordForUser(request: ResetPasswordRequest,loginText:String,controller:UIViewController, completionHandler:@escaping (_ result: LoginResponse?)->()) {
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

struct StationResource {
    
    func getStationNearMyLocation(_ location:[String:Any],connector:String, completionHandler:@escaping (_ result: StationResponse?)->()) {
        let url = Theme.baseUrl + connector
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = [
             URLQueryItem(name: "lattitude", value: location["lat"] as? String),
             URLQueryItem(name: "longitude", value: location["long"] as? String)
        ]
        if let url = urlComponents.url{
        var urlRequest = URLRequest(url:url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            print("urlRequest=\(urlRequest)")
            print("token=\(Defaults.shared.token)")
            urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
            HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: StationResponse.self) { (result) in
                _ = completionHandler(result)
            }
            
            
            
           /* HttpUtility.shared.performDataTask(urlRequest: urlRequest) { data in
                do{
                    let realData = try JSONDecoder().decode(StationResponse.self, from: data)
                    completionHandler(realData)
                }catch let jsonErr{
                    print(jsonErr)
                }
            }*/
        }
    }
}



struct ChargerResources {
    func getChargerByStation(_ stationId:Int,connector:String, completionHandler:@escaping (_ result: ChargerResponse?)->()) {
        let url = Theme.baseUrl + connector
        
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = [
             URLQueryItem(name: "stationId", value: String(stationId)),
        ]
        if let url = urlComponents.url{
            var urlRequest = URLRequest(url:url)
            urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
                HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: ChargerResponse.self) { (result) in
                    _ = completionHandler(result)
                
            }
        }
    }
}
struct ProfileResource {
    func getProfileInfo(usrName:String,connector:String,completionHandler:@escaping(_ result:Profile?)->()){
        let url = Theme.baseUrl + connector
        
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = [
             URLQueryItem(name: "usrname", value: usrName)
        ]
        if let url = urlComponents.url{
        let urlRequest = URLRequest(url:url)
            HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: Profile.self) { (result) in
                _ = completionHandler(result)
            }
         }
      }
    }
struct vehicleResource {
    func getVehicleList(connector:String,completionHandler:@escaping(_ result:Vehicle?)->()){
        let url = Theme.baseUrl + connector
        let urlRequest = URLRequest(url:URL(string: url)!)
            HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: Vehicle.self) { (result) in
                _ = completionHandler(result)
            }
         }
       }

