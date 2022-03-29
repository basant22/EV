//
//  QRCodeVC.swift
//  ChargePark
//
//  Created by apple on 07/11/21.
//

import UIKit
import AVFoundation
class QRCodeVC: UIViewController {
    
    @IBOutlet weak var btnClose:UIButton!
    @IBOutlet weak var btnStart:UIButton!
    @IBOutlet weak var btnTorch:UIButton!
    var stations:[ResultStation]!
    var locaStation:ResultStation?
    var isTorch = true
    var chargerId = ""
    var chargerPort = 0
    var resultCharger:[ResultCharger]? = []
    @IBOutlet weak var scannerView:QrScannerView!{
        didSet {
            scannerView.delegate = self
        }
    }
   
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                if let codes = qrData?.codeString,  codes.contains("-") && codes.components(separatedBy: "-").count == 3 {
                    let values = codes.components(separatedBy: "-")
                    let chId = values[1]
                    let chPort = values[2]
                    if chId.count > 0 && chPort.count > 0{
                        chargerId = chId
                        chargerPort = Int(chPort) ?? 0
                    }
                    
                    if let stationId = values.first{
                       
//                       if let location:ResultStation = self.stations.filter({$0.stationID == Int(stationId)}).first{
//                           self.locaStation = location
//                        }
                        
                        self.sendRequestForChargerByQR(stationId: String(stationId), charger: chargerId, port: String(chargerPort))
                       
                      /*  if  let location:ResultStation = self.stations.filter({$0.stationID == Int(stationId)}).first{
                            self.showLoader()
                          
                            self.sendRequestForChargerByStation(stationId: Int(stationId)!,location: location)
                        }else{
                                 let homwSy = UIStoryboard(name: "Book", bundle: nil)
                                 if let vc = homwSy.instantiateViewController(withIdentifier: "BookingStatusVC") as? BookingStatusVC,let code = qrData?.codeString{
                                     vc.chargerAndPort = code
                                     vc.bookingBy = .QrCode(false)
                                     self.navigationController?.pushViewController(vc, animated: true)
                                 }
                       
                             }*/
                        }
                }else{
                    self.displayAlert(alertMessage: "QrCode is irrelevant!.Please try another")
                }
//                let alert = UIAlertController(title: "QRCode OutPut", message: qrData?.codeString, preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
//                   // self.session.stopRunning()
//                }))
//
//                present(alert, animated: true, completion: nil)
               // self.performSegue(withIdentifier: "detailSeuge", sender: self)
            }
        }
    }
   
    override func viewDidLoad() {
       // super.viewDidLoad()
       // btnTorch.isHidden = true
        btnStart.cornerRadius(with: 8.0)
        btnStart.setTitle("STOP", for: .normal)
        btnClose.setTitle("", for: .normal)
        btnTorch.setTitle("", for: .normal)
        if let img = UIImage(systemName:"flashlight.off.fill"){
        btnTorch.setImage(img, for: .normal)
        }
        btnStart.backgroundColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if !device.hasTorch {
            btnTorch.isHidden = true
        }else{
            btnTorch.isHidden = false
        }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .black.withAlphaComponent(0.990)
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    @IBAction func closeController(_ sender:UIButton){
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func on_Off_Torch(_ sender:UIButton){
        self.toggleTorch(on: self.isTorch)
    }
    @IBAction func btnStart_Action(_ sender:UIButton){
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    deinit {
        print("\(self) id deinitialized")
    }
    func sendRequestForChargerByQR(stationId:String,charger:String,port:String){
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.Chargerportbystation, requestFor: .CHARGER_PORT_BY_STATION, queryString: [stationId,charger,port], response:ChargerResponseByQR.self) {[weak self] respo in
            self?.hideLoader()
            if let res = respo,let success = res.success,let msg =  res.message, let result = res.result,let charger =  result.charger,let station = result.station, let selectedCharger = charger.first,let selectedStation = station.first, msg == "Ok" && success == true  {
               
                DispatchQueue.main.async {
                   // if let veh = Defaults.shared.addedVehicle.result,veh.count >= 1{
                        let homwSy = UIStoryboard(name: "Book", bundle: nil)
                        if let vc = homwSy.instantiateViewController(withIdentifier: "BookingStatusVC") as? BookingStatusVC,let _ = self?.qrData?.codeString{
                            var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil,userEvId: nil,station: nil)
                            select.charger = selectedCharger
                            select.chargingpoint = self?.chargerPort
                            select.stationByQr = selectedStation
                            select.bookedUsing = "QR"
                            vc.selectedStation = select
                            vc.resultCharger = selectedCharger
                            vc.bookingBy = .QrCode(true)
                            
                            self?.navigationController?.pushViewController(vc, animated: true)
                       // }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Unable to proceed please try another")
                }
            }
        }
    }
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .on
                    self.isTorch = false
                    if let img = UIImage(systemName:"flashlight.on.fill"){
                    btnTorch.setImage(img, for: .normal)
                    }
                } else {
                    device.torchMode = .off
                    self.isTorch = true
                    if let img = UIImage(systemName:"flashlight.off.fill"){
                    btnTorch.setImage(img, for: .normal)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
   
}
extension QRCodeVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailSeuge", let viewController = segue.destination as? DetailViewController {
//            viewController.qrData = self.qrData
//        }
    }
}

extension QRCodeVC:QRScannerDelegate{
    func qrScanningDidFail() {
        self.displayAlert(alertMessage: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
       // print("\(String(describing: str))")
        self.qrData = QRData(codeString: str)
    }
    
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        btnStart.setTitle(buttonTitle, for: .normal)
    }
}
struct QRData {
    var codeString: String?
}
