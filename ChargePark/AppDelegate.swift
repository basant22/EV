//
//  AppDelegate.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Siren
//import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
       //GMSServices.provideAPIKey("AIzaSyBUMWNyRP8CUynd7K_r9vPkGfaXr-ei-PE")
        //vpower api key
       // GMSPlacesClient.provideAPIKey("AIzaSyDfW37B0fN3ckP8WCAIqe1hEL7vyFQorHU")
       // GMSServices.provideAPIKey(Theme.GoogleApiKey)
       // GMSServices.provideAPIKey("AIzaSyDfW37B0fN3ckP8WCAIqe1hEL7vyFQorHU")
       // "AIzaSyBmHwJ-X3JhvAjMaJOtpkw1NuGQo90RbSA"
       // GMSPlacesClient.provideAPIKey(Theme.GoogleApiKey)
        GMSServices.provideAPIKey(Theme.GoogleApiKey)
        let GMSPlacesKeyValid =
        GMSPlacesClient.provideAPIKey(
            "AIzaSyD4Ia4HVQXzecT-_6HGvxINadzsqCwJs7w")
                // JpDimoi "kiquoa-ios" key...

                let GMSPlacesSDKVer = GMSPlacesClient.sdkVersion()
                print("GMS Places Key Valid: ", GMSPlacesKeyValid)
                print("GMS Places SDK version: ", GMSPlacesSDKVer)

                print("Leaving AppDelegate.s`enter code here`wift now...")
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
           // window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
            //UIWindow.appearance().overrideUserInterfaceStyle = .light
        }
//        UIApplication.shared.windows.forEach { window in
//            if #available(iOS 13.0, *) {
//                window.overrideUserInterfaceStyle = .dark
//            } else {
//                // Fallback on earlier versions
//            }
//        }
        
//        let center = UNUserNotificationCenter.current()
//            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
//                // Enable or disable features based on authorization.
//            }
//            application.registerForRemoteNotifications()
        setupSiren()
        return true
    }
//    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        //send this device token to server
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//                let token = tokenParts.joined()
//                print("Device Token: \(token)")
//
//                // send token to backend here
////                let deviceService = DeviceService()
////                deviceService.add(accessToken: ApiTokenSingleton.shared.getToken(), deviceToken: token) { createDeviceResponse in
////                    print(createDeviceResponse)
////                }
//    }

    //Called if unable to register for APNS.
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print(error)
//    }
//    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//
//        print("Recived: \(userInfo)")
//        //Parsing userinfo:
//    }
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
      
        print("applicationWillEnterForeground")
    }
    func applicationDidBecomeActive(_ application: UIApplication){
        print("applicationDidBecomeActive")
    }
    fileprivate func setupSiren() {
        /* Siren code should go below window?.makeKeyAndVisible() */
        
        // Siren is a singleton
        let siren = Siren.shared
        siren.apiManager = APIManager(countryCode : "IN")
        let rules = Rules(promptFrequency: .immediately, forAlertType: .option)
        siren.rulesManager = RulesManager(globalRules: rules)
        
        siren.presentationManager = PresentationManager(appName: "\(Theme.appName)", alertTitle: "", alertMessage: "New Update is available!", updateButtonTitle:  "Update", nextTimeButtonTitle: "Later", skipButtonTitle: "Please don't push skip, please don't!")
        
        // Optional: Defaults to .option
        
        //siren.alertType = .option
        
        // Optional: Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
        
        //        siren.alertMessaging = SirenAlertMessaging(updateTitle: NSAttributedString(string: Theme.appName), updateMessage: NSAttributedString(string: "New Update is available!"), updateButtonMessage: NSAttributedString(string: "Update"), nextTimeButtonMessage: NSAttributedString(string: "Later"), skipVersionButtonMessage: NSAttributedString(string: "Please don't push skip, please don't!"))
        siren.wail { results in
            switch results {
            case .success(let updateResults):
                print("AlertAction ", updateResults.alertAction)
                print("Localization ", updateResults.localization)
                print("Model ", updateResults.model)
                print("UpdateType ", updateResults.updateType)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 1
        
        
        // siren.checkVersion(checkType: .immediately)
        // Replace .immediately with .daily or .weekly to specify a maximum daily or weekly frequency for version checks.
        // DO NOT CALL THIS METHOD IN didFinishLaunchingWithOptions IF YOU ALSO PLAN TO CALL IT IN applicationDidBecomeActive.
        //siren.checkVersion(checkType: .daily)
    }
    
}

