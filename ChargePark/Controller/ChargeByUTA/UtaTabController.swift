//
//  UtaTabController.swift
//  ChargePark
//
//  Created by Admin on 22/03/22.
//

import UIKit

class UtaTabController: UITabBarController {
    var vc1:UnitVC!
    var vc2:TimeVC!
    var vc3:AmountVC!
    var vc4:SocVC!
    var chargerDetail:ResultCharger?
    var doneSelection:((String,Int?,Double?,UIViewController)->()) = {_,_,_,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let st = UIStoryboard.init(name: "ChargeByUTA", bundle: nil)
        vc1 = st.instantiateViewController(withIdentifier: "UnitVC") as? UnitVC
        vc1.chargerDetail = chargerDetail
        vc2 = st.instantiateViewController(withIdentifier: "TimeVC") as? TimeVC
        vc2.chargerDetail = chargerDetail
        vc3 = st.instantiateViewController(withIdentifier: "AmountVC") as? AmountVC
        vc3.chargerDetail = chargerDetail
        vc4 = st.instantiateViewController(withIdentifier: "SocVC") as? SocVC
        vc4.chargerDetail = chargerDetail
        self.selectedIndex = 0
        if let pricePerMinute =  chargerDetail?.pricePerMinute,let type = chargerDetail?.outputType, pricePerMinute > 0 {
            if type == "DC" {
                self.viewControllers = [vc1,vc2,vc3,vc4]
            }else{
            self.viewControllers = [vc1,vc2,vc3]
            }
        }else{
            if let type = chargerDetail?.outputType, type == "DC"{
                self.viewControllers = [vc1,vc3,vc4]
            }else{
                self.viewControllers = [vc1,vc3]
            }
           
        }
       
       
       
        self.tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = Theme.menuHeaderColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
