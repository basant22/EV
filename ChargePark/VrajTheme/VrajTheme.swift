//
//  VrajTheme.swift
//  VRAJEV Charge
//
//  Created by apple on 22/11/21.
//

import Foundation

struct Theme {
    static let baseUrl:String  = "https://app.vrajevcharge.com/VRAJ/api/app/"
    static let appName = "VRAJEV Charge"
    static let AVAILABLE = "Available"
    static let UNAVAILABLE = "UnAvailable"
    static let RazorPayKey = "rzp_test_qDJ3qeqlxgOl1j"
    static let GoogleApiKey = "AIzaSyDok4xfxMfLVZXvTZAvWDnPqE79jWvvSAU"
    static let MAX_TEXT_LENGTH = 10
    static let Message = "Ok"
    //Api Connectors
    static let PunchLine =  "Destination for Electric Vehicle Charging."
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
    static let Initialising = " Initialising"
    static let Error_in_charging = " Error in charging"
    static let Charging =  " Charging"
    static let Start_Time = " Start Time: "
    static let Units_Consumed = " Units Consumed: "
    static let Amount_Title = " Amount:"
    static let Rfid = "rfid"
    static let Rfidby_username = "rfidbyusername"
    static let Remove_rfid = "removerfid"
    static let Request_rfid = "requestrfid"
    static let Station_Favorites = "stationfavorites"
    static let Rate_Of_Charging = " Rate Of Charging:"
    static let Booking_Id = " Booking Id: "
    static let Duration = " Duration: "
    static let Amount = " Amount: "
    static let Charging_Status = " Charging Status:"
    static let Charging_Duration = "Charging Duration: "
    static let INRSign = "\u{20B9}"
    static let Load = " Load:"
    static let RazorImage = "http://www.vrajevcharge.com/wp-content/themes/ev-charger/assets/img/black-logo.png"
    //Payment vc Titles
    static let Name_Title = " Name: "
    static let Invoice_Id = " Invoice Id:"
    static let Rate_Title = " Rate Title: "
    static let Sub_Total = " Sub Total:"
    static let Other_Charges = " Other Charges: "
    static let Discount = " Discount: "
    static let Total_Payable = " Total Payable: "
    
    
    static let LoginInfo = "Login_Info"
    static let ProfileInfo = "Profile_Info"
    static let VehicleInfo = "Vehicle_Info"
    static let AppInfo = "App_Info"
    static let Stop_Charging = "Stop Charging"
    static let Start_Charging = "Start Charging"
    static let Start_Transaction = "StartTransaction"
    static let Stop_Transaction = "StopTransaction"
    static let Getbookedschedulebydate = "getbookedschedulebydate"
    static let Done_Payment = "You have done payment successfully!"
    static let Payment_Not_Done = "This booking is not completed"
    static let msgBooking = "This charger is not available for booking now"
    static let Charger_Not_Started = "Charger coudn't be started"
    static let Booking_Already_Exist = "Booking Already Exist"
    static let Booking_Already_Exist_Msg = "This charger port is already occupied"
    static let AlreadyExists = "AlreadyExists"
  
    static let Something_went_wrong = "Something went wrong"
    static let HelpWebsite = "http://www.vrajevcharge.com"
    static let HelpMobileNumber = "+919825065304"
    static let HelpMobileNumberNew = ""
    static let HelpEmail = "support@vrajevcharge.com"
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    //2wE74eo8Z6TpWjnnw3ryc0so
   // rgb(204,236,218)
    static let BookStatusColor:UIColor = UIColor(red:204/255, green:236/255, blue:218/255, alpha:1.0)
    static let CancellableStatusColor:UIColor = UIColor(red:238/255, green:168/255, blue:165/255, alpha:1.0)
 
    //static let gradientGreen:UIColor = UIColor(red:87/255, green:200/255, blue:77/255, alpha:1.0)
    //static let gradientGreen:UIColor = UIColor(red:46/255, green:182/255, blue:44/255, alpha:1.0)
    static let RazorPayColor = "#3498DB"
    static let gradientGreen:UIColor = UIColor(red:41/255, green:143/255, blue:120/255, alpha:1.0)
    //UIColor(red:88/255, green:214/255, blue:141/255, alpha:1.0)
   // static let gradientGreen:UIColor = UIColor(red:245/255, green:176/255, blue:65/255, alpha:1.0)
//    static let newGreen:UIColor = UIColor(red:245/255, green:176/255, blue:65/255, alpha:1.0)
   // static let gradientGreen:UIColor = UIColor(red:93/255, green:172/255, blue:226/255, alpha:1.0)
    static let newGreen:UIColor = UIColor(red:41/255, green:143/255, blue:120/255, alpha:1.0)
    //UIColor(red:88/255, green:214/255, blue:141/255, alpha:1.0)
    //UIColor(red:93/255, green:172/255, blue:226/255, alpha:1.0)
    static let emptyColor:UIColor = UIColor(red:20/255, green:90/255, blue:50/255, alpha:1.0)
    //UIColor(red:213/255, green:245/255, blue:227/255, alpha:1.0)
    
    static let menuHeaderColor:UIColor = UIColor(red:7/255, green:78/255, blue:62/255, alpha:1.0)
   // static let menuHeaderColor:UIColor = UIColor(red:46/255, green:134/255, blue:193/255, alpha:1.0)
    //static let menuHeaderColor:UIColor = UIColor(red:52/255, green:152/255, blue:219/255, alpha:1.0)
    static let navigationBgc:UIColor = UIColor(red:37/255, green:56/255, blue:60/255, alpha:1.0)
    static let deepGreen:UIColor = UIColor(red:7/255, green:78/255, blue:62/255, alpha:1.0)
    static let lightGreen:UIColor = UIColor(red:209/255, green:242/255, blue:235/255, alpha:1.0)

}
