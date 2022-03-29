//
//  NetworkRequests.swift
//  ChargePark
//
//  Created by apple on 17/10/21.
//

import Foundation

struct ApiGetRequest {
    func kindOf<T:Codable>(_ connector:String,requestFor:RequestForGet,queryString:[String?],response:T.Type?,completionHandler:@escaping(_ result:T?)->()){
        let url = Theme.baseUrl + connector
        var urlComponents = URLComponents(string:url)!
        var urlRequest = URLRequest(url:URL(string: url)!)
        
        switch requestFor {
        case .PROFILE,.MY_BOOKINGS,.FORGOT_PASSWORD_OTP,.VEHICLE_LIST,.ACTIVE_BOOKING:
            if let username = queryString.first {
                urlComponents.queryItems = [
                    URLQueryItem(name: "username", value: username)
                ]
            }
        case .CHARGER_PORT_BY_STATION:
            if let stationId = queryString.first as? String , let charger = queryString[1], let port = queryString[2] {
                urlComponents.queryItems = [
                    URLQueryItem(name: "stationId", value: stationId),
                    URLQueryItem(name: "charger", value: charger),
                    URLQueryItem(name: "port", value: port)
                ]
            }
        case .GET_BOOKED_SCHEDULED_BY_DATE:
            if let charger = queryString.first as? String , let port = queryString[1], let stationId = queryString[2] {
                urlComponents.queryItems = [
                    URLQueryItem(name: "ChargerName", value: charger),
                    URLQueryItem(name: "ChargerPort", value: port),
                    URLQueryItem(name: "ForDate", value: stationId)
                ]
            }
        case .NEARBY_STATIONS:
            if let lat = queryString.first as? String , let long = queryString[1] {
                urlComponents.queryItems = [
                    URLQueryItem(name: "lattitude", value: lat),
                    URLQueryItem(name: "longitude", value: long)
                ]
            }
        case .CHARGER_STATUS_AT_STATIONS:
            print("")
            if let stationId = queryString.first {
                urlComponents.queryItems = [
                    URLQueryItem(name: "stationId", value: stationId),
                ]
            }
        case .CHANGE_BOOKING_STATUS,.BOOKING_INFO,.CHANGE_CHARGER_STATUS,.DOWNLOAD_INVOICE:
            if let stationId = queryString.first {
                urlComponents.queryItems = [
                    URLQueryItem(name: "bookingId", value: stationId),
                ]
            }
        case .RFIF_RFID:
            if let rfid = queryString.first {
                urlComponents.queryItems = [
                    URLQueryItem(name: "rfid", value: rfid),
                ]
            }
        case .GET_PAYMENT_GATWAY,.PAYMENT_DETAILS,.APP_CONFIG,.RFIF_USERNAME,.RFIF_REMOVE,.RFIF_REQUEST:
            print("")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        if let url = urlComponents.url{
            urlRequest = URLRequest(url:url)
            print("urlRequest=\(urlRequest)")
            print("token=\(Defaults.shared.token)")
            urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
        }
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: T.self) { (result) in
            _ = completionHandler(result)
        }
    }
}

struct ApiPostRequest {
    func kindOf<R:Encodable,T:Codable>(_  connector:String,requestFor:RequestForPost,request:R,response:T.Type,completionHandler:@escaping(_ results:T?)->()){
        let url = Theme.baseUrl + connector
        print("URL=\(url)")
        let urlComponents = URLComponents(string:url)!
        var urlRequest = URLRequest(url: URL(string: url)!)
        
        switch requestFor {
        case.LOGIN:
            urlRequest.httpBody = try! JSONEncoder().encode(request)
            urlRequest.httpMethod = "post"
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            print("Request=\(request)")
        case .REGISTRATION,.RESET_FORGOT_PASSWORD,.ADD_VEHICLE,.START_CHARGING,.STATUS_AFTER_START_CHARGING,.MAKE_PAYMENT,.SAVE_PAYMENT,.CHARGER_BOOKING,.MAKE_BOOKING_PAYMENT,.FAVORITE_STATIONS:
            print("Request=\(request)")
            if let url = urlComponents.url{
                urlRequest = URLRequest(url:url)
                print("Token=\(Defaults.shared.token)")
                urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
                urlRequest.httpMethod = "post"
                urlRequest.httpBody = try! JSONEncoder().encode(request)
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            }
        }
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: T.self) { (results) in
            _ = completionHandler(results)
        }
    }
}
enum RequestType:String{
    case get
    case post
}

enum RequestForGet{
    case PROFILE
    case FORGOT_PASSWORD_OTP
    case NEARBY_STATIONS
    case CHARGER_STATUS_AT_STATIONS
    case VEHICLE_LIST
    case MY_BOOKINGS
    case CHANGE_BOOKING_STATUS
    case CHANGE_CHARGER_STATUS
    case GET_PAYMENT_GATWAY
    case PAYMENT_DETAILS
    case APP_CONFIG
    case ACTIVE_BOOKING
    case BOOKING_INFO
    case CHARGER_PORT_BY_STATION
    case RFIF_USERNAME
    case RFIF_RFID
    case RFIF_REQUEST
    case RFIF_REMOVE
    case GET_BOOKED_SCHEDULED_BY_DATE
    case DOWNLOAD_INVOICE
    
}
enum RequestForPost{
    case LOGIN
    case REGISTRATION
    case RESET_FORGOT_PASSWORD
    case ADD_VEHICLE
    case START_CHARGING
    case STATUS_AFTER_START_CHARGING
    case MAKE_PAYMENT
    case SAVE_PAYMENT
    case CHARGER_BOOKING
    case MAKE_BOOKING_PAYMENT
    case FAVORITE_STATIONS
}
