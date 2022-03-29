//
//  DialogLoaderViewController.swift
//  ChargePark
//
//  Created by apple on 25/06/1943 Saka.
//

import UIKit
import Network
class DialogLoaderViewController: UIViewController {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewSpinner: Card!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loderMessage: UILabel!
     var noInternetConnection:((Bool)->()) = { _ in}
    var message = ""
  // weak var timer:Timer!
    override func loadView() {
        Bundle.main.loadNibNamed("DialogLoaderViewController", owner: self, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.77)
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.checkInternetConnectivity()
        })
       // timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkInternetConnectivity), userInfo: nil, repeats: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillDisappear(_ animated: Bool) {
    if animated {view.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @objc public func checkInternetConnectivity(){
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        // let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
       //  DispatchQueue.main.async {
             monitor.pathUpdateHandler = {[weak self] path in
                 if path.status == .satisfied {
                     print("satisfied")
                 }else{
                     DispatchQueue.main.async {
                         monitor.cancel()
                       //  self?.timer.invalidate()
                         self?.dismiss(animated: true) {
                             self?.noInternetConnection(true)
                         }
                     }
                 }
             }
        // }
      }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // self.timer.invalidate()
        self.dismiss(animated: true,completion: nil) 
    }
    
   func displayMessage(message: String = "Loading.."){
      loderMessage.text = message
  
    }
    deinit {
      //  self.timer.invalidate()
        print("\(self) is deinit")
    }
}

    

    
