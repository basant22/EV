//
//  Utility.swift
//  ChargePark
//
//  Created by apple on 24/06/1943 Saka.
//

import Foundation

struct AttrubutedString {
   static func creatAttributedStringOf(_ title1:String,_ title2:String) -> NSMutableAttributedString {
        let myAttribute1 = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray ]
        let attrString1 = NSAttributedString(string: title1, attributes: myAttribute1)
        let myAttribute2 = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
        // Initialize with a string and inline attribute(s)
        let attrString2 = NSAttributedString(string: title2, attributes: myAttribute2)
        let combination = NSMutableAttributedString()
        combination.append(attrString1)
        combination.append(attrString2)
        return combination
    }
    static func creatAttributedStringOfSize(_ size:CGFloat,_ title1:String,_ title2:String) -> NSMutableAttributedString {
       // let myAttributeFont = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size:size)! ]
         let myAttribute1 = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray ,NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size:size)!]
         let attrString1 = NSAttributedString(string: title1, attributes: myAttribute1)
        let myAttribute2 = [ NSAttributedString.Key.foregroundColor: Theme.menuHeaderColor,NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size:size)! ]
         // Initialize with a string and inline attribute(s)
         let attrString2 = NSAttributedString(string: title2, attributes: myAttribute2)
         let combination = NSMutableAttributedString()
         combination.append(attrString1)
         combination.append(attrString2)
         return combination
     }
    
}
public enum UIUserInterfaceIdiom: Int{
    case Iphone
    case Ipad
}

struct Defaults {
    static var shared = Defaults()
    var paymentType:Payment?
    var bookingType:BookingType?
    var userType:UserType?
    var isBookingCancell = false
    var userLogedIn : Bool?
    var userLocation:[String:Double] = [:]
    
   
    //let decoder = Decoder.container(keyedBy: ProfileResult.CodingKeys.self)
    var usrProfile:ProfileResult?  = ProfileResult()
    //ProfileResult(lastName: "", pincode: "", address: "", city: "", preferredStations: "", rfid: "", userGroup: "", balanceamount: 0,   totalChargingDuration: 0, opID: 0, vehicles: [""], firstName: "", totalConsumption: 0, state: "", userType: "", username: "")
    //ProfileResult(lastName: "", pincode: "", address: "", city: "", preferredStations: "", rfid: "", userGroup: "", balanceamount: 0,   totalChargingDuration: 0, opID: 0, vehicles: [""], firstName: "", totalConsumption: 0, state: "", userType: "", username: "")
    
   // var userLogin = ResultLogin(userID: 0, token: "", name: "", username: "", userEmail: "")
    var appConfig:App? = App()
//appName: "", paymentType: "", companyLogo: "", companyName: "", pgGateway: "", rzrpayKeyid: "", rzrpayKeysecret: "", appDescription: ""
    var userLogin:ResultLogin? =  ResultLogin()
    //ResultLogin(token: "", name: "", username: "", userEmail: "")
    var addedVehicle  = AddedVehicle()
    //AddedVehicle(result: nil, message: "", success: nil)
    var token = ""
    var favoriteStation:[ResultStation] = []
    private init(){}
    
    
}
enum FavStnFrom{
    case Menu
    case Map
}

enum Payment{
    case Pre
    case Instant
}
enum BookingBy{
    case QrCode(Bool)
    case General(Bool)
}
enum BookingType{
    case Active
    case General
}
enum TStatus:String{
    case Paid = "P"
    case Fail = "F"
    case Inprogress = "I"
    case Cancelled = "D"
}
enum UserType {
    case guest
    case logedIn
}
enum ChargingStatus:String{
    case I = "I"
    case R = "R"
    case E = "C"
    
    var status:String{
        switch self {
        case .I:
            return "Initialising"
        case .R:
            return "Charging"
        case .E:
            return "Error"
        }
    }
}
struct Formater {
   static var numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
 class Utils{
    class func saveProfileInfoInUserDefaults(data:ProfileResult){
          guard let data = try? JSONEncoder().encode(data) else {
            fatalError("unable encode as data")
          }
          UserDefaults.standard.set(data, forKey: Theme.ProfileInfo)
        
    }
     class func saveLoginInfoInUserDefaults(data:ResultLogin){
           guard let data = try? JSONEncoder().encode(data) else {
             fatalError("unable encode as data")
           }
         UserDefaults.standard.set(data, forKey: Theme.LoginInfo)
     }
     
     class func saveUserEvsInfoInUserDefaults(data:AddedVehicle){
           guard let data = try? JSONEncoder().encode(data) else {
             fatalError("unable encode as data")
           }
         UserDefaults.standard.set(data, forKey: Theme.VehicleInfo)
     }
     class func saveAppInfoInUserDefaults(data:App){
           guard let data = try? JSONEncoder().encode(data) else {
             fatalError("unable encode as data")
           }
         UserDefaults.standard.set(data, forKey: Theme.AppInfo)
     }
     class func getLoginFromUserDefaults(){
        // self.group.enter()
         guard let data = UserDefaults.standard.data(forKey: Theme.LoginInfo) else {
           // write your code as per your requirement
           return
         }
         guard let value = try? JSONDecoder().decode(ResultLogin.self, from: data) else {
           fatalError("unable to decode this data")
         }
         print(value)
         Defaults.shared.userLogin = value
         Defaults.shared.token = "JWT-" + (value.token ?? "")
        // self.group.leave()
     }
     class func getProfileFromUserDefaults()->Bool{
        // self.group.enter()
         guard let data = UserDefaults.standard.data(forKey: Theme.ProfileInfo) else {
           // write your code as per your requirement
           return false
         }
         guard let value = try? JSONDecoder().decode(ProfileResult.self, from: data) else {
           fatalError("unable to decode this data")
         }
         print(value)
         Defaults.shared.usrProfile = value
        // self.group.leave()
         return true
     }
     class func getUserEvsFromUserDefaults(){
         //self.group.enter()
         guard let data = UserDefaults.standard.data(forKey: Theme.VehicleInfo) else {
           // write your code as per your requirement
           return
         }
         guard let value = try? JSONDecoder().decode(AddedVehicle.self, from: data) else {
           fatalError("unable to decode this data")
         }
         print(value)
         Defaults.shared.addedVehicle = value
        // self.group.leave()
     }
     class func getAppFromUserDefaults(){
         //self.group.enter()
         guard let data = UserDefaults.standard.data(forKey: Theme.AppInfo) else {
           // write your code as per your requirement
           return
         }
         guard let value = try? JSONDecoder().decode(App.self, from: data) else {
           fatalError("unable to decode this data")
         }
         print(value)
         Defaults.shared.appConfig = value
        // self.group.leave()
     }
}

class MyGlobalTimer: NSObject {

   static let sharedTimer: MyGlobalTimer = MyGlobalTimer()
    var internalTimer: Timer?
    var duration = (0,0,0)
    var counter = 0
    var timerString = ""
    func startTimer(completion:(()->())?=nil){
//        guard self.internalTimer != nil else {
//            fatalError("Timer already intialized, how did we get here with a singleton?!")
//        }
        self.internalTimer = Timer.scheduledTimer(timeInterval: 1.0 /*seconds*/, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        completion?()
    }

    func stopTimer(){
        if self.internalTimer != nil {
            self.internalTimer?.invalidate()
            self.internalTimer = nil
        }
    }

//    @objc func fireTimerAction(sender: AnyObject?){
//        debugPrint("Timer Fired! \(String(describing: sender))")
//    }
    @objc func updateCounter() {
        if counter < 60 {
           // print("\(counter) seconds to the end of the world")
            timerString = "Duration: " + "\(self.duration.0)h : \(self.duration.1)m : \(self.counter)s"
          //  print("\(timerString)")
            counter += 1
            self.duration.2 = counter
            if self.duration.2 == 60 {
                self.duration.1 = 1 + self.duration.1
                self.counter = 0
            }
            if self.duration.1 == 60 {
                self.duration.0 = 1 + self.duration.0
                self.duration.1 = 0
            }
        }
    }
}

