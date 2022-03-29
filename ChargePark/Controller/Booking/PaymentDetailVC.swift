//
//  PaymentDetailVC.swift
//  ChargePark
//
//  Created by apple on 17/11/21.
//

import UIKit

class PaymentDetailVC: UIViewController {
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var btnBack:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    @IBOutlet weak var btnPay:UIButton!
    @IBOutlet weak var tableView:UITableView!
    var booking:ResultBookingStatus?
    var paymentView:PaymentViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.registerNibs(nibNames: ["LabelCell","TwoLabelCell"])
       // self.btnBack.action = #selector(back)
        if let vc = self.revealViewController().frontViewController as? Self{
            self.booking = vc.booking
        }
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Payment Status"
        }
       // self.btnBack.isEnabled = false
        if self.revealViewController() != nil{
            self.btnBack.target = self.revealViewController()
            self.btnBack.action = #selector(SWRevealViewController.revealToggle(_:))
            self.btnBack.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        createModel()
        setTheme()
    }
    private func createModel(){
        if let data = booking{
        paymentView = PaymentViewModel(data: data)
        }
    }
   private func setTheme(){
        navigation.barTintColor = Theme.menuHeaderColor
        btnPay.cornerRadius(with: 8.0)
        btnPay.setImage(#imageLiteral(resourceName: "Wallet").tint(with: .white), for: .normal)
        btnPay.backgroundColor = Theme.menuHeaderColor
        btnPay.setTitleColor(.white, for: .normal)
        btnPay.setTitle(" Continue", for: .normal)
        btnPay.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }

    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func payment(){
        DispatchQueue.main.async {
        let homwSy = UIStoryboard(name: "Home", bundle: nil)
        let front = homwSy.instantiateViewController(withIdentifier: "StationNavigation") as? UINavigationController
           // txtMobileNumber
        let rear = homwSy.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
           // ?.viewControllers.first as? StationViewController
            if let swRevealVC = SWRevealViewController(rearViewController:rear, frontViewController: front){
        self.navigationController?.pushViewController(swRevealVC, animated: true)
        }
      }
        /*
        if let booking = self.booking, let status = booking.status,let pId = booking.invoiceId ,status == "C" {
            let request = MakeBookingPayment(paymentId: String(pId), status: "S")
            let req = ApiPostRequest()
            self.showLoader()
            req.kindOf(Theme.MakeBookingPayment, requestFor: .MAKE_BOOKING_PAYMENT, request: request, response: MakeBookingPaymentRespo.self) { [weak self] respons in
                self?.hideLoader()
                if let  res = respons,let _ = res.message,let succes = res.success,succes == true{
                    DispatchQueue.main.async {
                        self?.btnBack.isEnabled = true
                        self?.displayAlert(alertMessage: Theme.Done_Payment)
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                self.displayAlert(alertMessage: Theme.Payment_Not_Done)
            }
        }*/
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
extension PaymentDetailVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paymentView != nil {
            return paymentView.paymentData.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.lbl.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
        cell.lbl.textAlignment = .left
        cell.view.cornerRadius(with: 6.0)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! LabelCell
        cell.lbl.text = paymentView.paymentData[indexPath.row].title
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
