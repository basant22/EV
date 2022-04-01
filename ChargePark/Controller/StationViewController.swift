//
//  StationViewController.swift
//  Radiush
//
//  Created by Hemant Singh on 05/01/20.
//  Copyright © 2020 Kreative. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class StationViewController: UIViewController{
    
    
@IBOutlet weak var menuButton: UIBarButtonItem!
@IBOutlet weak var searchButton: UIBarButtonItem!
@IBOutlet weak var titleBar: UIBarButtonItem!
@IBOutlet weak var viewQrCode: UIView!
@IBOutlet weak var viewFav: UIView!
@IBOutlet weak var qrCode: UIButton!
@IBOutlet weak var btnFavStn: UIButton!
@IBOutlet weak var navigationCon: UINavigationBar!
@IBOutlet weak var mapView: GMSMapView!
@IBOutlet  var searchController: UISearchController?
   // var resultsViewController: GMSAutocompleteResultsViewController?
   
    var favLoc:[ResultStation] = []
    var userType:UserType = .logedIn
    var picker = UIImagePickerController()
    var stationLocation:[ResultStation]!
  
    var dictLatlong : [String:String] = [:]
    var dict : [String:Double] = [:]
    var isAlraedyGetLocation = false
   // var currentLocation:(Double,Double)!
    var locationManager = CLLocationManager()
    var chargers:[ResultCharger] = []
    var loader:NewLoader!
   // let searchVC = UISearchController(searchResultsController: ResultVC())
    override func viewDidLoad() {
        super.viewDidLoad()
       // isAlraedyGetLocation = false
        //viewQrCode.isHidden = true
        //qrCode.isHidden = true
    
       // searchVC.searchBar.barTintColor = Theme.menuHeaderColor
       // searchVC.searchResultsUpdater = self
      //  navigationCon.topItem?.searchController = searchVC
        
       // navigationItem.searchController = searchVC
       /*
       
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
      
        searchController?.searchResultsUpdater = resultsViewController
        definesPresentationContext = true
        */
        if Theme.appName == "VRAJEV Charge"{
            self.titleBar.title = "Nearby Stations"
        }
        if Theme.appName == "EV Plugin Charge"{
            self.titleBar.title = "Power Source"
        }
        searchButton.isEnabled = true
        searchButton.action = #selector(autocompleteClicked(_:))
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        self.navigationCon.barTintColor = Theme.menuHeaderColor
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        mapView.delegate = self
        picker.delegate = self
       // qrCode.setImage(UIImage(systemName: ""), for: .normal)
       viewQrCode.cornerRadius(with: 14.0)
        viewQrCode.layer.borderWidth = 1.0
        viewQrCode.layer.borderColor = UIColor.white.cgColor
        viewQrCode.backgroundColor = Theme.menuHeaderColor.withAlphaComponent(0.55)
        viewFav.backgroundColor = Theme.menuHeaderColor.withAlphaComponent(0.55)
        viewFav.cornerRadius(with: 10.0)
        let imgFav = UIImage(systemName: "suit.heart")?.tint(with: .white)
        btnFavStn.setTitle("", for: .normal)
        btnFavStn.setImage(imgFav, for: .normal)
//        viewQrCode.backgroundColor = Theme.menuHeaderColor
       // qrCode.setImage(UIImage(named: "QRCode")?.tint(with: .white), for: .normal)
        qrCode.setTitle("", for: .normal)
        let img = UIImage(named: "QRCode")
        qrCode.setImage(img?.tint(with: .white), for: .normal)
      //  self.loader = NewLoader()
        mapView.animate(toZoom: 9.0)
        if Defaults.shared.favoriteStation.count > 0 {
            viewFav.isHidden = false
        }else{ viewFav.isHidden = true}
        aboutLocation()
    }
    @objc func autocompleteClicked(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                    UInt(GMSPlaceField.placeID.rawValue) |
                    UInt(GMSPlaceField.coordinate.rawValue) |
                    GMSPlaceField.addressComponents.rawValue |
                                                  GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
 
        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//                                                  UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
      }
    
     fileprivate func aboutLocation(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 1000
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // print("rzrpayKeyid=\(Defaults.shared.appConfig?.rzrpayKeyid)")
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.stopUpdatingLocation()
        }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    func updateUserLocation(){
        self.isAlraedyGetLocation = false
       
        self.locationManager.startUpdatingLocation()
    }
    func sendReqForStationNearLocation(latLong:[String:String]){
        var strStr = [""]
        strStr.append(latLong["lat"]!)
        strStr.append(latLong["long"]!)
        self.showLoader()
        ApiGetRequest().kindOf(Theme.NearByStation, requestFor: .NEARBY_STATIONS, queryString: strStr, response: StationResponse.self) {[weak self] (response) in
            // print("stationsnearlocation=\(String(describing: response))")
             if let res = response,let _ = res.success,let msg =  res.message{
                 if let locations =  res.result,msg  == "Ok"{
                    // self.addAnnotationOnMap(locations:location)
                     DispatchQueue.main.async {
                         if locations.count > 0{
                             self?.stationLocation = locations
                     self?.showMarker(location: locations,userLocation: (latLong["lat"],latLong["long"]))
                         }else{
                             self?.hideLoader()
                             self?.showOnlyUserLocation(userLocation: (latLong["lat"],latLong["long"]))
                         }
                     }
                 }
             }else{
                 self?.hideLoader()
             }
         }
    }
    
    func sendRequestForChargerStation(latLong:[String:String]){
         
         let stationResources = StationResource()
        //self.showNewLoader(loader: self.loader)
        self.showLoader()
        stationResources.getStationNearMyLocation(latLong, connector:Theme.NearByStation) {[weak self] (response) in
           // print("stationsnearlocation=\(String(describing: response))")
            if let res = response,let _ = res.success,let msg =  res.message{
                if let locations =  res.result,msg  == "Ok"{
                   // self.addAnnotationOnMap(locations:location)
                    DispatchQueue.main.async {
                        if locations.count > 0{
                            self?.stationLocation = locations
                    self?.showMarker(location: locations,userLocation: (latLong["lat"],latLong["long"]))
                        }else{
                            self?.hideLoader()
                            self?.showOnlyUserLocation(userLocation: (latLong["lat"],latLong["long"]))
                        }
                    }
                }
            }else{
                self?.hideLoader()
            }
        }
    }
    func profileRequest(stationName:String){
       // self.group.enter()
        let userName = Defaults.shared.userLogin?.username ?? ""
        let profileResource = ApiGetRequest()
        profileResource.kindOf(Theme.ShowProfile, requestFor: .PROFILE, queryString: [userName], response: Profile.self) {[weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ =  res.success,let msg =  res.message, msg == "Ok" {
                if let profile = res.result{
                   // print("profile get successfully")
                    Defaults.shared.usrProfile = profile
                    Utils.saveProfileInfoInUserDefaults(data: profile)
                    DispatchQueue.main.async {
                        self?.viewFav.isHidden = false
                        self?.btnFavStn .isHidden = false
                    self?.displayAlert(alertMessage: "\(stationName) added to favorite station")
                    }
                }
            }
        }
    }
    func sendRequestForChargerByStation(stationId:Int,location:ResultStation){
        let req = ApiGetRequest()
        self.showLoader()
        req.kindOf(Theme.ChargerAtStation, requestFor: .CHARGER_STATUS_AT_STATIONS, queryString: [String(stationId)], response: ChargerResponse.self) { [weak self] respons in
            self?.hideLoader()
            if let res = respons,let _ = res.success,let msg =  res.message, let result = res.result, msg == "Ok" && result.count > 0{
                self?.chargers = result
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "Details", sender:location )
                }
            }else{
                DispatchQueue.main.async {
                    self?.displayAlert(alertMessage: "No Charger found at this station")
                }
            }
        }
    }
    func showOnlyUserLocation(userLocation:(String?,String?)){
        if let latV = userLocation.0,let lat = Double(latV),let longV = userLocation.1,let long = Double(longV){
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: long, zoom: 6.0,bearing: 0,
                                                      viewingAngle: 0)
         mapView.camera = camera
        }
    }
    func showMarker(location:[ResultStation],userLocation:(String?,String?)){
        if let latV = userLocation.0,let lat = Double(latV),let longV = userLocation.1,let long = Double(longV){
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: long, zoom: 10.0,bearing: 0,
                                                      viewingAngle: 0)
         mapView.camera = camera
         for pos in location{
            let marker = GMSMarker()
             
             if let lat = pos.lattitude,let long = pos.longitude,let stId = pos.stationID{
                 marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                 marker.title =  String(stId)
                 marker.icon = GMSMarker.markerImage(with: Theme.menuHeaderColor)
                 marker.map = mapView
             }
             filterFavoriteStation(location: location)
            //let distatance = self.calculateDistance(from: currentLocation, to: (pos.lattitude,pos.longitude))
//            marker.title = pos.stationname + "|\(distatance)"
//            marker.snippet = pos.contact
            
           
           
           // mapView.selectedMarker = marker
            
        }
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
           // self.hideNewLoader(loader: self.loader)
            self.hideLoader()
           // self.viewQrCode.isHidden = false
           // self.qrCode.isHidden = false
        }
        }
    }
    func filterFavoriteStation(location:[ResultStation]){
      
        if let prfpvtstn = Defaults.shared.usrProfile?.preferredPvtStation{
            Defaults.shared.usrProfile?.preferredStations?.append( "," + prfpvtstn)
        }
        if let preferredStations = Defaults.shared.usrProfile?.preferredStations{
        if preferredStations.contains(",") {
            let stn = preferredStations.components(separatedBy: ",")
            let intStnArray = stn.map { Int($0) ?? 0}
            favLoc =  location.filter({intStnArray.contains($0.stationID!)})
        }else{
            favLoc =  location.filter({$0.stationID == Int(preferredStations)})
        }
        }
        if favLoc.count > 0{
            self.btnFavStn.isHidden = false
            viewFav.isHidden = false
        }else{
            viewFav.isHidden = true
            self.btnFavStn.isHidden = true
        }
        Defaults.shared.favoriteStation = favLoc
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Details" {
            if let vc = segue.destination as? StationDetailViewController,let detail = sender as? ResultStation{
                // vc.stationDetail = ResultStation.init()
                vc.chargers =  self.chargers
                vc.stationDetail = detail
                vc.dictUserLatLong = self.dict
                vc.bookingBy = .General(true)
                //print("\(vc.stationDetail?.stationname)")
            }
        }else if segue.identifier == "QrCode"{
            if let vc = segue.destination as? QRCodeVC{
                //vc.resultCharger =  self.chargers
                vc.stations = self.stationLocation
            }
        }else if segue.identifier == "AddToFav"{
            if let vc = segue.destination as? AddToFavoriteVC,let location = sender as? ResultStation,let id = location.stationID{
                vc.dataSource = location
               
                vc.stationLocation = self.stationLocation
                let stnId = id
                vc.proceedToCharger = {[weak self] controler in
                    controler.dismiss(animated: true) {
                        self?.sendRequestForChargerByStation(stationId: stnId,location: location)
                    }
                }
                vc.addToFavourite = {[weak self] controler in
                    controler.dismiss(animated: true) {
                        if let preferredStations = Defaults.shared.usrProfile?.preferredStations {
                            if !preferredStations.contains(String(stnId)){
                                if let id = location.stationID,let name = location.stationname {
                                    self?.sendReqAddToFavorite(stationId: String(id),stationName: name)
                                }
                            }else{
                                if let stN = location.stationname{
                                    self?.displayAlert(alertMessage: "\(stN) is already added to favourites")
                                }
                            }
                        }else{
                            if let id = location.stationID,let name = location.stationname {
                                self?.sendReqAddToFavorite(stationId: String(id),stationName: name)
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func btnFavStn(_sender:UIButton){
        let homwSy = UIStoryboard(name: "Home", bundle: nil)
        if let vc = homwSy.instantiateViewController(withIdentifier: "FavoriteStationVC") as? FavoriteStationVC{
           // vc.dataSource =
            vc.reachedFrom = .Map
            vc.proceedToNext = { con,chargers,result in
                self.chargers = chargers
                if chargers.count > 0 {
                    DispatchQueue.main.async {
                        con.dismiss(animated: true) {
                            self.performSegue(withIdentifier: "Details", sender: result)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.displayAlert(alertMessage: "No Chargers found at this Station")
                    }
                }
            }
        self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func showQrCodeScanner(){

        if Defaults.shared.userType == .guest{
            let homwSy = UIStoryboard(name: "Registration", bundle: nil)
           // let front = homwSy.instantiateViewController(withIdentifier: "StationNavigation") as? UINavigationController
            if let vc = homwSy.instantiateViewController(withIdentifier: "UIViewController-zo5-yl-cbX") as? RegistrationVC{
            self.navigationController?.pushViewController(vc, animated: true)
            }
           // self.performSegue(withIdentifier: "Registration", sender: nil)
        }else{
        self.showAlert(marker: nil)
        }
    }
    func calculateDistance(from:(Double,Double),to:(Double,Double))-> String  {
        let coordinate0 = CLLocation(latitude: from.0, longitude: from.1)
        let coordinate1 = CLLocation(latitude: to.0, longitude: to.1)
        let distanceInMeter = coordinate0.distance(from: coordinate1)
        let distanceInKm = distanceInMeter/1000
        let distanceIn = String(format: "%.2f", distanceInKm)
        let totalDistance = String(distanceIn) + "Km"
       // let totalDistance = String(distanceInKm) + "Km"
       // print("distance = \(TotalDistance)")
        
        return totalDistance
    }
    deinit {
        print("\(self) id deinitialized")
    }
}

extension StationViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.isAlraedyGetLocation {
            return
        }
        guard let userLocation = locations.last else {return}
       
      //  currentLocation = (userLocation!.coordinate.latitude,userLocation!.coordinate.longitude)
        var dict : [String:String] = [:]
        dict["lat"] = String(userLocation.coordinate.latitude)
        dict["long"] = String(userLocation.coordinate.longitude)
        self.dict["lat"] = userLocation.coordinate.latitude
        self.dict["long"] = userLocation.coordinate.longitude
        self.dictLatlong = dict
        Defaults.shared.userLocation =  self.dict
        //uncomment to show self location
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.locationManager.stopUpdatingLocation()
        self.isAlraedyGetLocation = true
        //mapView.camera = camera
        self.sendRequestForChargerStation(latLong: self.dictLatlong)
        //self.sendReqForStationNearLocation(latLong: self.dictLatlong)
    }
}

extension StationViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

       // mapView.selectedMarker = marker
       // self.showAlert(marker: marker)
        if let stationId = marker.title {
            let location:[ResultStation] = self.stationLocation.filter({$0.stationID == Int(stationId)})
            if let location = location.first,let stId = location.stationID {
                if let useName = Defaults.shared.userLogin?.name,useName.count > 0{
                    if Theme.appName == "V-Power" || Theme.appName == "VRAJEV Charge"{
                        self.showLoader()
                         self.sendRequestForChargerByStation(stationId: stId,location: location)
                    }else{
                     self.performSegue(withIdentifier: "AddToFav", sender: location)
                    }
                }else{
                    let homwSy = UIStoryboard(name: "Registration", bundle: nil)
                    if let vc = homwSy.instantiateViewController(withIdentifier: "UIViewController-zo5-yl-cbX") as? RegistrationVC{
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
               // self.showLoader()
               // self.sendRequestForChargerByStation(stationId: stId,location: location)
            }
        }
        
       return true
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Click")
       //
    }
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("Long press")
    }
    
    // for showing infowindow of marker
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        let title:String = marker.title?.components(separatedBy: "|").first ?? ""
//        let distance:String = marker.title?.components(separatedBy: "|").last ?? "km"
//
//        return Marker.infoWindow(stationName: title, Address:marker.snippet ?? "" , distance: distance);
//    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       // mapView.selectedMarker = myGMSMarker
    }
}

extension StationViewController:GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
      func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
 
//          print("Place latitude: \(place.coordinate.latitude)")
//          print("Place longitude: \(place.coordinate.longitude)")
//        print("Place name: \(place.name)")
//        print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: {
            var dict : [String:String] = [:]
            dict["lat"] = String(place.coordinate.latitude)
            dict["long"] = String(place.coordinate.longitude)
            self.dictLatlong = dict
            self.sendRequestForChargerStation(latLong: self.dictLatlong)
            //self.sendReqForStationNearLocation(latLong: self.dictLatlong)
        })
      }

      func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
      }

      // User canceled the operation.
      func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
      }

      // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    
    
}

