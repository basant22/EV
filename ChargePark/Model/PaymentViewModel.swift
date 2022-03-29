//
//  PaymentViewModel.swift
//  ChargePark
//
//  Created by apple on 23/11/21.
//

import Foundation
struct PaymentViewModel {
    var paymentData:[PaymentData] = []
    var payment = PaymentData(title:"")
    var subTotal = 0.0
   // var unitConsumed = 0.0
   // var price = 0.0
    
    init(data:ResultBookingStatus) {
        
        if let name = Defaults.shared.userLogin?.name{
            payment.title = Theme.Name_Title +  name.capitalized
        paymentData.append(payment)
        }
        if let value = data.invoiceId {
            payment.title = Theme.Invoice_Id +  String(value)
           paymentData.append(payment)
        }
        if let value = data.billingType,let title = BillingType(rawValue:value),let valueT = data.unit{
           // unitConsumed = valueT
            payment.title = title.description + String(format:"%.02f",valueT )
            paymentData.append(payment)
        }
        if let value = data.price{
            payment.title = Theme.Rate_Title + Theme.INRSign + String(format:"%.02f",value )
          //  subTotal = unitConsumed*value
            paymentData.append(payment)
        }
        if let value = data.amount{
            payment.title = Theme.Sub_Total + Theme.INRSign  + String(format:"%.02f",value )
            subTotal += value
            paymentData.append(payment)
        }
        if let value = data.otherCharges{
            payment.title = Theme.Other_Charges + Theme.INRSign +  String(value)
            subTotal += value
            paymentData.append(payment)
        }
        if let value = data.taxRate,let amount = data.amount{
            let calGst = calculateGST(gst: value, amount: amount)
            payment.title = " GST:(\(value)%)" + "    " + Theme.Amount + Theme.INRSign + String(format:"%.02f",calGst )
           // subTotal += amount
            paymentData.append(payment)
        }
        if let value = data.discountamount {
            payment.title = Theme.Discount +  Theme.INRSign +  String(format:"%.02f",value )
            subTotal -= value
            paymentData.append(payment)
        }
        if let value = data.taxRate{
            let total = calculateAmountWithGST(gst: value, amount: subTotal)
        payment.title = Theme.Total_Payable + Theme.INRSign + String(format:"%.02f",total )
        }
            paymentData.append(payment)
    }
    func calculateGST(gst:Double,amount:Double)->Double{
        var amt = Double(gst)*amount
        amt = amt/100
        return amt
    }
    func calculateAmountWithGST(gst:Double,amount:Double)->Double{
        var amt = Double(gst)*amount
        amt = amt/100
        amt = amt + amount
        return amt
    }
}
struct PaymentData {
    var title:String!
}

enum BillingType:String{
    case U = "U"
    case D = "D"
    
    var description:String{
        switch self {
        case .U:
            return Theme.Units_Consumed
        case .D:
            return Theme.Charging_Duration
        }
    }
}
