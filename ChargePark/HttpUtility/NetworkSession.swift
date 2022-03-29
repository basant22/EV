//
//  NetworkSession.swift
//  TestApp
//
//  Created by Utkarsh on 3/2/21.
//

import Foundation
import UIKit


class Alertfactory {
    static func alertWihMessage(title:String?,messsage:String,style:UIAlertController.Style,controller:UIViewController){
        let alert =  UIAlertController(title: title, message: messsage, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
class NetworkRequest {
    let session = URLSession.shared
    static var baseUrl = "https://reqres.in/api/"
    static var dataobj = Data()
    static func getRequest(urlString:String,controller:UIViewController) -> Data?  {
        let session = URLSession.shared
        let completurl  = baseUrl + urlString
        let urlComponents = URLComponents(string: completurl)
        // urlComponents?.query = ""
        //let url = URL(string:completurl)
        if let url = urlComponents?.url {
            let task = session.dataTask(with: url) { data, response, error in
                
                guard let jsonData = data else{
                    return
                }
                
                self.manageMessages(data: jsonData, response: response as? HTTPURLResponse, error: error!,controller: controller)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    self.dataobj = data!
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        return dataobj
    }
    
    static func postRequest(urlString:String,body:[String:Any],controller:UIViewController) -> Data?  {
        let completurl  = baseUrl + urlString
        let session = URLSession.shared
        
        var urlComponents = URLComponents(string: completurl)
        // urlComponents?.query = ""
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: "War & Peace"),
            URLQueryItem(name: "appid", value: "War & Peace")
        ]
        print("completurl=\(completurl)")
        print("body=\(body)")
        // let url = URL(string:completurl)
        if let url = urlComponents?.url{
            var request = URLRequest(url:url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
            let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
                guard let jsonData = data else{
                    return
                }
                self.manageMessages(data: jsonData , response: response as? HTTPURLResponse, error: error ?? nil,controller: controller)
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(json)
                    self.dataobj = data!
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        return dataobj
    }
    static func manageMessages(data:Data?,response:HTTPURLResponse?,error:Error?,controller:UIViewController)  {
        
        if error != nil || data == nil {
            print("Client error!")
            switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    // It's an iPhone
                    Alertfactory.alertWihMessage(title: nil, messsage: "Client error!", style: .actionSheet, controller: controller)
                case .pad:
                    // It's an iPad (or macOS Catalyst)
                    Alertfactory.alertWihMessage(title: nil, messsage: "Client error!", style: .alert, controller: controller)
            case .unspecified:
                print("none")
            case .tv:
                print("none")
            case .carPlay:
                print("none")
            case .mac:
                print("none")
                 @unknown default:
                    print("none")
                    // Uh, oh! What could it be?
                }
            
            return
        }
        
        guard let response = response, (200...299).contains(response.statusCode) else {
            print("Server error!")
            switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    // It's an iPhone
                    Alertfactory.alertWihMessage(title: nil, messsage: "Server error!", style: .actionSheet, controller: controller)
                case .pad:
                    // It's an iPad (or macOS Catalyst)
                    Alertfactory.alertWihMessage(title: nil, messsage: "Server error!", style: .alert, controller: controller)

            case .unspecified:
                print("none")
            case .tv:
                print("none")
            case .carPlay:
                print("none")
            case .mac:
                print("none")
            @unknown default:
                    print("none")
                    // Uh, oh! What could it be?
                }
            //Alertfactory.alertWihMessage(title: nil, messsage: "Server error!", style: .actionSheet, controller: controller)
            return
        }
        
        guard let mime = response.mimeType, mime == "application/json" else {
            print("Wrong MIME type!")
            switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    // It's an iPhone
                    Alertfactory.alertWihMessage(title: nil, messsage: "Wrong MIME type!", style: .actionSheet, controller: controller)
                case .pad:
                    // It's an iPad (or macOS Catalyst)
                    Alertfactory.alertWihMessage(title: nil, messsage: "Wrong MIME type!", style: .alert, controller: controller)

            case .unspecified:
                print("none")
            case .tv:
                print("none")
            case .carPlay:
                print("none")
            case .mac:
                print("none")
            @unknown default:
                    print("none")
                    // Uh, oh! What could it be?
                }
            //Alertfactory.alertWihMessage(title: nil, messsage: "Server error!", style: .actionSheet, controller: controller)
            return
        }
            Alertfactory.alertWihMessage(title: nil, messsage: "Wrong MIME type!", style: .actionSheet, controller: controller)
            return
        }
    }

class Network{
    //static let shared = Network()
    static let session = URLSession.shared
    static var baseUrl = "http://api.openweathermap.org/data/2.5/weather/"
    
    static func getServiceRequest(_ appendUrl:String,queryValue:[String:Any],onCompletion:@escaping(String?,Response,Error?)->())  {
        let completeUrl = Theme.baseUrl + appendUrl
            //+ appendUrl
        var urlComponents = URLComponents(string: completeUrl)!
        if appendUrl == "stationsnearlocation" {
            urlComponents.queryItems = [
               // URLQueryItem(name: "appid", value: queryValue["appid"] as? String),
                //URLQueryItem(name: "q", value: queryValue["q"] as? String),
                URLQueryItem(name: "lattitude", value: queryValue["lat"] as? String),
                URLQueryItem(name: "longitude", value: queryValue["long"] as? String)
            ]
        }
        if let url = urlComponents.url{
        Network.session.dataTask(with:url){ data, response, error in
        if error != nil || data == nil {
            onCompletion("Client error!",.failed,error)
            return
        }
            
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            onCompletion("Server error!",.failed,error)
            return
        }
        guard let mime = response.mimeType, mime == "application/json" else {
            onCompletion("Wrong MIME type!",.failed,error)
            return
        }
        do {
           // let strResponse = String(data: data!, encoding: .utf8)
           // print(strResponse)
           // let json = try JSONSerialization.jsonObject(with: data!, options: [])
            let json = try JSONSerialization.jsonObject(with: data ?? Data(), options:.allowFragments) as! [String:Any]
                             
            print(json)
            //,let dict1 = dict["content"]as? [[String:Any]]
//            if let dict = json as? [String:Any]{
//                                  print(dict)
//                              }
           // Network.kindOfResponse = .success
           // Network.responseData(json,.success)
            onCompletion(nil,.success(data),nil)
             
        } catch {
             onCompletion("JSON error",.failed,nil)
           // Network.responseData("JSON error",.failed)
        // Network.kindOfResponse = .failed
            //print("JSON error: \(error.localizedDescription)")
        }
       }.resume()
        }
    }
    
    static func postServiceRequest(_ appendUrl:String,body:Data? = nil,requestFor:String,authToken:String,onCompletion:@escaping(String?,Response,Error?)->()){
        let completeUrl = Theme.baseUrl + appendUrl
        let url = URL(string: completeUrl)
//        var urlComponents = URLComponents(string: completeUrl)!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "q", value: "War & Peace"),
//            URLQueryItem(name: "appid", value: "War & Peace")
//        ]
        if body != nil  {
         //   if let url = urlComponents.url{
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if requestFor == "sendEnrollmentOTP" || requestFor == "offers" || requestFor == "vouchers" || requestFor == "venues" {
                request.setValue(authToken, forHTTPHeaderField: "auth_token")
            }
            
            request.httpBody = body
            //request.httpBody = try? JSONSerialization.data(withJSONObject: body!, options: .prettyPrinted)
            Network.session.dataTask(with:request){ data, response, error in
                if error != nil || data == nil {
                    onCompletion("Client error!",.failed,error)
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    onCompletion("Server error!",.failed,error)
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    onCompletion("Wrong MIME type!",.failed,error)
                    return
                }
                guard let data = data else{
                    return
                }
                do {
                    print(mime)
                   // let js = try? JSONDecoder.de
                   // let json = try JSONSerialization.jsonObject(with: data, options:[])
                     let json = try JSONSerialization.jsonObject(with: data, options:.fragmentsAllowed) as! [String:Any]
                  
                   // let json = try JSONSerialization.jsonObject(with: data, options:.fragmentsAllowed)
                      print("\(requestFor) json=\(json)")
                   // let json = JSONDecoder.decode(<#T##self: JSONDecoder##JSONDecoder#>)
                    
                    onCompletion(nil,.success(data),nil)
                } catch {
                    onCompletion("JSON error",.failed,nil)
                }
            }.resume()
        }
       // }
    }
}

enum Response{
    case success(Data?)
    case failed
}
