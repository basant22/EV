//
//  BookingReq.swift
//  V-Power
//
//  Created by apple on 03/10/21.
//

import Foundation

//AppConfig

struct RemoveRfid:Codable {
    let result:String?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(String.self, forKey: .result)
    }
}
struct RfidRequest:Codable{
    let result: RfIdRequestResult?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(RfIdRequestResult.self, forKey: .result)
    }
}
struct RfIdRequestResult:Codable {
    let accountNonExpired:Bool?
    let accountNonLocked:Bool?
    let billing:String?
    let blockedrfid:String?
    let credentialsNonExpired:Bool?
    let email:String?
    let enabled:Bool?
    let firstName:String?
    let lastName:String?
    let password:String?
    let operatorId:String?
    let preferredPvtStation:String?
    let preferredStations:String?
    let rfid:String?
    let status:String?
    let balanceAmt:Double?
    let userName:String?
    let userGroup:String?
   
    enum CodingKeys: String, CodingKey {
        case accountNonExpired,
         accountNonLocked,
             billing,
         blockedrfid,
         credentialsNonExpired,
         email,
         enabled,
         firstName,
         lastName,
         password,
         operatorId,
         preferredPvtStation,
         preferredStations,
         rfid,
         status,
         balanceAmt,
         userName,
         userGroup
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rfid = try? values.decode(String.self, forKey: .rfid)
        status = try? values.decode(String.self, forKey: .status)
        userName = try? values.decode(String.self, forKey: .userName)
        operatorId = try? values.decode(String.self, forKey: .operatorId)
        userGroup = try? values.decode(String.self, forKey: .userGroup)
        preferredStations = try? values.decode(String.self, forKey: .preferredStations)
        preferredPvtStation = try? values.decode(String.self, forKey: .preferredPvtStation)
        password = try? values.decode(String.self, forKey: .password)
        balanceAmt = try? values.decode(Double.self, forKey: .balanceAmt)
        email = try? values.decode(String.self, forKey: .email)
        firstName = try? values.decode(String.self, forKey: .firstName)
        lastName = try? values.decode(String.self, forKey: .lastName)
        blockedrfid = try? values.decode(String.self, forKey: .blockedrfid)
        billing = try? values.decode(String.self, forKey: .billing)
        accountNonExpired = try? values.decode(Bool.self, forKey: .accountNonExpired)
        accountNonLocked = try? values.decode(Bool.self, forKey: .accountNonLocked)
        credentialsNonExpired = try? values.decode(Bool.self, forKey: .credentialsNonExpired)
        enabled = try? values.decode(Bool.self, forKey: .enabled)
    }
}
struct RfIdSelf:Codable {
    let result: RfIdResult?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(RfIdResult.self, forKey: .result)
    }
}
struct RfId:Codable {
    let result: [RfIdResult]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([RfIdResult].self, forKey: .result)
    }
}
struct RfIdResult:Codable {
    
    let rfid:String?
    let status:String?
    let balanceAmt:Double?
    let userName:String?
    let generationTime:String?
    let issuedTime:String?
    let validTime:String?
    let cardNo:String?
    let otp:String?
    var isFlip = false
    var btnTitle:String = "Block Rfid"
    enum CodingKeys: String, CodingKey {
        case rfid,status,balanceAmt,userName,generationTime,issuedTime,validTime,cardNo,otp
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rfid = try? values.decode(String.self, forKey: .rfid)
        status = try? values.decode(String.self, forKey: .status)
        userName = try? values.decode(String.self, forKey: .userName)
        generationTime = try? values.decode(String.self, forKey: .generationTime)
        issuedTime = try? values.decode(String.self, forKey: .issuedTime)
        validTime = try? values.decode(String.self, forKey: .validTime)
        cardNo = try? values.decode(String.self, forKey: .cardNo)
        otp = try? values.decode(String.self, forKey: .otp)
        balanceAmt = try? values.decode(Double.self, forKey: .balanceAmt)
    }
}


struct AppConfig: Codable {
    let result: App?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(App.self, forKey: .result)
    }
}

// MARK: - Result
struct App: Codable {
    let appName: String?
    let paymentType: String?
    let companyLogo, companyName:String?
    let pgGateway, rzrpayKeyid, rzrpayKeysecret, appDescription: String?

    enum CodingKeys: String, CodingKey {
        case appName = "app_name"
        case paymentType = "payment_type"
        case companyLogo = "company_logo"
        case companyName = "company_name"
        case pgGateway = "pg_gateway"
        case rzrpayKeyid = "rzrpay_keyid"
        case rzrpayKeysecret = "rzrpay_keysecret"
        case appDescription = "app_description"
    }
    init(){
        appName = nil
        paymentType = nil
        companyLogo = nil
        companyName = nil
        pgGateway = nil
        rzrpayKeyid = nil
        rzrpayKeysecret = nil
        appDescription = nil
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appName = try? values.decode(String.self, forKey: .appName)
        paymentType = try? values.decode(String.self, forKey: .paymentType)
        companyLogo = try? values.decode(String.self, forKey: .companyLogo)
        companyName = try? values.decode(String.self, forKey: .companyName)
        pgGateway = try? values.decode(String.self, forKey: .pgGateway)
        rzrpayKeyid = try? values.decode(String.self, forKey: .rzrpayKeyid)
        rzrpayKeysecret = try? values.decode(String.self, forKey: .rzrpayKeysecret)
        appDescription = try? values.decode(String.self, forKey: .appDescription)
    }
}
struct SavePaymentRequest:Encodable {
    var transactionId:Int
    var amount:Int
    var pgPaymentId:String
    var pgSIgnature:String
    var status:String
    var type:String
}
struct PaymentDetails: Codable {
    let result: [SavePaymentResult]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey{
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([SavePaymentResult].self, forKey: .result)
    }
}
struct SavePayments: Codable {
    let result: SavePaymentResult?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey{
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(SavePaymentResult.self, forKey: .result)
    }
}

// MARK: - Result
struct SavePaymentResult: Codable {
        let transactionID: Int?
        let type, pgOrderID, pgPaymentID: String?
        let bookingID: String?
        let appuserName: String?
        let amount: Int?
        let pgSIgnature: String?
        let status, pgOrderGenTime, lastUpdateTime, pgLog: String?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case type
        case pgOrderID = "pgOrderId"
        case pgPaymentID = "pgPaymentId"
        case bookingID = "bookingId"
        case appuserName, amount, pgSIgnature, status, pgOrderGenTime, lastUpdateTime, pgLog
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionID = try? values.decode(Int.self, forKey: .transactionID)
        amount = try? values.decode(Int.self, forKey: .amount)
        type = try? values.decode(String.self, forKey: .type)
        pgOrderID = try? values.decode(String.self, forKey: .pgOrderID)
        pgPaymentID = try? values.decode(String.self, forKey: .pgPaymentID)
        bookingID = try? values.decode(String.self, forKey: .bookingID)
        appuserName = try? values.decode(String.self, forKey: .appuserName)
        pgSIgnature = try? values.decode(String.self, forKey: .pgSIgnature)
        status = try? values.decode(String.self, forKey: .status)
        pgOrderGenTime = try? values.decode(String.self, forKey: .pgOrderGenTime)
        lastUpdateTime = try? values.decode(String.self, forKey: .lastUpdateTime)
        pgLog = try? values.decode(String.self, forKey: .pgLog)
        
    }
    
}
struct AddFundRequest:Encodable {
    var amount:Int
    var paymentId :String
}
struct MakeBookingPayment:Encodable {
    var paymentId :String
    var status : String
}
struct MakeBookingPaymentRespo:Codable {
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case message,success
    }
}
// MARK: - Welcome
struct AddFund: Codable {
    let result: AddFundDetails?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey{
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(AddFundDetails.self, forKey: .result)
    }
}
struct FavoriteStations: Codable {
    let result, message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey{
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(String.self, forKey: .result)
    }
}
// MARK: - Result
struct AddFundDetails: Codable {
    let transactionID: Int?
    let type, pgOrderID, pgPaymentID: String?
    let bookingID: String?
    let appuserName: String?
    let amount: Int?
    let pgSIgnature, status, pgOrderGenTime, lastUpdateTime: String?
    let pgLog: String?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case type
        case pgOrderID = "pgOrderId"
        case pgPaymentID = "pgPaymentId"
        case bookingID = "bookingId"
        case appuserName, amount, pgSIgnature, status, pgOrderGenTime, lastUpdateTime, pgLog
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionID = try? values.decode(Int.self, forKey: .transactionID)
        amount = try? values.decode(Int.self, forKey: .amount)
        type = try? values.decode(String.self, forKey: .type)
        pgOrderID = try? values.decode(String.self, forKey: .pgOrderID)
        pgPaymentID = try? values.decode(String.self, forKey: .pgPaymentID)
        bookingID = try? values.decode(String.self, forKey: .bookingID)
        appuserName = try? values.decode(String.self, forKey: .appuserName)
        pgSIgnature = try? values.decode(String.self, forKey: .pgSIgnature)
        status = try? values.decode(String.self, forKey: .status)
        pgOrderGenTime = try? values.decode(String.self, forKey: .pgOrderGenTime)
        lastUpdateTime = try? values.decode(String.self, forKey: .lastUpdateTime)
        pgLog = try? values.decode(String.self, forKey: .pgLog)
        
    }
}

struct ChargerBookingRequest:Encodable{
    var requested_stop_duration:Int?
    var requested_stop_time:String?
    var userEVId,chargingpoint,requested_stop_soc:Int?
    var chargerName,username,start_time,scheduleId,status,bookedvia,stopchargingby: String?
    var requested_stop_unit:Double?
//    {"userEVId":"2329","chargerName":"HPXIN008","chargingpoint":1,"username":"9999384551"}
}

 struct ChargerBookingResponse: Codable {
     let result: ResultChargerBooking?
     let message: String?
     let success: Bool?
     enum CodingKeys: String, CodingKey{
         case result,message,success
     }
     init(from decoder: Decoder) throws {
         let values = try decoder.container(keyedBy: CodingKeys.self)
         message = try? values.decode(String.self, forKey: .message)
         success = try? values.decode(Bool.self, forKey: .success)
         result = try? values.decode(ResultChargerBooking.self, forKey: .result)
     }
 }

 // MARK: - Result
 struct ResultChargerBooking: Codable {
    
     
     let amount: JSONNull?
     let bookTime,priceby: String?
     let location: JSONNull?
     let planId: JSONNull?
     let requestedStopDuration: JSONNull?
     let requestedStopTime: JSONNull?
     let requestedStopUnit: JSONNull?
     let vehicleChasis: JSONNull?
     let vehicleName: JSONNull?
     let pricing,taxes,tdamount,extracharges,damount:Double?
     let bookingID: Int?
     let billingType:String?
     let chargerName: String?
     let chargingpoint, userEVID: Int?
     let username, startTime, stopTime, discountcode: String?
     let status,bookedvia: String?
     let tranID: Int?
     let scheduleID:JSONNull?

     enum CodingKeys: String, CodingKey {
         case bookingID = "bookingId"
         case chargerName,chargingpoint,billingType,priceby
         case userEVID = "userEVId"
         case requestedStopDuration = "requested_stop_duration"
         case requestedStopTime = "requested_stop_time"
         case requestedStopUnit = "requested_stop_unit"
         case bookTime = "book_time"
         case username,vehicleChasis,vehicleName,amount,location,planId,pricing,taxes,tdamount,damount,extracharges,bookedvia
         case startTime = "start_time"
         case stopTime = "stop_time"
         case discountcode, status
         case tranID = "tran_id"
         case scheduleID = "scheduleId"
     }
     init(from decoder: Decoder) throws {
         let values = try decoder.container(keyedBy: CodingKeys.self)
         bookingID = try? values.decode(Int.self, forKey: .bookingID)
         chargerName = try? values.decode(String.self, forKey: .chargerName)
         chargingpoint = try? values.decode(Int.self, forKey: .chargingpoint)
         billingType = try? values.decode(String.self, forKey: .billingType)
         userEVID = try? values.decode(Int.self, forKey: .userEVID)
         username = try? values.decode(String.self, forKey: .username)
         startTime = try? values.decode(String.self, forKey: .startTime)
         stopTime = try? values.decode(String.self, forKey: .stopTime)
         discountcode = try? values.decode(String.self, forKey: .discountcode)
         status = try? values.decode(String.self, forKey: .status)
         tranID = try? values.decode(Int.self, forKey: .tranID)
         scheduleID = try? values.decode(JSONNull.self, forKey: .scheduleID)
         vehicleChasis = try? values.decode(JSONNull.self, forKey: .vehicleChasis)
         vehicleName = try? values.decode(JSONNull.self, forKey: .vehicleName)
         amount = try? values.decode(JSONNull.self, forKey: .amount)
         location = try? values.decode(JSONNull.self, forKey: .location)
         planId = try? values.decode(JSONNull.self, forKey: .planId)
         bookedvia = try? values.decode(String.self, forKey: .bookedvia)
         requestedStopDuration = try? values.decode(JSONNull.self, forKey: .requestedStopDuration)
         requestedStopTime = try? values.decode(JSONNull.self, forKey: .requestedStopTime)
         requestedStopUnit = try? values.decode(JSONNull.self, forKey: .requestedStopUnit)
         bookTime =  try? values.decode(String.self, forKey: .bookTime)
         pricing =  try? values.decode(Double.self, forKey: .pricing)
         taxes =  try? values.decode(Double.self, forKey: .taxes)
         tdamount =  try? values.decode(Double.self, forKey: .tdamount)
         extracharges =  try? values.decode(Double.self, forKey: .extracharges)
         damount =  try? values.decode(Double.self, forKey: .damount)
         priceby =   try? values.decode(String.self, forKey: .priceby)
     }
 }

 


// MARK: - Encode/decode helpers


struct validateBookingRequest {
    func validate(data:ChargerBookingRequest) -> ValidationResult {
        if data.userEVId == nil {
            return ValidationResult(success: false, errorMessage: "EV Id is not added")
        }else  if data.chargingpoint == nil {
            return ValidationResult(success: false, errorMessage: "Charging point(port) is not selected")
        }else if data.chargerName?.count == 0  {
            return ValidationResult(success: false, errorMessage: "Charger name is not selected")
        }else if data.username?.count == 0  {
            return ValidationResult(success: false, errorMessage: "User Name  is not added")
        }else{
            return ValidationResult(success: true, errorMessage: nil)
        }
    }
}
//Http request for Charger Booking
struct BookingResource{
    
    func chargerBooking(request: ChargerBookingRequest,connector:String,controller:UIViewController, completionHandler:@escaping (_ result: ChargerBookingResponse?)->()) {
        let validUrl = Theme.baseUrl + connector
       
        var urlRequest = URLRequest(url: URL(string: validUrl)!)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: ChargerBookingResponse.self) { (result) in
            _ = completionHandler(result)
        }

    }
}
struct validateAddedVehicle {
    func validate(data:[ShowVehicels]) -> ValidationResult {
        if data[0].selectedVehicle == nil || data[0].selectedVehicle?.count == 0 {
            return ValidationResult(success: false, errorMessage: "Please select manufacture")
        }else  if data[1].selectedModel == nil || data[1].selectedModel?.count == 0 {
            return ValidationResult(success: false, errorMessage: "Please select model")
        }else{
            return ValidationResult(success: true, errorMessage: nil)
        }
    }
}
// pragma Start Charging
struct StartChargingRequest:Encodable {
    var chargingpoint:String?
    var fromStatus,deviceId,requestStatus,bookingId:String?
    // {"fromStatus":"Available","chargingpoint":1,"deviceId":"HPXIN008","requestStatus":"StartTransaction"}
}
struct validateStartChargingRequest{
    func validate(request: StartChargingRequest) -> ValidationResult {
        if request.chargingpoint == nil {
            return ValidationResult(success: false, errorMessage: "Please select charging point")
        }else if request.deviceId == nil || request.deviceId?.count == 0 {
            return ValidationResult(success: false, errorMessage: "Charger Id is not select")
        }else{
            return ValidationResult(success: true, errorMessage: nil)
        }
    }
}

struct StartChargingResponse:Codable {
    let result: ResultStartCharging?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(ResultStartCharging.self, forKey: .result)
    }
}
struct ResultStartCharging:Codable {
    
}
struct StartChargingResource{
    
    func startCharging(request: StartChargingRequest,connector:String,controller:UIViewController, completionHandler:@escaping (_ result: StartChargingResponse?)->()) {
        let validUrl = Theme.baseUrl + connector
      
        var urlRequest = URLRequest(url: URL(string: validUrl)!)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: StartChargingResponse.self) { (result) in
            _ = completionHandler(result)
        }
    }
}


struct AfterStartChargingResource{
    func getStatusWhileCharging(connector:String,bookingId:String,completionHandler:@escaping(_ result:BookingStatus?)->()){
        let url = Theme.baseUrl + connector
        var urlComponents = URLComponents(string:url)! 
        urlComponents.queryItems = [
             URLQueryItem(name: "bookingId", value: String(bookingId)),
        ]
        if let url = urlComponents.url{
            var urlRequest = URLRequest(url:url)
            urlRequest.setValue( Defaults.shared.token, forHTTPHeaderField: "Authorization")
                HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: BookingStatus.self) { (result) in
                    _ = completionHandler(result)
                }
             }
        }
}

struct BookingStatus:Codable {
        let result: ResultBookingStatus?
        let message: String?
        let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(ResultBookingStatus.self, forKey: .result)
    }
}
    // MARK: - Result
struct ResultBookingStatus:Codable {
   
        let soc: Int?
        let startReading: String?
        let invoiceId,eVConnected: Int?
        let taxamount,amount,otherCharges,unit,price,discountamount,load,taxRate: Double?
        let startTime, stopTime,billingType,stopReading: String?
        let status: String?
        let chargingstatus,priceBy: String?
           
        enum CodingKeys: String, CodingKey {
            case amount, otherCharges
            case soc = "SOC"
            case priceBy = "PriceBy"
            case eVConnected = "EVConnected"
            case startReading, taxRate, unit, price,discountamount,load
            case invoiceId = "paymentId"
            case chargingstatus = "Chargingstatus"
            case taxamount, startTime, stopTime, stopReading, status,billingType
        }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try? values.decode(Double.self, forKey: .amount)
        otherCharges = try? values.decode(Double.self, forKey: .otherCharges)
        soc = try? values.decode(Int.self, forKey: .soc)
        startReading = try? values.decode(String.self, forKey: .startReading)
        priceBy = try? values.decode(String.self, forKey: .priceBy)
        stopReading = try? values.decode(String.self, forKey: .stopReading)
        startTime =  try? values.decode(String.self, forKey: .startTime)
        stopTime =  try? values.decode(String.self, forKey: .stopTime)
        status =  try? values.decode(String.self, forKey: .status)
        chargingstatus =  try? values.decode(String.self, forKey: .chargingstatus)
        billingType =  try? values.decode(String.self, forKey: .billingType)
        taxRate = try? values.decode(Double.self, forKey: .taxRate)
        unit = try? values.decode(Double.self, forKey: .unit)
        price = try? values.decode(Double.self, forKey: .price)
        discountamount = try? values.decode(Double.self, forKey: .discountamount)
        load = try? values.decode(Double.self, forKey: .load)
        invoiceId = try? values.decode(Int.self, forKey: .invoiceId)
        eVConnected = try? values.decode(Int.self, forKey: .eVConnected)
        taxamount = try? values.decode(Double.self, forKey: .taxamount)
    }
}

//MY BOOKING RESPONSE
struct MyBookings: Codable {
    let result: [Booking]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([Booking].self, forKey: .result)
    }
}

// MARK: - Result
struct Booking: Codable {
    /*
     let amount: Int
         let chargerName: String
         let startReading: Int
         let evRegistrationNumber: String
         let bookingID: Int
         let stationAddress: String
         let unit, price: Int
         let stationName, startTime: String
         let chargingPoint: Int
         let status: String
     */
    
    let status:String?
    let paymentId:String?
    let paymentDate:String?
    let amount,price,unit: Double?
    let chargerName: String?
    let startReading: Int?
    let evRegistrationNumber: String?
    let bookingID: Int?
    let stationAddress: String?
    
    let stationName, startTime, stopTime: String?
    let stopReading, chargingPoint: Int?
   // var isDownloaded = false
    enum CodingKeys: String, CodingKey {
        case amount, chargerName, startReading, evRegistrationNumber
        case bookingID = "bookingId"
        case stationAddress, unit, price, stationName, startTime, stopTime, stopReading, chargingPoint,status,paymentId,paymentDate
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decode(String.self, forKey: .status)
        paymentId = try? values.decode(String.self, forKey: .paymentId)
        paymentDate = try? values.decode(String.self, forKey: .paymentDate)
        chargerName = try? values.decode(String.self, forKey: .chargerName)
        evRegistrationNumber = try? values.decode(String.self, forKey: .evRegistrationNumber)
        stationAddress = try? values.decode(String.self, forKey: .stationAddress)
        stationName = try? values.decode(String.self, forKey: .stationName)
        startTime = try? values.decode(String.self, forKey: .startTime)
        stopTime = try? values.decode(String.self, forKey: .stopTime)
        stopReading = try? values.decode(Int.self, forKey: .stopReading)
        chargingPoint = try? values.decode(Int.self, forKey: .chargingPoint)
        startReading = try? values.decode(Int.self, forKey: .startReading)
        bookingID = try? values.decode(Int.self, forKey: .bookingID)
        amount = try? values.decode(Double.self, forKey: .amount)
        unit = try? values.decode(Double.self, forKey: .unit)
        price = try? values.decode(Double.self, forKey: .price)
    }
    
}

struct CancelBooking:Codable {
    let result: Cancel?
    let message: String?
    let success: Bool?
    
}
struct Cancel:Codable {
    
}
struct OccoupiedSlot:Codable {
    let result: String?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result, message, success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try? values.decode(String.self, forKey: .result)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
    }
}

struct PaytmLoad: Encodable {
    let amount, type: String
    let userInfo: UserInfo
}

// MARK: - UserInfo
struct UserInfo: Encodable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}

struct SavePatmRespo:Encodable {
    
    let transactionId:String?
    let pgPaymentId:String?
    let pgSIgnature:String?
    let status:String?
    let amount:Int?
    let pgLog:String?
}


