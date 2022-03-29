//
//  LogedInManager.swift
//  ChargePark
//
//  Created by apple on 05/11/21.
//

import Foundation

struct LogedInManager{
    
    private let logedIn = LogedInDataRepository()
    func createLogedInUser(){
        logedIn.create()
    }
    func isUserLogedIn()->Bool{
       return  logedIn.isUserLogedIn()
    }
    func updateLogedInUser(value:Bool)->Bool{
       return logedIn.update(value: value)
    }
    func deleteLogedIn()->Bool{
       return logedIn.delete()
    }
}
/*
struct UserInfoManager {
    private let userReqInfos = UserRequiredInfos()
    func saveLoginInfo(data:ResultLogin)  {
        userReqInfos.saveLoginInfo()
    }
    func getLoginInfo()  {
        userReqInfos.getLoginInfo()
    }
}
*/
