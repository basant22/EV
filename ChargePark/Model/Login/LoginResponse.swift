//
//  LoginResponse.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct LoginResponse: Codable {
    let result: ResultLogin?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
}

// MARK: - Result
struct ResultLogin: Codable{
    //let userID: Int?
    let token ,name, username, userEmail: String?
    
    enum CodingKeys: String, CodingKey {
       // case userID = "userId"
        case token, name, username, userEmail
    }
    init(){
        token = nil
        name = nil
        username = nil
        userEmail = nil
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try? values.decode(String.self, forKey: .token)
        name = try? values.decode(String.self, forKey: .name)
        username = try? values.decode(String.self, forKey: .username)
        userEmail = try? values.decode(String.self, forKey: .userEmail)
    }
}


struct Profile: Codable {
    let result: ProfileResult?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try? values.decode(ProfileResult.self, forKey: .result)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
    }
}

struct ProfileResult: Codable {
    let lastName, pincode, address, city: String?
    let balanceamount: Double?
    let totalChargingDuration: Int?
    let blockedrfid: String?
    let vehicles: [String]?
    let firstName: String?
    let rfid: String?
    let totalConsumption: Double?
    let state, userType: String?
    let operatorID: Int?
    let userGroup:String?
    var preferredStations: String?
    let preferredPvtStation: String?
    let email, username, status: String?

    enum CodingKeys: String, CodingKey {
        case lastName, pincode, address, city
        case balanceamount = "Balanceamount"
        case totalChargingDuration, blockedrfid, vehicles, firstName, rfid, totalConsumption, state, userType
        case operatorID = "operatorId"
        case userGroup, preferredStations, email, username, status,preferredPvtStation
    }
    init(){
        lastName = ""
        firstName = ""
        pincode = ""
        address = ""
        city = ""
        state = ""
        userType = ""
        email = ""
        username = ""
        status = ""
        balanceamount = nil
        totalConsumption = nil
        operatorID = nil
        totalChargingDuration = nil
        vehicles = nil
        rfid = nil
        blockedrfid = nil
        userGroup = nil
        preferredStations  = nil
        preferredPvtStation = nil
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try? values.decode(String.self, forKey: .lastName)
        firstName = try? values.decode(String.self, forKey: .firstName)
        pincode = try? values.decode(String.self, forKey: .pincode)
        address = try? values.decode(String.self, forKey: .address)
        city = try? values.decode(String.self, forKey: .city)
        state = try? values.decode(String.self, forKey: .state)
        userType = try? values.decode(String.self, forKey: .userType)
        email = try? values.decode(String.self, forKey: .email)
        username = try? values.decode(String.self, forKey: .username)
        status = try? values.decode(String.self, forKey: .status)
        balanceamount = try? values.decode(Double.self, forKey: .balanceamount)
        totalConsumption = try? values.decode(Double.self, forKey: .totalConsumption)
        operatorID = try? values.decode(Int.self, forKey: .operatorID)
        totalChargingDuration = try? values.decode(Int.self, forKey: .totalChargingDuration)
        vehicles = try? values.decode([String].self, forKey: .vehicles)
        rfid = try? values.decode(String.self, forKey: .rfid)
        blockedrfid = try? values.decode(String.self, forKey: .blockedrfid)
        userGroup = try? values.decode(String.self, forKey: .userGroup)
        preferredStations  = try? values.decode(String.self, forKey: .preferredStations)
        preferredPvtStation  = try? values.decode(String.self, forKey: .preferredPvtStation)
    }
}
// MARK: - Result
/*
struct ProfileResult: Codable {
    /*
     Balanceamount = 0;
     address = "Greater Noida west";
     city = Noida;
     email = "04rajat@gmail.com";
     firstName = Rajat;
     lastName = Sharma;
     opId = 0;
     pincode = 201306;
     preferredStations = "<null>";
     rfid = "<null>";
     state = "UTTAR PRADESH";
     status = A;
     totalChargingDuration = 0;
     totalConsumption = 0;
     userGroup = "<null>";
     userType = P;
     username = 9990428334;
     */
    let lastName, pincode, address, city,preferredStations,rfid,userGroup: String?
    let balanceamount, totalChargingDuration, opID: Int?
    let vehicles: [String]?
    let firstName: String?
    let totalConsumption: Int?
    let state, userType, username: String?

    enum CodingKeys: String, CodingKey {
        case lastName, pincode, address, city,preferredStations,rfid,userGroup
        case balanceamount = "Balanceamount"
        case totalChargingDuration
        case opID = "opId"
        case vehicles, firstName, totalConsumption, state, userType, username
    }
}
*/
