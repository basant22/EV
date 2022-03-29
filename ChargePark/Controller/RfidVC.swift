//
//  RfidVC.swift
//  ChargePark
//
//  Created by apple on 02/12/21.
//

import UIKit
import SkyFloatingLabelTextField

class RfidVC: UIViewController {
    
    @IBOutlet weak var widthOfRfid: NSLayoutConstraint!
    @IBOutlet weak var heightOfRequsetView: NSLayoutConstraint!
    @IBOutlet weak var viewReqMgs:UIView!
    @IBOutlet weak var lblReqMsg:UILabel!
  //  @IBOutlet weak var heightOfView: NSLayoutConstraint!
    @IBOutlet weak var viewMain:UIView!
    @IBOutlet weak var viewRfid:UIView!
    @IBOutlet weak var txtRfid:SkyFloatingLabelTextField!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnAddRemove:UIButton!
    @IBOutlet weak var btnAddRF:UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var btnRequestRFID: UIButton!
    @IBOutlet weak var titleBar: UIBarButtonItem!
    @IBOutlet weak var navigationCon: UINavigationBar!
    var boolRfid = true
    var isFlip = false
    var strRfid = ""
    var dataSource:[RfIdResult] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       // btnAddRemove.setTitle("", for: .normal)
       // txtRfid.isHidden = true
        self.viewReqMgs.isHidden = true
        self.heightOfRequsetView.constant = 0
       // self.viewMain.isHidden = true
        self.tableView.backgroundColor = .lightGray
      //  tableView.isHidden = true
      //  self.heightOfView.constant = 50
//        let newConstraint = self.widthOfRfid.constraintWithMultiplier(0.0)
//        self.viewRfid.removeConstraint(self.widthOfRfid)
//        self.viewRfid.addConstraint(newConstraint)
//        self.viewRfid.layoutIfNeeded()
       // self.widthOfRfid.constant = 0
       
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
       
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        tableView.registerNibs(nibNames: ["RfidCell"])
        setTheme()
    }
    func setTheme(){
       // viewRfid.backgroundColor = .white
        let img = #imageLiteral(resourceName: "Add").tint(with:  Theme.menuHeaderColor)
       // btnAddRemove.setImage( img , for: .normal)
       // viewRfid.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
        btnAddRF.backgroundColor = Theme.menuHeaderColor
        btnAddRF.setImage(img?.tint(with: .white), for: .normal)
        btnAddRF.setTitleColor(.white, for: .normal)
        btnAddRF.cornerRadius(with: 6.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callForRFIDs()
    }
    /*func callForRFID(){
        let req = ApiGetRequest()
        let un = Defaults.shared.userLogin?.username ?? ""
        req.kindOf(Theme.Rfid, requestFor: .RFIF_RFID, queryString: [un], response: RfIdSelf.self) { [weak self](response) in
            self?.hideLoader()
            if let res = response,let msg = res.message,let succ = res.success,succ == true && msg == Theme.Message{
                if let result = res.result {
                    self?.dataSource.append(result)
                    DispatchQueue.main.async {
                    self?.viewRfid.isHidden = true
                        self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                }
                }
            }else{
                DispatchQueue.main.async {
                    self?.tableView.isHidden = true
                    self?.viewRfid.isHidden = false
                    self?.displayAlert(alertMessage: "No RFID found!")
                }
            }
        }
    }*/
    @IBAction func btnRequestRFID_Action(_ sender:UIButton){
        let tag = sender.tag
        if tag == 101 {
            self.performSegue(withIdentifier: "RFID", sender: nil)
        }else{
            self.addRFIdRequest()
        }
    }
    func btnAddRf(){
        self.tableView.isHidden = true
        self.btnAddRF.isHidden = false
        self.btnAddRF.tag = 101
        let img = UIImage(named: "Add")?.tint(with: .white)
        self.btnAddRF.setImage(img, for: .normal)
        self.btnAddRF.setTitle("  Add", for: .normal)
    }
    func btnAddRfForRequest(){
        self.tableView.isHidden = true
        self.btnAddRF.isHidden = false
        self.btnAddRF.tag = 102
        let img = UIImage(named: "Add")?.tint(with: .white)
        self.btnAddRF.setImage(img, for: .normal)
        self.btnAddRF.setTitle("  Request For RFId", for: .normal)
    }
    func callForRFIDs(){
        if Defaults.shared.usrProfile?.rfid == "Requested"{
            self.viewReqMgs.backgroundColor = Theme.menuHeaderColor
            self.viewReqMgs.isHidden = false
            self.heightOfRequsetView.constant = 44
            self.lblReqMsg.text = "New Rfid Requested"
            btnAddRf()
        }
       else if Defaults.shared.usrProfile?.rfid == "Blocked"{
           btnAddRfForRequest()
       }else{
           btnAddRf()
       }
        
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.Rfidby_username, requestFor: .RFIF_USERNAME, queryString: [nil], response: RfId.self) {[weak self] (response) in
            self?.hideLoader()
            if let res = response,let msg = res.message,let succ = res.success,succ == true && msg == Theme.Message{
                //self?.callForRFID()
                if let result = res.result {
                    self?.dataSource = result
                    DispatchQueue.main.async {
                    if result.count > 0 {
                            self?.btnAddRF.isHidden = true
                            self?.viewReqMgs.isHidden = true
                            self?.tableView.isHidden = false
                            self?.tableView.reloadData()
                    }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    UIView.transition(with: UIView(), duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self?.tableView.isHidden = true
                       // self?.viewRfid.isHidden = false
                                  })
                   
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func addRFIdRequest(){
        self.showLoader()
        ApiGetRequest().kindOf(Theme.Request_rfid, requestFor: .RFIF_REQUEST, queryString: [nil], response: RfidRequest.self) {[weak self] (respons) in
            self?.hideLoader()
            if let res = respons,let msg = res.message,let succ = res.success,let resul = res.result,succ == true{
               // self?.dataSource.append(resul)
              //  if self?.dataSource.count ?? 0 >= 1 {
                    DispatchQueue.main.async {
                        //self?.viewMain.isHidden = true
                        UIView.transition(with: UIView(), duration: 0.4,
                                          options: .transitionCrossDissolve,
                                          animations: {
                            //self?.tableView.isHidden = false
                            //self?.tableView.reloadData()
                            self?.viewReqMgs.isHidden = false
                            self?.heightOfRequsetView.constant = 44
                            let str = "New Rfid Requested"
                            self?.lblReqMsg.text = str
                            self?.viewReqMgs.backgroundColor = Theme.menuHeaderColor
                                      })
                        
                    }
               // }
            }
        }
    }
    /*
    @IBAction func AddRF(_ sender:UIButton){
        if (txtRfid.text!.count > 0 ){
            strRfid = txtRfid.text!
            self.showLoader()
            ApiGetRequest().kindOf(Theme.Rfid, requestFor: .RFIF_RFID, queryString: [strRfid], response: RfIdSelf.self) {[weak self] (respons) in
                self?.hideLoader()
                if let res = respons,let msg = res.message,let succ = res.success,let resul = res.result,succ == true && msg == Theme.Message{
                    self?.dataSource.append(resul)
                    if self?.dataSource.count ?? 0 >= 1 {
                        DispatchQueue.main.async {
                            
                            UIView.transition(with: UIView(), duration: 0.4,
                                              options: .transitionCrossDissolve,
                                              animations: {
                               // self?.viewMain.isHidden = true
                                self?.tableView.isHidden = false
                                self?.tableView.reloadData()
                                          })
                            
                        }
                    }
                }
            }
        }else{
            self.displayAlert(alertMessage: "Please Enter RFID")
        }
        
       
    }*/
    /*
    @IBAction func AddRfid(_ sender:UIButton){
        if boolRfid == true{
            boolRfid = false
            txtRfid.isHidden = false
            UIView.animate(withDuration: 1.5, delay: 0.01, options: .curveEaseInOut) {
                switch Theme.deviceIdiom{
                case .phone:
                    self.widthOfRfid.constant = self.viewMain.frame.width - 125
                case .pad:
                    self.widthOfRfid.constant = self.viewMain.frame.width - 125
                case .carPlay,.mac,.tv:
                print("")
                case .unspecified:
                    print("")
                @unknown default:
                    print("")
                }
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 2.85, animations: {
//                self.viewRfid.frame = CGRect(x: self.viewRfid.frame.minX, y: self.viewRfid.frame.midY, width: self.viewRfid.frame.width, height: self.viewRfid.frame.height)
                
               

            })
        }else{
            boolRfid = true
            txtRfid.isHidden = true
            UIView.animate(withDuration: 1.5, delay: 0.01, options: .curveEaseInOut) {
                self.widthOfRfid.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
        setImageOfButton()
    }*/
    func setImageOfButton(){
        if boolRfid == false{
        let img = #imageLiteral(resourceName: "Close").tint(with:  Theme.menuHeaderColor)
       // btnAddRemove.setImage( img , for: .normal)
        }else{
            let img = #imageLiteral(resourceName: "Add").tint(with:  Theme.menuHeaderColor)
           // btnAddRemove.setImage( img , for: .normal)
        }
    }
    func deleteRfid(completion:@escaping(Bool)->()){
        let api = ApiGetRequest()
        api.kindOf(Theme.Remove_rfid, requestFor: .RFIF_REMOVE, queryString: [nil], response: RemoveRfid.self) {[weak self] (response) in
            if let res = response,let msg = res.message,let succ = res.success,succ == true{
                DispatchQueue.main.async {
                    completion(true)
                   // self?.dataSource.removeAll()
                }
            }else{
                completion(false)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RFID"{
            if let vc = segue.destination as? AddRfidVC{
                vc.calledAddRfid = { [weak self] (rfid,control) in
                    control.dismiss(animated: true) {
                       
                    }
                }
            }
        }
    }

}
extension RfidVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count > 0 ? dataSource.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RfidCell.identifier, for: indexPath) as! RfidCell
        cell.selectionStyle = .none
        
        cell.deleteSelectedRfid = { [weak self] indx in
           
            self?.deleteRfid { isDelete in
                if isDelete == true {
                   // self?.dataSource.remove(at: indx)
                    self?.dataSource[indx].btnTitle = " Blocked"
                    UIView.transition(with: UIView(), duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                       // tableView.deleteRows(at: [indexPath], with: .fade)
                        self?.tableView.reloadData()
                                  })
                    
                }else{
                    DispatchQueue.main.async {
                        self?.dataSource[indx].btnTitle = "  Block Rfid"
                        self?.displayAlert(alertMessage: "Unable to delete")
                       // self?.dataSource[indx].isFlip = isDelete
                       // self?.tableView.reloadData()
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! RfidCell
        if self.dataSource.count > 0 {
            cell.setupCell(data: self.dataSource[indexPath.row],indx: indexPath.row)
        }
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            self.deleteRfid {[weak self] isDelete in
//                if isDelete == true {
//                    self?.dataSource.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                }else{
//                    DispatchQueue.main.async {
//                        self?.displayAlert(alertMessage: "Unable to delete")
//                    }
//                }
//            }
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.dataSource[indexPath.row].isFlip = !isFlip
//             self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    /*
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           // print("Deleted")
            self.deleteRfid { delted in
                if delted{
                    self.tableView.reloadData()
                    self.tableView.isHidden = true
                    self.viewMain.isHidden = false
                }else{
                    DispatchQueue.main.async {
                    self.displayAlert(alertMessage: "Unable to delete")
                  }
                }
            }
        }
    }*/
}
