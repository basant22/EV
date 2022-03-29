//
//  StationResponse.swift
//  ChargePark
//
//  Created by apple on 26/06/1943 Saka.
//

import Foundation
struct ChargerResponse: Codable {
    let result: [ResultCharger]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey{
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([ResultCharger].self, forKey: .result)
    }
}
struct ChargerResponseByQR: Codable {
    let result: ResultOfChargers?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey{
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode(ResultOfChargers.self, forKey: .result)
    }
}

struct ResultOfChargers: Codable {
    let charger: [ResultCharger]?
    let station: [Station]?
    enum CodingKeys: String, CodingKey{
        case charger,station
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        charger = try? values.decode([ResultCharger].self, forKey: .charger)
        station = try? values.decode([Station].self, forKey: .station)
    }
}

// MARK: - Result
struct ResultCharger: Codable {
    /*
     "chargerId": 2677,
                 "chargerName": "M2191027920107",
                 "label": "RWAOzone-FaridabadM2191027920107",
                 "cpIdentity": "ocppwsM21910279201",
                 "chargerType": "Bharat AC-001",
                 "category": "Slow",
                 "outputType": "AC",
                 "ocppStatus": "Connected",
                 "reportedTime": "2022-03-22T08:34:08.000+0000",
                 "ratedVoltages": "230",
                 "mode": "S",
                 "operationalHours": "24by7",
                 "number_of_chargingpoints": 3,
                 "chargerCapacity": 9.9,
                 "connector": "16A-3PIN",
                 "status": "A",
                 "price": 10.5,
                 "pricePerMinute": 0.0,
                 "pricePerHour": 0.0,
                 "othercharges": 0.0,
                 "discount": 0.0,
                 "protocol": "OCPP",
                 "ocppVersion": "1.6",
                 "chargingbyoptions": "UA",
                 "priceBy": "U",
     */
    let chargerID: Int?
    let chargerName, cpIdentity, chargerType, category,ocppStatus, reportedTime: String?
    let outputType, ratedVoltages,resultProtocol,operationalHours: String?
    let numberOfChargingpoints: Int?
    let chargerCapacity: Double?
    let connector, status,label,chargingbyoptions: String?
    let price,othercharges,discount,pricePerMinute,pricePerHour: Double?
    let chargerProtocol, ocppVersion, priceBy,mode,welcomeProtocol: String?
    var isSelected:Bool?
    var chargerPort: [ChargerPort]?
    
    enum CodingKeys: String, CodingKey {
        case chargerID = "chargerId"
        case chargerName, cpIdentity, chargerType, category, outputType, ratedVoltages
        case numberOfChargingpoints = "number_of_chargingpoints"
        case chargerCapacity, connector, status, price,label
        case chargerProtocol = "protocol"
        case ocppVersion, priceBy, chargerPort,ocppStatus,operationalHours, reportedTime,othercharges,discount,resultProtocol,mode,welcomeProtocol,pricePerMinute,pricePerHour,chargingbyoptions
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        chargerID = try? values.decode(Int.self, forKey: .chargerID)
        othercharges = try? values.decode(Double.self, forKey: .othercharges)
        discount = try? values.decode(Double.self, forKey: .discount)
        numberOfChargingpoints = try? values.decode(Int.self, forKey: .numberOfChargingpoints)
        price = try? values.decode(Double.self, forKey: .price)
        pricePerMinute = try? values.decode(Double.self, forKey: .pricePerMinute)
        pricePerHour = try? values.decode(Double.self, forKey: .pricePerHour)
        
        chargingbyoptions = try? values.decode(String.self, forKey: .chargingbyoptions)
        chargerName = try? values.decode(String.self, forKey: .chargerName)
        cpIdentity = try? values.decode(String.self, forKey: .cpIdentity)
        category = try? values.decode(String.self, forKey: .category)
        ocppStatus = try? values.decode(String.self, forKey: .ocppStatus)
        chargerType = try? values.decode(String.self, forKey: .chargerType)
        reportedTime = try? values.decode(String.self, forKey: .reportedTime)
        outputType = try? values.decode(String.self, forKey: .outputType)
        ratedVoltages = try? values.decode(String.self, forKey: .ratedVoltages)
        resultProtocol = try? values.decode(String.self, forKey: .resultProtocol)
        connector = try? values.decode(String.self, forKey: .connector)
        chargerProtocol = try? values.decode(String.self, forKey: .chargerProtocol)
        ocppVersion = try? values.decode(String.self, forKey: .ocppVersion)
        priceBy = try? values.decode(String.self, forKey: .priceBy)
        mode = try? values.decode(String.self, forKey: .mode)
        operationalHours = try? values.decode(String.self, forKey: .operationalHours)
        welcomeProtocol = try? values.decode(String.self, forKey: .welcomeProtocol)
        status = try? values.decode(String.self, forKey: .status)
        chargerCapacity = try? values.decode(Double.self, forKey: .chargerCapacity)
        label = try? values.decode(String.self, forKey: .label)
        
        if let _chargerPort = try? values.decode([ChargerPort].self, forKey: .chargerPort) {
            chargerPort = _chargerPort
        } else {
            chargerPort = []
        }
    }
}

/*
struct ResultCharger: Codable {
    let chargerID,numberOfChargingpoints,othercharges, discount: Int?
    let chargerName, cpIdentity, chargerType, category,outputType, ratedVoltages,connector, status,ocppVersion, priceBy: String?
    let chargerCapacity,price: Double?
    var isSelected:Bool?
    var chargerPort: [ChargerPort]?

    enum CodingKeys: String, CodingKey {
        case chargerID = "chargerId"
        case chargerName, cpIdentity, chargerType, category, outputType, ratedVoltages
        case numberOfChargingpoints = "number_of_chargingpoints"
        case chargerCapacity, connector, status, price, othercharges, discount, ocppVersion, priceBy, chargerPort
    }
}
*/
// MARK: - ChargerPort
struct ChargerPort: Codable {
    /*
     "usedSlots": null,
                        "freeSlots": null,
                        "slotInterval": 30,
     */
    let seqNumber,slotInterval: Int?
    let identificationNumber,usedSlots,freeSlots: String?
    let qrCodeFilePath: String?
    let isBusy: Bool?
    var isSele:Bool?
    enum CodingKeys: String, CodingKey {
        case seqNumber,identificationNumber,qrCodeFilePath,isBusy,usedSlots,freeSlots,slotInterval
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        seqNumber = try? values.decode(Int.self, forKey: .seqNumber)
        identificationNumber = try? values.decode(String.self, forKey: .identificationNumber)
        qrCodeFilePath = try? values.decode(String.self, forKey: .qrCodeFilePath)
        usedSlots = try? values.decode(String.self, forKey: .usedSlots)
        freeSlots = try? values.decode(String.self, forKey: .freeSlots)
        slotInterval = try? values.decode(Int.self, forKey: .slotInterval)
        isBusy = try? values.decode(Bool.self, forKey: .isBusy)
    }
}
struct Station: Codable {
    let stationName, stationAddress,icon: String?
    enum CodingKeys: String, CodingKey {
        case stationName,stationAddress,icon
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stationName = try? values.decode(String.self, forKey: .stationName)
        stationAddress = try? values.decode(String.self, forKey: .stationAddress)
        icon = try? values.decode(String.self, forKey: .icon)
    }
}
//extension ChargerPort{
//    let isSele:Bool!
//}
// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    
    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
struct StationResponse: Codable {
    let result: [ResultStation]?
    let message: String?
    let success: Bool?
    enum CodingKeys: String, CodingKey {
        case result,message,success
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? values.decode(String.self, forKey: .message)
        success = try? values.decode(Bool.self, forKey: .success)
        result = try? values.decode([ResultStation].self, forKey: .result)
    }
}
struct ResultStation:Codable {
    let stationID: Int?
    let operatorName:String?
    let stationname, address, contact, email,icon: String?
    let longitude, lattitude: Double?

    enum CodingKeys: String, CodingKey {
        case stationID = "stationId"
        case stationname, address, contact, email,icon, longitude, lattitude,operatorName
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stationID = try? values.decode(Int.self, forKey: .stationID)
        operatorName = try? values.decode(String.self, forKey: .operatorName)
        stationname = try? values.decode(String.self, forKey: .stationname)
        address = try? values.decode(String.self, forKey: .address)
        contact = try? values.decode(String.self, forKey: .contact)
        email = try? values.decode(String.self, forKey: .email)
        icon = try? values.decode(String.self, forKey: .icon)
        longitude = try? values.decode(Double.self, forKey: .longitude)
        lattitude = try? values.decode(Double.self, forKey: .lattitude)
       
    }
}
class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
