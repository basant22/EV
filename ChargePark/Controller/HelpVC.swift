//
//  HelpVC.swift
//  ChargePark
//
//  Created by apple on 28/06/1943 Saka.
//

import UIKit
import SafariServices
import MessageUI
class HelpVC: UIViewController,SFSafariViewControllerDelegate,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleBar: UIBarButtonItem!
    @IBOutlet weak var navigationCon: UINavigationBar!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblTiming:UILabel!
    @IBOutlet weak var lblWWW:UILabel!
    @IBOutlet weak var lblMobile:UILabel!
    @IBOutlet weak var lblMobile1:UILabel!
    @IBOutlet weak var lblHelp:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var imgWww:UIImageView!
    @IBOutlet weak var imgMobile:UIImageView!
    @IBOutlet weak var imgMobileNew:UIImageView!
    @IBOutlet weak var imgHelp:UIImageView!
    @IBOutlet weak var imgEmail:UIImageView!
    @IBOutlet weak var btnCall:UIButton!
    @IBOutlet weak var btnCall1:UIButton!
    @IBOutlet weak var btnWww:UIButton!
    @IBOutlet weak var btnEmail:UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewStackV: UIStackView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        btnWww.setTitle("", for: .normal)
        btnCall.setTitle("", for: .normal)
        btnCall1.setTitle("", for: .normal)
        btnEmail.setTitle("", for: .normal)
        lblName.textColor = Theme.menuHeaderColor
        self.lblTiming.textColor = Theme.menuHeaderColor
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Contact Us"
        }
        if Theme.appName == "EV Plugin Charge"{
            self.titleBar.title = "Support"
        }
        if Theme.appName != "V-Power"{
            self.lblTiming.isHidden = true
        }
        imgHelp.image = #imageLiteral(resourceName: "HelpLogo")
        lblHelp.text = "Welcome to Help and Support"
        lblHelp.textColor = Theme.menuHeaderColor
        lblName.text = Theme.appName
        lblWWW.text = Theme.HelpWebsite
        lblMobile.text = Theme.HelpMobileNumber
        if Theme.HelpEmail.count > 0 {
            view4.isHidden = false
            imgEmail.isHidden = false
            btnEmail.isHidden = false
            lblEmail.text = Theme.HelpEmail
        }else{
            view4.isHidden = true
            imgEmail.isHidden = true
            btnEmail.isHidden = true
            lblEmail.isHidden = true
        }
        if Theme.HelpMobileNumberNew.count > 0 {
            view3.isHidden = false
            imgMobileNew.isHidden = false
            btnCall1.isHidden = false
            lblMobile1.text = Theme.HelpMobileNumberNew
        }else{
            view3.isHidden = true
            imgMobileNew.isHidden = true
            btnCall1.isHidden = true
            lblMobile1.isHidden = true
        }
    }
    @IBAction func openSafariVC(_ sender: UIButton) {
                let safariVC = SFSafariViewController(url: NSURL(string: Theme.HelpWebsite)! as URL)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }

            func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                controller.dismiss(animated: true, completion: nil)
            }
    @IBAction func btnCallTo(_ sender: UIButton) {
      
            if let url = URL(string: "tel://\(Theme.HelpMobileNumber)"),
                   UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        }
    }
    @IBAction func btnCallNew(_ sender: UIButton) {
      
            if let url = URL(string: "tel://\(Theme.HelpMobileNumberNew)"),
                   UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        }
    }
    @IBAction func btnEmail(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            self.displayAlert(alertMessage: "Mail services are not available in this device")
            return
        }else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients([Theme.HelpEmail])
            composeVC.setSubject("Help me regarding")
            composeVC.setMessageBody("Hi \(Theme.appName) team", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       // pickerV.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("\(self) id deinitialized")
    }
}
