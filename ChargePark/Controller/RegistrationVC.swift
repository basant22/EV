//
//  RegistrationVC.swift
//  ChargePark
//
//  Created by apple on 22/06/1943 Saka.
//

import UIKit

class RegistrationVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigationCon: UINavigationBar!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnRegistration: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    var dataSource:[(UIImage,String)] = []
    var registraRequest:RegistrationRequest!
    var password:String?
    var confirmPassword:String?
    var passwordBool = false
    var confirmPasswordBool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let usertype = Defaults.shared.userType,usertype == .guest{
            if  self.revealViewController() != nil{
                btnBack.target = self.revealViewController()
                btnBack.action = #selector(SWRevealViewController.revealToggle(_:))
                btnBack.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                  }
        }else{
           // btnBack.action = #selector()
        }
        
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Register Yourself"
        }
        
        
        
        
        
        registraRequest = RegistrationRequest(username: "",firstName: "", lastName: "", email: "",password: "",opId: 0,type: 1)
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.registerNibs(nibNames: ["TextCell","ButtonCell"])
        // Do any additional setup after loading the view.
        dataSource = [(#imageLiteral(resourceName: "Name"),"First Name"),(#imageLiteral(resourceName: "Name"),"Last Name"),(#imageLiteral(resourceName: "Mobile"),"Mobile Number"),(#imageLiteral(resourceName: "Email"),"Email"),(#imageLiteral(resourceName: "Password"),"Password"),(#imageLiteral(resourceName: "Password"),"Confirm Password")]
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnRegistration.cornerRadius(with: 6.0)
        btnRegistration.backgroundColor = Theme.menuHeaderColor
        btnRegistration.setTitleColor(.white, for: .normal)
        btnRegistration.setTitle("Register", for: .normal)
        btnRegistration.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 19.0)
        btnLogin.setAttributedTitle(AttrubutedString.creatAttributedStringOfSize(19.0,"Already Registerd ?", " Login Here"), for: .normal)
    }
    @IBAction func back(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRegistration(_ sender:UIButton){
        self.userRegistration(request: self.registraRequest)
    }
    @IBAction func btnLogin(_ sender:UIButton){
        self.performSegue(withIdentifier: "Login", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Login"{
            if let vc = segue.destination as? LoginVC,let userName = sender as? String{
                vc.userNameFromReg = sender as! String
            }
        }
    }
    
    deinit {
        print("\(self) id deinitialized")
    }
}

