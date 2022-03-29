//
//  Extensions.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import Foundation
import UIKit
import Network
import Kingfisher
import JWTDecode
protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}
extension Dictionary {
    func converToJson()->String{
        if let theJSONData = try?  JSONSerialization.data(
              withJSONObject: self,
              options: .prettyPrinted
              ),
              let theJSONText = String(data: theJSONData,
                                       encoding: String.Encoding.ascii) {
                  print("JSON string = \n\(theJSONText)")
            return theJSONText
            }
        return ""
          }
    }

struct Storyboard{
   static var rearVC = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
    static var frontVC = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationViewController") as? StationViewController
    static var loginVc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
    static let frontVCNavigation = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "StationNavigation") as? UINavigationController 
}
extension UIView{
    
    
      // ->1
      enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
      }
   
      func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                    direction: Direction = .leftToRight,
                                    repeatCount: Float = MAXFLOAT) {
        
        // Create color  ->2
          let lightColor = Theme.newGreen
          //UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
          let blackColor = Theme.menuHeaderColor.cgColor
              
              // Create a CAGradientLayer  ->3
              let gradientLayer = CAGradientLayer()
              gradientLayer.colors = [blackColor, lightColor, blackColor]
              gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
              
              switch direction {
              case .topToBottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
              case .bottomToTop:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                
              case .leftToRight:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                
              case .rightToLeft:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
              }
              
              gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
              self.layer.mask = gradientLayer
              
              // Add animation over gradient Layer  ->4
              CATransaction.begin()
              let animation = CABasicAnimation(keyPath: "locations")
              animation.fromValue = [0.0, 0.1, 0.2]
              animation.toValue = [0.8, 0.9, 1.0]
              animation.duration = CFTimeInterval(animationSpeed)
              animation.repeatCount = repeatCount
              CATransaction.setCompletionBlock { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.layer.mask = nil
              }
              gradientLayer.add(animation, forKey: "shimmerAnimation")
              CATransaction.commit()
            }
       
      
      func stopShimmeringAnimation() {
        self.layer.mask = nil
      }
      

 //   extension Bluring where Self: UIView {
        func addBlur(_ alpha: CGFloat = 0.45) {
            // create effect
            let effect = UIBlurEffect(style: .extraLight)
            let effectView = UIVisualEffectView(effect: effect)

            // set boundry and alpha
            effectView.frame = self.bounds
            effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            effectView.alpha = alpha

            self.addSubview(effectView)
        }
   // }
    func setGradientBackground(colorTop:UIColor,colorBottom:UIColor) {
        let colorTop =  colorTop.cgColor
       // let colorBottom = UIColor.red.cgColor
        let colorBottom = colorBottom.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
       // gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    func cornerRadius(with value:CGFloat){
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    func cornerRadiusWitBorder(with value:CGFloat,border:UIColor){
        self.layer.cornerRadius = value
        self.layer.borderWidth = 1.0
        self.layer.borderColor = border.cgColor
        self.layer.masksToBounds = true
    }
   
    func round(corners: CACornerMask, radius: CGFloat,color:UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
        //[.layerMinXMinYCorner, .layerMaxXMaxYCorner]
}

extension String {
    
    func concatenateUnit() -> String{
        if self == "M"{
            return "/min"
        }else if self == "U"{
            return "/unit"
        }
        return "/unit"
    }
    func isValidPinCode() -> Bool    {
      let pinRegex = "^[0-9]{6}$";
        let pinTest = NSPredicate(format: "SELF MATCHES %@", pinRegex)
        return pinTest.evaluate(with: self)
    }
    var isValidPhone : Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{10,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: self)
        }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    var isValidEmail: Bool {
          let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
         // let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let testEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return testEmail.evaluate(with: self)
       }
    func validateEmail() -> Bool{
        let regex = try! NSRegularExpression(pattern: "(^[0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,64}$)", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
    }
}
extension UIViewController{

    func logOut(){
        let story = UIStoryboard(name: "Main", bundle:nil)
        if let rootVC = story.instantiateViewController(withIdentifier: "PreLoginVC") as? PreLoginVC,let window = UIApplication.shared.windows.first{
           // self.navigationController?.viewControllers.count
            self.navigationController?.viewControllers.removeAll()
            let options: UIView.AnimationOptions = .transitionCrossDissolve
             //The duration of the transition animation, measured in seconds.
            let duration: TimeInterval = 0.5
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
            { completed in
                // maybe do something on completion here
                let nav = UINavigationController(rootViewController: rootVC)
                window.rootViewController = nav
                window.makeKeyAndVisible()
            })
       }
    }
    func checkJwtIsExpired(from:String,onCompletion:@escaping(Bool)->())  {
   
        if let login = Defaults.shared.userLogin,let jwt = login.token,let currTime =  Date().convertToUtc(){
            // get the payload part of it
//            if let jwtt = try? decode(jwt: jwt){
//                print("IsJWTExpires=\(jwtt.expired)")
//               print("JWT Expires:-\(jwtt.expiresAt?.toString())")
//            }
            var payload64 = jwt.components(separatedBy: ".")[1]
            // need to pad the string with = to make it divisible by 4,
            // otherwise Data won't be able to decode it
            while payload64.count % 4 != 0 {
                payload64 += "="
            }
            
            print("base64 encoded payload: \(payload64)")
           if let payloadData = Data(base64Encoded: payload64,
                                   options:.ignoreUnknownCharacters),
            let payload = String(data: payloadData, encoding: .utf8){
            print(payload)
            if let json = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String:Any]{
            let exp = json["exp"] as! Int64
           // let expeDate = Date(timeIntervalSince1970: TimeInterval(exp))
            let expDate = NSDate(timeIntervalSince1970: TimeInterval(exp))
                var sec:Double = 0.0
                if from == "PreLogin"{
                    sec = 60.0*60.0
                }else{
                    sec = 30.0*60.0
                }
            let decDate = expDate.addingTimeInterval(TimeInterval(-sec))
            let isValid = decDate.compare(currTime) == .orderedDescending
            //expDate.addHour(hour: -2).compare(Date().toString().convertDateToUTCFormate()) == .orderedDescending
           // print("expe Time=\(expeDate)")
                
            print("exp Time=\(expDate)")
            print(" dec exp Time=\(decDate)")
            print("Curr Time=\(currTime)")
            print("valid=\(isValid)")
                
            onCompletion(isValid)
            }else{
                onCompletion(false)
            }
           }else{
               onCompletion(false)
           }
        }else{
            onCompletion(false)
        }
    }
    func removAllData(completion:(Bool)->()){
        Defaults.shared.userLogin = nil
        Defaults.shared.usrProfile = nil
        Defaults.shared.addedVehicle = AddedVehicle()
        //AddedVehicle(result: nil, message: "", success: nil)
        Defaults.shared.appConfig = nil
        Defaults.shared.token = ""
        //print(Defaults.shared.userLogin?.username)
       // Defaults.shared.userLogin?.username =
        Defaults.shared.userType = nil
        Defaults.shared.favoriteStation = []
        Defaults.shared.bookingType = .General
        
       // print("before", UserDefaults.standard.bool(forKey: UserDefaults.Keys.Login_Info.rawValue))
        // Reset User Defaults
        UserDefaults.standard.reset()
      //  print("after", UserDefaults.standard.bool(forKey: UserDefaults.Keys.Login_Info.rawValue))
        completion(true)
    }
    func displayAlert(alertMessage: String,_ controller:UIViewController = UIViewController()) {
        let alert:UIAlertController!
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
           // print("iPad style UI")
            alert = UIAlertController(title: Theme.appName, message:alertMessage , preferredStyle: .alert)
            alert.view.tintColor = Theme.menuHeaderColor
            alert.addAction(UIAlertAction(title: Theme.Message, style: .default, handler: nil))
            self.present(alert, animated: true)
        case .phone:
          //  print("iPhone and iPod touch style UI")
            alert = UIAlertController(title: Theme.appName, message:alertMessage , preferredStyle: .actionSheet)
            alert.view.tintColor = Theme.menuHeaderColor
           alert.addAction(UIAlertAction(title: Theme.Message, style: .default, handler: nil))
            self.present(alert, animated: true)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
    }
}
extension UIImageView{
    func setImage(url:String){
        //let url = dataSource.icon
        let url = URL(string:url)
        //"https://example.com/high_resolution_image.png")
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 8)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "LoginHeaderImage"),
            //?.tint(with: Theme.menuHeaderColor),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
extension UIImage {
  /**
   Creates a new image with the passed in color.
   - Parameter color: The UIColor to create the image from.
   - Returns: A UIImage that is the color passed in.
   */
  open func tint(with color: UIColor) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, Screen.scale)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    context.scaleBy(x: 1.0, y: -1.0)
    context.translateBy(x: 0.0, y: -size.height)
    
    context.setBlendMode(.multiply)
    
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    context.clip(to: rect, mask: cgImage!)
    color.setFill()
    context.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image?.withRenderingMode(.alwaysOriginal)
  }
}
extension UITableView {
    func registerNibs(nibNames nibs: [String]) {
        for nib in nibs {
            let cellNib = UINib(nibName: nib, bundle: nil)
            register(cellNib, forCellReuseIdentifier: nib)
        }
    }
    
}
extension UILabel{
    func labelDesign(){
        self.textColor = .white
        self.textAlignment = .center
        self.font = UIFont(name: "HelveticaNeue", size: 20.0)
    }
}
extension UIButton {
    func setButtonAttributes()  {
       // self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17.0)
    }
}
extension UIViewController {
    
    func showNewLoader(){
        DispatchQueue.main.async {
            let loader: NewLoader = NewLoader()
            loader.noInternetConnection = { [weak self ] valu in
                self?.displayAlert(alertMessage:"No internet connection is available.")
            }
            loader.providesPresentationContextTransitionStyle = true
            loader.definesPresentationContext = true
            loader.modalPresentationStyle = .overCurrentContext
            self.present(loader, animated: false, completion: {
                 loader.checkInternetConnectivity()
             })
        }
    }
    func showLoader(message: String = "Loading..."){
        DispatchQueue.main.async {
            let loader: DialogLoaderViewController = DialogLoaderViewController()
            loader.noInternetConnection = { [weak self ] valu in
                self?.displayAlert(alertMessage:"No internet connection is available.")
            }
            loader.providesPresentationContextTransitionStyle = true
            loader.definesPresentationContext = true
            loader.modalPresentationStyle = .overCurrentContext
            self.present(loader, animated: false, completion: {
               // loader.loderMessage.text = message
               // loader.checkInternetConnectivity()
            })
        }
    }
    
    func hideNewLoader(loader:NewLoader){
        DispatchQueue.main.async {
            loader.dimmiss()
           // loader.dismiss(animated: true, completion: nil)
        }
    }
    func hideLoader(){
        DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
        }
    }
//    @objc public func checkInternetConnectivity(){
//        let monitor = NWPathMonitor()
//        let queue = DispatchQueue.global(qos: .background)
//        monitor.start(queue: queue)
//        // let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
//       //  DispatchQueue.main.async {
//             monitor.pathUpdateHandler = { path in
//                 if path.status == .satisfied {
//                     print("satisfied")
//                 }else{
//                     DispatchQueue.main.async {
//                         monitor.cancel()
//                         self.dismiss(animated: true) {
//                             self.noInternetConnection(true)
//                         }
//                     }
//                 }
//             }
//        // }
//      }
    func showLoader(message: String = "Loading...", completion: @escaping (() -> ())){
        DispatchQueue.main.async {
            let loader: DialogLoaderViewController = DialogLoaderViewController()
            loader.providesPresentationContextTransitionStyle = true
            loader.modalPresentationStyle = .overCurrentContext
            self.present(loader, animated: true, completion: {
                completion()
            })
        }
    }
    func hideLoader(completion: @escaping (() -> ())){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                completion()
            })
        }
    }
}
extension Bool{
    func toString() -> String {
        if self {
            return Theme.UNAVAILABLE
        }else{
            return Theme.AVAILABLE
        }
    }
}
enum Password{
    case show
    case hide
}
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
extension Int64{
    func millisecondsToDate (hour:Int) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dtt = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        let dt = Calendar.current.date(byAdding: .hour, value: hour, to: dtt)!
        return dt
        }
}
extension Date{
    
    
    func toddMMMyyString()-> String{
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd MMM yy"
       return dateFormatter.string(from: self)
    }
    func to_dd_mm_yyyy_String()-> String{
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd-MM-yyyy"
       return dateFormatter.string(from: self)
    }
    func to_yyyy_mm_dd_String()-> String{
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       return dateFormatter.string(from: self)
    }
    func toString()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       return dateFormatter.string(from: self)
    }
    func toHHmmssSSSZ()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss.SSSZ"
       return dateFormatter.string(from: self)
    }
    func tohhmmString()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
       return dateFormatter.string(from: self)
    }
    func ampmString()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
       return dateFormatter.string(from: self)
    }
    
    func adding(minutes: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dt = Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
        return dateFormatter.string(from: dt)
    }
    func add_hh_mm_yyyy(day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dt = Calendar.current.date(byAdding: .day, value: day, to: self)!
        return dateFormatter.string(from: dt)
    }
    func adding(Day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dt = Calendar.current.date(byAdding: .day, value: Day, to: self)!
        return dateFormatter.string(from: dt)
    }
    func add(Day: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dt = Calendar.current.date(byAdding: .day, value: Day, to: self)!
        return dt
    }
    func convertToUtcDate() -> Date? {
        let currentDate = self
         
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
         
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = currentDate.timeIntervalSince1970
         
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
         
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        
        return timeZoneOffsetDate
    }
    func convertToUtc() -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//       // dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600*5+1800)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.timeZone = .current
//        var dt = Calendar.current.date(byAdding: .hour, value: 5, to: self)!
//         dt = Calendar.current.date(byAdding: .minute, value: 30, to: dt)!
//        return dt
        
       /*
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .medium
        utcDateFormatter.timeStyle = .medium

        // The default timeZone on DateFormatter is the device’s
        // local time zone. Set timeZone to UTC to get UTC time.
        utcDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        utcDateFormatter.timeZone = TimeZone(secondsFromGMT: 19800)
        //TimeZone(abbreviation: "UTC")

        // Printing a Date
        let date = Date()
       let cuurtDt =  utcDateFormatter.string(from: date)

        // Parsing a string representing a date
        let dateString = cuurtDt
        let utcDate = utcDateFormatter.date(from: dateString)
        
        return utcDate*/
        let currentDate = Date()
         
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
         
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = currentDate.timeIntervalSince1970
         
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
         
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        
        return timeZoneOffsetDate
    }
   
    func addHour(hour: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dt = Calendar.current.date(byAdding: .hour, value: hour, to: self)!
        return dt
    }
    func addMinuits(min: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dt = Calendar.current.date(byAdding: .minute, value: min, to: self)!
        return dt
    }
    func addInHHMM(Day: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dt = Calendar.current.date(byAdding: .day, value: Day, to: self)!
        return dt
    }
    func addinghhmm(Day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dt = Calendar.current.date(byAdding: .day, value: Day, to: self)!
        return dateFormatter.string(from: dt)
    }
}
extension String {
    func converthhmmStringToDate()-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func converthhmmamStringToDate()-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func convertStringToDate()-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func converthhmmpmStringToDate()-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func toHHmmssSSSZTime()-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func toNewDate()-> Date{
        let dateFormatter = DateFormatter()
       // "dd-MM-yyyy'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func toDate()-> Date{
        let dateFormatter = DateFormatter()
       // "dd-MM-yyyy'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func converthhmmampmStringToDate()-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        guard let date = dateFormatter.date(from: self) else {return Date()}
        return date
    }
    func convertDateToUTCFormate() -> Date {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

         let oldDate = olDateFormatter.date(from: self)
       
         let convertDateFormatter = DateFormatter()
          convertDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
         convertDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        convertDateFormatter.string(from: oldDate!)
        guard let date = convertDateFormatter.date(from: self) else {return Date()}
        return date
        // return
    }
    func convertDateToUTCTimeFormate() -> Date {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"

         let oldDate = olDateFormatter.date(from: self)
       
         let convertDateFormatter = DateFormatter()
        //convertDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
         convertDateFormatter.dateFormat = "HH:mm a"
        convertDateFormatter.string(from: oldDate!)
        guard let date = convertDateFormatter.date(from: self) else {return Date()}
        return date
        // return
    }
    func convertDateFormat() -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

         let oldDate = olDateFormatter.date(from: self)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "hh:mm"

         return convertDateFormatter.string(from: oldDate!)
    }
    func convertDateForma() -> String {
       
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "h:mm a"

         let oldDate = olDateFormatter.date(from: self)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "HH:mm:ss.SSSZ"

         return convertDateFormatter.string(from: oldDate!)
    }
    
    func convertDateFormater() -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: self)
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return  dateFormatter.string(from: date!)

        }
    func dateFormateForTransaction() -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: self)
            dateFormatter.dateFormat = "dd MMM yy"
            return  dateFormatter.string(from: date!)
        }
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      //  dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //TimeZone(name: "UTC")
      // TimeZone(abbreviation: "UTC")
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return ""
        }

       // dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
        dateFormatter.dateFormat = "dd MMM yy - hh:mm a"
        
       // dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
    func getTimeFromDate() -> String{
    //(String,String,String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //TimeZone(name: "UTC")
      // TimeZone(abbreviation: "UTC")
        guard let date = dateFormatter.date(from: self) else {
            assert(false, "no date from string")
            return ("")
        }

        dateFormatter.dateFormat = "dd MMM yy - hh:mm a"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
        //dateFormatter.dateFormat = "HH:mm:ss"
       // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
       // let timeStamp = dateFormatter.string(from: date).components(separatedBy: ":")
       // return (timeStamp[0]+"h",timeStamp[1]+"m",timeStamp[2]+"s")
    }
    func dateWithOnlyTime() -> (String,String,String){
    let df : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
        if let  sTime = df.date(from: self){
        let calendar = Calendar.current
        let hh = calendar.component(.hour, from: sTime)
        let mm = calendar.component(.minute, from: sTime)
        let ss = calendar.component(.second, from: sTime)
            
        let hours = String(format: "%02ld",hh)
        let minuits = String(format: "%02ld",mm)
        let seconds = String(format: "%02ld",ss)
            
        return (hours,minuits,seconds)
        }
        return ("","","")
}
    func dateWithTime(stop:String) -> (String,String,String) {
    let df : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
      let sTime = df.date(from: self)
        let eTime = df.date(from: stop)
        let difference = Calendar.current.dateComponents([.hour, .minute,.second], from: sTime!, to: eTime!)
        if let hh = difference.hour,let mm = difference.minute, let ss = difference.second {
            let hours = String(format: "%02ld",hh)
            let minuits = String(format: "%02ld",mm)
            let seconds = String(format: "%02ld",ss)
            return (hours+"h",minuits+"m",seconds+"s")
        }
        return ("","","")
    //return df.date(from: self) ?? Date()

}
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var currencified: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let priceAsNumber = NSNumber(value: self.intified())
        let formattedPrice = formatter.string(from: priceAsNumber) ?? self
        return "₹ " + formattedPrice
    }
    var currencifiedDouble: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        let priceAsNumber = NSNumber(value: self.intified())
        let formattedPrice = formatter.string(from: priceAsNumber) ?? self
        return formattedPrice
    }
    func intified() -> Int {
     guard let num =  Int.init(self.replacingOccurrences(of: ",", with: ""))
        else {
            return 0
        }
        return num
    }
    
    func description()->String{
        switch self {
        case "S":
            return "StartTransaction"
        case "R":
            return "RunningTransaction"
        case "C":
            return "CompleteTransaction"
        case "P":
            return "PaidTransaction"
        default:
            return ""
        }
    }
}
struct Formatter {
    static let instance = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
}
extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
extension UserDefaults {
    enum Keys: String, CaseIterable {
        case Login_Info
        case Profile_Info
        case Vehicle_Info
        case App_Info
    }
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
