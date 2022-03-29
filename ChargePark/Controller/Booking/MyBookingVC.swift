//
//  MyBookingVC.swift
//  ChargePark
//
//  Created by apple on 20/10/21.
//

import UIKit

class MyBookingVC: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    private var tbvc : BookingTabVC?
    var bookings:[Booking] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvc = tabBarController as? BookingTabVC
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.backgroundColor = Theme.menuHeaderColor
        self.navigationController?.navigationBar.isTranslucent = false;
        navigation.barTintColor = Theme.menuHeaderColor
        navigation.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigation.titleTextAttributes = textAttributes
       // navigationController?.navigationBar.titleTextAttributes = textAttributes
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
      //  self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
//
//        self.titleBar.title = "New Bookings"
        self.tableView.registerNibs(nibNames: ["MyBookingCell",EmptyCellCell.identifier])
//        let heightS = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        let yOffset =  heightS + self.navigationController!.navigationBar.frame.size.height
//        tableView.contentInset = UIEdgeInsets(top: yOffset, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
       // self.sendRequestForMyBookingList(false)
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        //UIApplication.shared.statusBarFrame.size.height
        let heightS = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let yOffset =  heightS + self.navigationController!.navigationBar.frame.size.height
      //  tableView.contentInset = UIEdgeInsets(top: yOffset, left: 0, bottom: 0, right: 0)
       // self.tableView.ScrollIndicatorInsets = new UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0);
    }
    func sendRequestForMyBookingList(_ isRefresh:Bool)  {
        if let userName = Defaults.shared.userLogin?.username{
            let req = ApiGetRequest()
            if  isRefresh != true{
                self.showLoader()
//                DispatchQueue.main.async {
//                self.view.startShimmeringAnimation()
//                }
            }
            req.kindOf(Theme.BookingList, requestFor: .MY_BOOKINGS, queryString: [userName], response: MyBookings.self) { [weak self] respons in
                self?.hideLoader()

                if let res = respons{
                    if let msg = res.message,let success = res.success, success == true && msg == "Ok"{
                        if let bookings = res.result{
                            self?.bookings = bookings.filter({$0.status == "S"||$0.status == "B"||$0.status == "R"})
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                            if isRefresh == true {
                                self?.hideLoader()
                                DispatchQueue.main.async {
                               // Defaults.shared.bookingType = .General
                                self?.displayAlert(alertMessage: "Booking Cancelled Successfully")
                                }
                            }
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? CancelMsgVC{
            if let indexValue = sender as? Int{
                vc.confirmCancel = { [weak self] controller in
                    controller.dismiss(animated: true) {
                        if let bookingId = self?.bookings[indexValue].bookingID {
                            self?.cancelBooking(bookingId: bookingId)
                        }
                    }
                }
            }
        }
    }
    
    func cancelBooking(bookingId:Int) {
        let id = String(bookingId)
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.ChangeBookingStatus, requestFor: .CHANGE_BOOKING_STATUS, queryString: [id], response: CancelBooking.self) {[weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ = res.message, let success = res.success,success == true{
                Defaults.shared.bookingType = .General
                self?.sendRequestForMyBookingList(true)
                /*
                DispatchQueue.main.async {
                    let alert:UIAlertController
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch (deviceIdiom) {
                    case .pad:
                        alert = UIAlertController(title: Theme.appName, message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler:{ alert in
                            self.sendRequestForMyBookingList(true)
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    case .phone:
                        alert = UIAlertController(title: Theme.appName, message: "", preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "Refresh booking list", style: .default, handler:{ alert in
                            self.sendRequestForMyBookingList(true)
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    case .tv:
                        print("tvOS style UI")
                    default:
                        print("Unspecified UI idiom")
                    }
                   
                   // self.displayAlert(alertMessage: "Booking Cancelled Successfully")
                   
                }*/
               
            }else{
                DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Unable to delete this booking")
                }
            }
        }
    }
}
extension MyBookingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookings.count > 0 ? self.bookings.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.bookings.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell", for: indexPath) as! MyBookingCell
            cell.selectionStyle = .none
            cell.cancelBooking = { [weak self] indexValue in
               // print("CancelBookings")
                self?.performSegue(withIdentifier: "Cancel", sender: indexValue)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCellCell.identifier, for: indexPath) as! EmptyCellCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.bookings.count > 0 {
        let cell = cell as! MyBookingCell
            if let status = self.bookings[indexPath.row].status,status == "S" || status == "B" || status == "R" {
                cell.setCellForStartAndBooked(data: self.bookings[indexPath.row], tag: indexPath.row)
            }
        }else{
            let cell = cell as! EmptyCellCell
            cell.backgroundColor = Theme.menuHeaderColor
            cell.contentView.backgroundColor = Theme.menuHeaderColor
            cell.backgroundColor = Theme.menuHeaderColor
            cell.img.image =  #imageLiteral(resourceName: "My Vehicle").tint(with: .white)
            cell.lblTitle.textColor = .white
            cell.lblTitle.text = "No bookings found."
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.bookings.count > 0 {
        return 150
        }else{
            return self.tableView.bounds.size.height
        }
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.bookings.count > 0 {
            if let status = self.bookings[indexPath.row].status, status == "S" || status == "R" {
                
                let story = UIStoryboard(name: "StartCharging", bundle: nil)
                
                if let vc = story.instantiateViewController(withIdentifier: "StrartChargingVC") as? StrartChargingVC{
                    if let id = self.bookings[indexPath.row].bookingID {
                        vc.bookingType = .General
                        vc.bookingId = id
                    }
                    tbvc?.navigationController?.pushViewController(vc, animated:  true)
                }
            }
        }
    }
}
