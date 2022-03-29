//
//  SearchedPlaces.swift
//  ChargePark
//
//  Created by apple on 24/11/21.
//

import Foundation
import UIKit
import GooglePlaces
import CoreLocation

struct Place {
    let name:String
    let identifier:String
}
final class GooglePlaceManager{
   static let shared = GooglePlaceManager()
    private let client = GMSPlacesClient.shared()
    private init(){}
    enum PalceError:Error{
        case failedToFind
        case failedToGetCordinate
    }
    
   public func findPlaces(query:String,completion:@escaping(Result<[Place],Error>) -> () ) {
      let filter = GMSAutocompleteFilter()
       filter.type = .establishment
       if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
           print(countryCode)
           filter.country = countryCode
       }
      
       // filter.type = .geocode
       client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { resultPlace, error in
//       let cor = CLLocationCoordinate2D(latitude: 20.5937,longitude: 78.9629)
//       let bounds = GMSCoordinateBounds(coordinate: cor, coordinate: cor)
//       client.autocompleteQuery(query, bounds: bounds, filter: filter) {
//           resultPlace, error in
           guard let results = resultPlace,error == nil else {
               completion(.failure(PalceError.failedToFind))
               return
           }
           let place:[Place] = results.compactMap({ Place(name: $0.attributedFullText.string, identifier: $0.placeID)
           })
           completion(.success(place))
       }
        
    }
    public func resolveLocation(for place:Place,completion:@escaping(Result<CLLocationCoordinate2D,Error>) -> () ) {
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace,error == nil else{
                completion(.failure(PalceError.failedToGetCordinate))
                return
            }
            let coordinates = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(coordinates))
        }
    }
}
