//
//  TabController.swift
//  ChargePark
//
//  Created by apple on 30/12/21.
//

import UIKit

class TabController: UITabBarController {
    var vc1:TimeSlotVC!
    var vc2:NextDayTimeVC!
    var vc3:DayAfterTorowTimeVC!
    var stationDetail:ResultStation?
   // let tab = TabController()
    var dataSource:[(String,Bool,Bool,Int)] = []
    var dataSource1:[(String,Bool,Bool,Int)] = []
    var dataSource2:[(String,Bool,Bool,Int)] = []
    var noSelection:(UIViewController)->() = { _ in}
   // var swipeGestureRecognizerDown: UISwipeGestureRecognizer!
    var selectionComplete:(([Int]?,String?,String?,UIViewController)->()) = {_,_,_,_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.isModalInPresentation = true
     //   swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
            // Configure Swipe Gesture Recognizer
        //swipeGestureRecognizerDown.direction = .down
            // Add Swipe Gesture Recognizer
       
        let st = UIStoryboard.init(name: "TimeSlot", bundle: nil)
        vc1 = st.instantiateViewController(withIdentifier: "TimeSlotVC") as? TimeSlotVC
        vc2 = st.instantiateViewController(withIdentifier: "NextDayTimeVC") as? NextDayTimeVC
        vc3 = st.instantiateViewController(withIdentifier: "DayAfterTorowTimeVC") as? DayAfterTorowTimeVC
        vc1.stationDetail = self.stationDetail
        vc1.dataSource = self.dataSource
        
        vc2.stationDetail = self.stationDetail
        vc2.dataSource = self.dataSource1
        
        vc3.stationDetail = self.stationDetail
        vc3.dataSource = self.dataSource2
        
        self.viewControllers = [vc1,vc2]
       // self.viewControllers = [vc1,vc2,vc3]
        self.selectedIndex = 0
       // self.vc1.viewUp.addGestureRecognizer(swipeGestureRecognizerDown)
       // self.vc2.view.addGestureRecognizer(swipeGestureRecognizerDown)
       // self.vc3.view.addGestureRecognizer(swipeGestureRecognizerDown)
        self.tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = Theme.menuHeaderColor
        // Do any additional setup after loading the view.
    }
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch tabBar.selectedItem?.title {
//
//
//        case .none:
//            <#code#>
//        case .some(_):
//            <#code#>
//        }
//    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // if we didn't change tabs, don't do anything
        if tabBarController.selectedViewController?.tabBarItem.tag ==  viewController.tabBarItem.tag {
            return false
        }
        
        if viewController.tabBarItem.tag == 1 { // some particular tab
            // do stuff appropriate for a transition to this particular tab
           
        }
        else if viewController.tabBarItem.tag == 2 { // some other tab
            // do stuff appropriate for a transition to this other tab
        }else if viewController.tabBarItem.tag == 3 { // some other tab
            // do stuff appropriate for a transition to this other tab
        }
        return true
    }
//    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
//        self.noSelection(self)
//    }
    deinit{
       print("\(self) is deinitilized")
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

