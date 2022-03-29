//
//  TransactionVC.swift
//  ChargePark
//
//  Created by apple on 27/10/21.
//

import UIKit

class TransactionVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    var transaction:[SavePaymentResult]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.registerNibs(nibNames: ["TransactionCell"])
        self.tableView.backgroundColor = UIColor.lightGray
        self.transaction.reverse()
    }
    @objc func close(){
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

}
extension TransactionVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewH = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50))
        viewH.backgroundColor = Theme.menuHeaderColor
        let lableTitle = UILabel(frame: CGRect(x: 10, y: 10, width: 250, height: 30))
        lableTitle.text = "Transaction History"
        if Theme.appName == "VRAJEV Charge"{
            lableTitle.text = "My Transactions"
        }
        lableTitle.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
        lableTitle.textColor = .white
        let btnClose = UIButton(frame: CGRect(x: self.tableView.bounds.width - 55 , y: 1, width: 48, height: 48))
          // #imageLiteral(resourceName: "Cancel").tint(with: .white)
        btnClose.setBackgroundImage(UIImage(named: "Cancel")!.tint(with: .white), for: .normal)
     //   btnClose.setImage(UIImage(named: "Cancel")!.tint(with: .white), for: .normal)
       // btnClose.setImage(,for:.normal)
        btnClose.cornerRadius(with: 24.0)
        btnClose.addTarget(self, action: #selector(close), for: .touchUpInside)
        viewH.addSubview(lableTitle)
        viewH.addSubview(btnClose)
        return viewH
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transaction.count > 0 ?  self.transaction.count:0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! TransactionCell
        cell.setCellData(data: self.transaction[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
