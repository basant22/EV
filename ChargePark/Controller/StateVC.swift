//
//  StateVC.swift
//  ChargePark
//
//  Created by apple on 24/06/1943 Saka.
//

import UIKit

class StateVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var buttobClose:UIButton!
    @IBOutlet weak var viewTitle:UIView!
    @IBOutlet weak var imgClose:UIImageView!
    var statesOfIndia:[String] = []
    var selectedState: ((String)->())! = { _ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNibs(nibNames: ["LabelCell"])
        imgClose.image = #imageLiteral(resourceName: "Cancel").tint(with: .white)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
//        buttobClose.setImage(#imageLiteral(resourceName: "Cancel").tint(with: .white), for: .normal)
        self.viewTitle.backgroundColor = Theme.menuHeaderColor
 statesOfIndia = ["Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka",
                  "Kerala",
                  "Madhya Pradesh",
                  "Maharashtra",
                  "Manipur",
                  "Meghalaya",
                  "Mizoram",
                  "Nagaland",
                  "Odisha",
                  "Punjab",
                  "Rajasthan",
                  "Sikkim",
                  "Tamil Nadu",
                  "Telangana",
                  "Tripura",
                  "Uttarakhand",
                  "Uttar Pradesh",
                  "West Bengal",
                  "Andaman and Nicobar Islands",
                  "Chandigarh",
                  "Dadra and Nagar Haveli",
                  "Daman and Diu",
                  "Delhi",
                  "Lakshadweep",
                  "Puducherry"]
        // Do any additional setup after loading the view.
    }
    @IBAction func close(_ sender:UIButton){
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
extension StateVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statesOfIndia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.view.cornerRadius(with: 6.0)
        cell.view.backgroundColor = .clear
        cell.view.layer.borderWidth = 1.0
        cell.view.layer.borderColor = UIColor.white.cgColor
        cell.lbl.textColor = .white
        cell.lbl.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        cell.lbl.text = self.statesOfIndia[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state:String = self.statesOfIndia[indexPath.row]
      
        self.dismiss(animated: true, completion: { 
            self.selectedState(state)
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
