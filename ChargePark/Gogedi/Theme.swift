//
//  Theme.swift
//  GoGedi
//
//  Created by apple on 29/11/21.
//

import Foundation

struct Theme {
    static let baseUrl:String  = "https://app.sensorsatwork.com/SAW/api/app/"
    static let appName = "GoGedi"
    static let AVAILABLE = "Available"
    static let UNAVAILABLE = "UnAvailable"
    static let RazorPayKey = "rzp_test_qDJ3qeqlxgOl1j"
    static let GoogleApiKey = "AIzaSyCiSi9fTNUldE_EUq3tVu7gshk1cv2O1DQ"
    static let MAX_TEXT_LENGTH = 10
    static let Message = "Ok"
    //Api Connectors
    static let PunchLine =  "Make EV charging quick and easy."
    static let LoginConnector = "appuserauth"
    static let RegistrationConnector = "appuser"
    static let OTPConnector = "getpasswordlink"
    static let ForgetPConnector = "resetappuserforgotpwd"
    static let NearByStation = "stationsnearlocation"
    static let ChargerAtStation = "chargersbystation"
    static let AddVehicle = "addupdateev"
    static let VehicleList = "userevs"
    static let BookCharger = "changestatus"
    static let Chargerportbystation = "chargerportbystation"
    static let ChangeBookingStatus = "changebookingstatus"
    static let ChargerStatus = "bookingstatus"
    static let ChargerBooking = "booking"
    static let ChargerBookingDetail = "getbooking"
    static let BookingList = "bookinglist"
    static let ShowProfile = "userprofile"
    static let AppConfig = "getCompanyConfig"
    static let AddFund = "payment/getorder"
    static let AddFundPaytm = "payment/token"
    static let Transaction = "paymentDetails"
    static let SavePayments = "payment/savePayment"
    static let ActiveBooking = "activebooking"
    static let MakeBookingPayment = "payment"
    static let Rfid = "rfid"
    static let Rfidby_username = "rfidbyusername"
    static let Remove_rfid = "removerfid"
    static let Request_rfid = "requestrfid"
    static let Station_Favorites = "stationfavorites"
    static let Getbookedschedulebydate = "getbookedschedulebydate"
    static let Initialising = " Initialising"
    static let Error_in_charging = " Error in charging"
    static let Start_Time = " Start Time: "
    static let Units_Consumed = " Units Consumed: "
    static let Charging_Duration = "Charging Duration: "
    static let Rate_Of_Charging = " Rate Of Charging: "
    static let INRSign = "\u{20B9}"
    static let RazorImage = "https://gogedi.com/wp-content/themes/electric/assets/images/logo-final.png"
    //Payment vc Titles
    static let Name_Title = " Name: "
    static let Invoice_Id = " Invoice Id: "
    static let Rate_Title = " Rate Title: "
    static let Sub_Total = " Sub Total: "
    static let Other_Charges = " Other Charges: "
    static let Discount = " Discount: "
    static let Total_Payable = " Total Payable: "
    
    static let Charging_Status = " Charging Status:"
    static let Load = " Load: "
    static let Charging =  " Charging"
    static let LoginInfo = "Login_Info"
    static let ProfileInfo = "Profile_Info"
    static let VehicleInfo = "Vehicle_Info"
    static let AppInfo = "App_Info"
    static let Booking_Id = " Booking Id: "
    static let Duration = " Duration: "
    static let Amount = " Amount: "
    static let Stop_Charging = "Stop Charging"
    static let Start_Charging = "Start Charging"
    static let Start_Transaction = "StartTransaction"
    static let Stop_Transaction = "StopTransaction"
    static let Charger_Not_Started = "Charger coudn't be started"
    static let Done_Payment = "You have done payment successfully!"
    static let Payment_Not_Done = "This booking is not completed"
    static let msgBooking = "This charger is not available for booking now"
    static let Booking_Already_Exist = "Booking Already Exist"
    static let Booking_Already_Exist_Msg = "This charger port is already occupied"
    static let AlreadyExists = "AlreadyExists"
    static let Something_went_wrong = "Something went wrong"
    static let HelpWebsite = "https://www.gogedi.com/home/"
    static let HelpMobileNumber = "+919310999140"
    static let HelpMobileNumberNew = ""
    static let HelpEmail = "info@gogedi.com"
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    //2wE74eo8Z6TpWjnnw3ryc0so
   // rgb(204,236,218)
    static let BookStatusColor:UIColor = UIColor(red:204/255, green:236/255, blue:218/255, alpha:1.0)
    static let CancellableStatusColor:UIColor = UIColor(red:238/255, green:168/255, blue:165/255, alpha:1.0)
 
    //static let gradientGreen:UIColor = UIColor(red:87/255, green:200/255, blue:77/255, alpha:1.0)
    //static let gradientGreen:UIColor = UIColor(red:46/255, green:182/255, blue:44/255, alpha:1.0)
    static let RazorPayColor = "#79DC47"
    static let gradientGreen:UIColor = UIColor(red:119/255, green:185/255, blue:91/255, alpha:1.0)
    static let newGreen:UIColor = UIColor(red:119/255, green:185/255, blue:91/255, alpha:1.0)
    static let emptyColor:UIColor = UIColor(red:213/255, green:245/255, blue:227/255, alpha:1.0)
    static let menuHeaderColor:UIColor = UIColor(red:87/255, green:148/255, blue:61/255, alpha:1.0)
    static let navigationBgc:UIColor = UIColor(red:37/255, green:56/255, blue:60/255, alpha:1.0)
    static let deepGreen:UIColor = UIColor(red:20/255, green:90/255, blue:50/255, alpha:1.0)
    static let lightGreen:UIColor = UIColor(red:209/255, green:242/255, blue:235/255, alpha:1.0)

}
