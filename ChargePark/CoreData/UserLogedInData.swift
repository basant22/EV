//
//  UserLogedInData.swift
//  ChargePark
//
//  Created by apple on 05/11/21.
//

import Foundation
import CoreData
protocol LogedInRepository{
    func create()
    func isUserLogedIn()->Bool
    func update(value:Bool)->Bool
    func delete()->Bool
}
struct LogedInDataRepository:LogedInRepository{
    
    func create() {
      let remUser = RememberUser(context: Prersistance.shared.context)
        print("LogedIn created")
        remUser.logedIn = true
        Prersistance.shared.saveContext()
    }
    
    func isUserLogedIn()->Bool {
        let remUser =  getLogedInUser()
        print("LogedIn \(String(describing: remUser?.logedIn))")
        return remUser?.logedIn ?? false
    }
    
    func update(value:Bool)->Bool {
        if let remUser =  getLogedInUser(){
            remUser.logedIn = value
            do{
                print("LogedIn Updated")
                try Prersistance.shared.context.save()
            } catch let error{
                debugPrint(error)
            }
            return true
        }
        return false
    }
    
    func delete()->Bool {
        let remUser =  getLogedInUser()
        guard remUser != nil else {return false}
        Prersistance.shared.context.delete(remUser!)
        print("LogedIn Deleted")
        return true
    }
    private func getLogedInUser()->RememberUser?{
       // let fetchRequest = NSFetchRequest<RememberUser>(entityName: "RememberUser")
        // let predica = NSPredicate(format: "logedIn == %@",byValue)
        //  fetchRequest.predicate = predica
            
        do {
            guard let res = try Prersistance.shared.context.fetch(RememberUser.fetchRequest()).first else {return nil}
            return res
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}

protocol saveRequiredInfos{
    func saveLoginInfo(data:ResultLogin)
    func saveProfileInfo()
    func saveUserEvsInfo()
    func saveAppConfigInfo()
    func getLoginInfo()
    func getProfileInfo()
    func getUserEvsInfo()
    func getAppConfigInfo()
}
/*
struct UserRequiredInfos:saveRequiredInfos{
    func saveLoginInfo(data:ResultLogin) {
        let loginInfo = LoginInfo(context: Prersistance.shared.context)
        loginInfo.setValue(data as? NSObject, forKey: "LoginInfo")
    }
    
    func saveProfileInfo() {
        <#code#>
    }
    
    func saveUserEvsInfo() {
        <#code#>
    }
    
    func saveAppConfigInfo() {
        <#code#>
    }
    
    func getLoginInfo() {
        <#code#>
    }
    
    func getProfileInfo() {
        <#code#>
    }
    
    func getUserEvsInfo() {
        <#code#>
    }
    
    func getAppConfigInfo() {
        <#code#>
    }
    
    
}*/
