//
//  StationsExtension.swift
//  ChargePark
//
//  Created by apple on 25/06/1943 Saka.
//

import Foundation
import GoogleMaps
extension StationViewController :  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
   
    func showAlert(marker:GMSMarker?) {
        var titele1 = "Open Gallery"
        var titele2 = "QR Scan"
        if marker != nil {
            titele1 = "Add to favorite"
            titele2 = "Proceed to charger"
        }
       
       
        
        switch (Theme.deviceIdiom) {
        case .pad:
            let alert = UIAlertController(title: Theme.appName, message: "Please Select an Option", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: titele1, style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.openGallery(alert: alert)
            }))
            
            alert.addAction(UIAlertAction(title: titele2, style: .default , handler:{ (UIAlertAction)in
                alert.dismiss(animated: true, completion: {
                    if titele2 == "Proceed to charger" {
                        if let stationId = marker?.title {
                            let location:[ResultStation] = self.stationLocation.filter({$0.stationID == Int(stationId)})
                            if let location = location.first,let stId = location.stationID {
                                self.showLoader()
                                self.sendRequestForChargerByStation(stationId: stId,location: location)
                            }
                        }
                    }else{
                        self.performSegue(withIdentifier: "QrCode", sender: nil)
                    }
                })
            }))

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
           
            alert.view.tintColor = Theme.menuHeaderColor
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
           // alert.popoverPresentationController?.sourceView = self.view
        case .phone:
            let alert = UIAlertController(title: Theme.appName, message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: titele1, style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.openGallery(alert: alert)
            }))
            
            alert.addAction(UIAlertAction(title: titele2, style: .default , handler:{ (UIAlertAction)in
                alert.dismiss(animated: true, completion: {
                    if titele2 == "Proceed to charger" {
                        if let stationId = marker?.title {
                            let location:[ResultStation] = self.stationLocation.filter({$0.stationID == Int(stationId)})
                            if let location = location.first,let stId = location.stationID {
                                self.showLoader()
                                self.sendRequestForChargerByStation(stationId: stId,location: location)
                            }
                        }
                    }else{
                        self.performSegue(withIdentifier: "QrCode", sender: nil)
                    }
                })
            }))

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
                print("User click Dismiss button")
            }))
           
            alert.view.tintColor = Theme.menuHeaderColor
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        case .tv:
            print("Unspecified UI idiom")
        default:
            print("Unspecified UI idiom")
        }
    }
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let qrcodeImg = info[.originalImage] as? UIImage {
//                let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
//                let ciImage:CIImage=CIImage(image:qrcodeImg)!
//                var qrCodeLink=""
//
//                let features=detector.features(in: ciImage)
//                for feature in features as! [CIQRCodeFeature] {
//                    qrCodeLink += feature.messageString!
//                }
//
//                if qrCodeLink=="" {
//                    print("nothing")
//                }else{
//                    print("message: \(qrCodeLink)")
//                }
//            }
//            else{
//               print("Something went wrong")
//            }
//           self.dismiss(animated: true, completion: nil)
//          }
    func detectQRCode(_ qrcodeImg: UIImage?) -> String? {
        let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let ciImage:CIImage=CIImage(image:qrcodeImg!)!
        var qrCodeLink=""

        let features=detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }

        if qrCodeLink=="" {
            print("nothing")
            return ""
        }else{
           
            print("message: \(qrCodeLink)")
            return qrCodeLink
        }
 
//        if let image = image, let ciImage = CIImage.init(image: image){
//            var options: [String: Any]
//            let context = CIContext()
//            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
//            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
//                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
//            } else {
//                options = [CIDetectorImageOrientation: 1]
//            }
//            let features = qrDetector?.features(in: ciImage, options: options)
//            return features
//
//        }
    }

    func openGallery(alert:UIAlertController){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
            guard let imageQr = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
           // pickImageCallback?(image)
        picker.dismiss(animated: true, completion: {
            if let features = self.detectQRCode(imageQr), !features.isEmpty{
            self.sendRequest_ForBooking_ChargerUsingGalleryImageOfQR(codeString: features)
    //            for case let row as CIQRCodeFeature in features{
    //                print(row.messageString ?? "nope")
    //                let strCode = row.messageString
    //
    //            }
            }else{
                self.displayAlert(alertMessage: "The image is not relevent please try another")
            }
        })
        
        }
    func sendRequest_ForBooking_ChargerUsingGalleryImageOfQR(codeString:String){
        if codeString.contains("-") && codeString.components(separatedBy: "-").count == 3 {
            let values = codeString.components(separatedBy: "-")
            if let stationId = values.first{
//                if  let location:ResultStation = self.stationLocation.filter({$0.stationID == Int(stationId)}).first{
                self.sendRequestForChargerByGallery(stationId: String(stationId), charger: values[1], port: values[2])
                 // }
               }
           }
        }
    func sendRequestForChargerByGallery(stationId:String,charger:String,port:String){
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.Chargerportbystation, requestFor: .CHARGER_PORT_BY_STATION, queryString: [stationId,charger,port], response:ChargerResponseByQR.self) {[weak self] respo in
            self?.hideLoader()
            if let res = respo,let success = res.success,let msg =  res.message, let resultCh = res.result,let result = resultCh.charger,let station = resultCh.station,let selectedCharger = result.first,let selectedStation = station.first, msg == "Ok" && success == true  {
               
                DispatchQueue.main.async {
                   // if let veh = Defaults.shared.addedVehicle.result,veh.count >= 1{
                        let homwSy = UIStoryboard(name: "Book", bundle: nil)
                        if let vc = homwSy.instantiateViewController(withIdentifier: "BookingStatusVC") as? BookingStatusVC{
                            var select = SelectedChargerAndPort(charger: nil, chargingpoint: nil,userEvId: nil,station: nil)
                            select.charger = selectedCharger
                            select.chargingpoint = Int(port)
                            select.stationByQr = selectedStation
                            vc.selectedStation = select
                            vc.resultCharger = selectedCharger
                            vc.bookingBy = .QrCode(true)
                            self?.show(vc, sender: self)
                           // self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    //}
                }
            }else{
                DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "Unable to proceed please try another")
                }
            }
        }
      }
    
//    func sendReqAddToFavorite(){
//        let req = ApiPostRequest()
//        req.kindOf(Theme.Station_Favorites, requestFor: .FAVORITE_STATIONS, request: Req(), response: FavoriteStations.self) {[weak self] (results) in
//            if let res = results,let success = res.success,let msg =  res.message, let resultFav = res.result, msg == "Ok" && success == true  {
//                 if  resultFav.contains(","){
//                     let favStnId = resultFav.components(separatedBy: ",")
//                 }else{
//                     let favStnId = resultFav
//                 }
//            }
//        }
//    }
    func sendReqAddToFavorite(stationId:String,stationName:String){
        let req = ApiPostRequest()
        self.showLoader()
        let appendStr = "addstationfavorites/\(stationId)"
        req.kindOf(appendStr, requestFor: .FAVORITE_STATIONS, request: Req(), response: FavoriteStations.self) {[weak self] (results) in
           
            if let res = results,let success = res.success,let msg =  res.message, let resultFav = res.result, msg == "Ok" && success == true  {
                 if  resultFav.contains(","){
                     let favStnId = resultFav.components(separatedBy: ",")
                     let intStnArray = favStnId.map { Int($0)!}
                     let favLoca = self?.stationLocation.filter({intStnArray.contains($0.stationID!)})
                     Defaults.shared.favoriteStation = favLoca ?? []
                 }else{
                     let favStnId = resultFav
                     let favLoca = self?.stationLocation.filter({$0.stationID == Int(favStnId)})
                     Defaults.shared.favoriteStation = favLoca ?? []
                 }
                self?.profileRequest(stationName: stationName)
            }else{
                self?.hideLoader()
                DispatchQueue.main.async {
                        self?.displayAlert(alertMessage: "There is some probelm to adding!!")
                }
            }
        }
    }
   
}

struct Req:Encodable{
    
}
