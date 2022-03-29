//
//  NewLoader.swift
//  ChargePark
//
//  Created by apple on 06/11/21.
//

import UIKit
import Network
class NewLoader: UIViewController {
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var view2:UIView!
    @IBOutlet weak var view3:UIView!
  //  var timer,timer1:Timer!
    var noInternetConnection:((Bool)->()) = { _ in}
    var bool1,bool2,bool3:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        bool1 = true
        bool2 = false
        bool3 = false
        viewContainer.cornerRadius(with: 12.0)
        self.view.backgroundColor = .black.withAlphaComponent(0.670)
        viewContainer.backgroundColor = .black.withAlphaComponent(0.770)
        // Do any additional setup after loading the view.
       // viewContainer.cornerRadius(with: 8.0)
       // viewContainer.backgroundColor = .clear
        let redi = view1.bounds.width/2
        view1.cornerRadius(with: redi)
        view2.cornerRadius(with: redi)
        view3.cornerRadius(with: redi)
        
//        self.view1.backgroundColor = Theme.menuHeaderColor
//        self.view2.backgroundColor = .darkGray
//        self.view3.backgroundColor = .lightGray
        
//        self.view1.backgroundColor = .red
//        self.view2.backgroundColor = .green
//        self.view3.backgroundColor = .blue
        fluctuation()//
       // timer =  Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fluctuation), userInfo: nil, repeats: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.fluctuation()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
       // timer1 =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkInternetConnectivity), userInfo: nil, repeats: true)
       // checkInternetConnectivity()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // dismiss(animated: true, completion: nil)
    }
    func dimmiss(){
       // timer.invalidate()
       // self.timer1.invalidate()
        dismiss(animated: true, completion: nil)
    }
   @objc public func checkInternetConnectivity(){
       let monitor = NWPathMonitor()
       let queue = DispatchQueue.global(qos: .background)
       monitor.start(queue: queue)
       // let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
      //  DispatchQueue.main.async {
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("satisfied")
                }else{
                    DispatchQueue.main.async {
                        monitor.cancel()
                       // self.timer.invalidate()
                        self.dismiss(animated: true) {
                            self.noInternetConnection(true)
                        }
                    }
                }
            }
       // }
     }
   @objc func fluctuation(){
//       let x1 = self.view1.center.x
//       let x2 = self.view2.center.x
//       let x3 = self.view3.center.x
       /*
       let x1 =  self.view1.frame.size
       let x2 =  self.view2.frame.size
       let x3 =  self.view3.frame.size
       
       UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse,.curveEaseInOut], animations: {
           
           self.view1.backgroundColor = .red
           self.view2.backgroundColor = .green
           self.view3.backgroundColor = .blue
           
           self.view1.frame.size.width += 5
           self.view1.frame.size.height += 5
           
           self.view2.frame.size.width += 5
           self.view2.frame.size.height += 5
           
           self.view3.frame.size.width += 5
           self.view3.frame.size.height += 5
           
//           self.view1.frame.size.width += 13
//           self.view1.frame.size.height += 13
//
//           self.view2.frame.size.width += 9
//           self.view2.frame.size.height += 9
//
//           self.view3.frame.size.width += 5
//           self.view3.frame.size.height += 5
           
//           let redi = self.view1.bounds.width/2
//           self.view1.cornerRadius(with: redi)
//           self.view2.cornerRadius(with: redi)
//           self.view3.cornerRadius(with: redi)
//
//           self.view1.center.x = x2
//           self.view2.center.x = x3
//           self.view3.center.x = x1
//           self.view1.backgroundColor = .blue
//           self.view2.backgroundColor = .red
//           self.view3.backgroundColor = .green
           
       }, completion: { _ in
//           self.view1.frame.size = x1
//           self.view2.frame.size = x2
//           self.view3.frame.size = x3
       })
       */
        if bool1 == true {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view1.backgroundColor = .white
                self.view2.backgroundColor = Theme.menuHeaderColor
                self.view3.backgroundColor = .white
            }, completion: nil)
            self.bool2 = true
            
        }
        if bool2 == true {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view1.backgroundColor = .white
                self.view2.backgroundColor = .white
                self.view3.backgroundColor = Theme.menuHeaderColor
            }, completion: nil)
            self.bool3 = true
           
        }
        if bool3 == true {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view1.backgroundColor = Theme.menuHeaderColor
                self.view2.backgroundColor = .white
                self.view3.backgroundColor = .white
            }, completion: nil)
            self.bool1 = true
           
        }
   }
    deinit {
        print("\(self) is deinit")
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
