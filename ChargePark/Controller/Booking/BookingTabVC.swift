//
//  BookingTabVC.swift
//  ChargePark
//
//  Created by apple on 09/01/22.
//

import UIKit

class BookingTabVC: UITabBarController {

    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    var vc1 :MyBookingVC!
    var vc2 :CompletedBookingVC!
    var vc3 :CancelledBookingVC!
   
    override func viewDidLoad() {
        super.viewDidLoad()
let story = UIStoryboard(name: "MyBooking", bundle: nil)
        if let vc1 = story.instantiateViewController(withIdentifier: "MyBookingVC") as? MyBookingVC,let vc2 = story.instantiateViewController(withIdentifier: "CompletedBookingVC") as? CompletedBookingVC,let vc3 = story.instantiateViewController(withIdentifier: "CancelledBookingVC") as? CancelledBookingVC{
            self.vc1 = vc1
            self.vc2 = vc2
            self.vc3 = vc3
        }
//        if  self.revealViewController() != nil{
//                  menuButton.target = self.revealViewController()
//                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
//      //  self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//              }
        self.navigationController?.isNavigationBarHidden = true
      //  self.navigationController?.navigationBar.backgroundColor = Theme.menuHeaderColor
      //  self.navigationController?.navigationBar.tintColor = .white
        self.delegate = self
        // Do any additional setup after loading the view.
       // self.sendRequestForMyBookingList()
        
       
       // self.titleBar.title = "New Boookings"
        self.tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = Theme.menuHeaderColor
        
       /* let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)*/
    }
    override func viewWillAppear(_ animated: Bool) {
       // if Defaults.shared.isBookingCancell == true {
           // Defaults.shared.isBookingCancell = false
        self.sendRequestForMyBookingList {
            DispatchQueue.main.async {
                self.viewControllers = [self.vc1,self.vc2,self.vc3]
                self.selectedIndex = 0
                if Defaults.shared.isBookingCancell == true {
                    Defaults.shared.isBookingCancell = false
                    self.vc1.tableView.reloadData()
                   // self.vc3.tableView.reloadData()
                }
            }
        }
    }
   @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if self.selectedIndex < 2 { // set your total tabs here
                self.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if self.selectedIndex > 0 {
                self.selectedIndex -= 1
            }
        }
    }
    @objc func goToPreviousTab(gesture: UIGestureRecognizer){
        if let tabBarControllerr = self.tabBarController,
           let viewControllers = tabBarControllerr.viewControllers,let selectecd = tabBarControllerr.selectedViewController{
            let nextIndex = tabBarControllerr.selectedIndex - 1
            let fromView = selectecd.view
            let toView = viewControllers[nextIndex].view
            UIView.transition(  from: fromView!,
                                to: toView!,
                                duration: 0.5,
                                options: .transitionCrossDissolve,
                             completion: {(finished : Bool) -> () in
                if (finished)
                {
                    tabBarControllerr.selectedIndex = nextIndex
                }
            })
        }
    }
    func sendRequestForMyBookingList(onCompletion:@escaping()->()) {
        if let userName = Defaults.shared.userLogin?.username{
            let req = ApiGetRequest()
                self.showLoader()
            req.kindOf(Theme.BookingList, requestFor: .MY_BOOKINGS, queryString: [userName], response: MyBookings.self) { [weak self] respons in
                self?.hideLoader()
                if let res = respons{
                    if let msg = res.message,let success = res.success, success == true && msg == "Ok"{
                        if let bookings = res.result{
                           self?.vc1.bookings = bookings.filter({$0.status == "S"||$0.status == "B"||$0.status == "R"})
                            self?.vc2.bookings = bookings.filter({$0.status == "C"})
                            self?.vc3.bookings = bookings.filter({$0.status == "D" || $0.status == "F"})
                            onCompletion()
                        }else{
                            self?.vc1.bookings = []
                            self?.vc2.bookings = []
                            self?.vc3.bookings = []
                            onCompletion()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self?.displayAlert(alertMessage: res.message!)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "Something went wrong!")
                    }
                }
            }
        }
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
extension BookingTabVC: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCrossDissolve], completion: nil)
           
        }
        if tabBarController.selectedIndex == 0 {
           // self.titleBar.title  = "New Bookings"
        }
        if tabBarController.selectedIndex == 1 {
           // self.titleBar.title  = "Completed Bookings"
        }
        if tabBarController.selectedIndex == 2 {
          //  self.titleBar.title = "Cancelled Bookings"
        }
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return  // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCrossDissolve], completion: nil)
        }
        if tabBarController.selectedIndex == 0 {
           // self.titleBar.title  = "New Bookings"
        }
        if tabBarController.selectedIndex == 1 {
           // self.titleBar.title  = "Completed Bookings"
        }
        if tabBarController.selectedIndex == 2 {
           // self.titleBar.title = "Cancelled Bookings"
        }
    }
}
