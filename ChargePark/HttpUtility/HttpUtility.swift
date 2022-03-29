//
//  HttpUtility.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import Foundation

struct HttpUtility
{
    static let shared = HttpUtility()
    private init(){}

    func performDataTask<T:Codable>(urlRequest: URLRequest, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void){
        //func performDataTask(urlRequest: URLRequest, completionHandler:@escaping(_ result: Data)-> Void){
        
            print("URL= \(String(describing: urlRequest.url))")
        print("REQUEST = \(String(describing: urlRequest.httpBody))")
        URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
             
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                if let response = responseData {
                              //  print("response = \(response)")
                                  // completionHandler(response)
                  
                                }
//                if let response = responseData {
//                   // print("response = \(response)")
//                    completionHandler(response)
//                }else{
//                    debugPrint("error occured while decoding = \(String(describing: error?.localizedDescription))")
//                }
               
                
              //  if let data = response.data(using: String.Encoding.utf8) {
//                        do {
//                            let a = try JSONSerialization.jsonObject(with: responseData!, options: []) as? [String: Any]
//                            print("check \(a)")
//                        } catch {
//                            print("ERROR \(error.localizedDescription)")
//                        }
                  //  }
                
                
                
               
                do {
                    let result = try JSONDecoder().decode(T.self, from: responseData!)
                    if let json = try JSONSerialization.jsonObject(with: responseData!, options: [])
                        as? [String: Any]{
                       
                        print("response = \(String(describing: json))")
                    }
                            // try to read out a string array
//                            if let names = json["names"] as? [String] {
//                                print(names)
//                            }
                  
                    _=completionHandler(result)
                }
                catch let error{
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                }
            }

        }.resume()
        
    }
}


