//
//  CancelledBookingVC.swift
//  ChargePark
//
//  Created by apple on 09/01/22.
//

import UIKit

class CancelledBookingVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    var bookings:[Booking] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.backgroundColor = Theme.menuHeaderColor
        navigation.barTintColor = Theme.menuHeaderColor
        navigation.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigation.titleTextAttributes = textAttributes
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
       // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }

        self.tableView.registerNibs(nibNames: ["MyBookingCell",EmptyCellCell.identifier])
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
extension CancelledBookingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookings.count > 0 ? self.bookings.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.bookings.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell", for: indexPath) as! MyBookingCell
            cell.selectionStyle = .none
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
          cell.setCellData(data: self.bookings[indexPath.row],tag:indexPath.row)
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
     
    
    
}
