//
//  HomeViewModel.swift
//  DineAndGo
//
//  Created by CHENGTAO on 11/25/22.
//

import SwiftUI
import CoreLocation

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var search = ""
    
    // the object to manipulate location
    @Published var locationManager = CLLocationManager()
    
    // location details
    @Published var userLocation : CLLocation!
    @Published var userAddress : String = ""
    @Published var noLocation : Bool = false
    
    // Menu
    @Published var showMenu : Bool = false
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // checking Location Acess...
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            manager.requestLocation() // request the one time delivery of the user's location
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            // Direct call
            locationManager.requestWhenInUseAuthorization() // request user's permission to use the location service
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // retrieve localized description of this error
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // reading user's last location and extracting details from that location
        self.userLocation = locations.last
        self.extractLocation()
    }
    
    func extractLocation() {
        
        CLGeocoder().reverseGeocodeLocation(self.userLocation) {
            (response, error) in
            // data might be missing
            guard let safeData = response
            else {return}
            
            var address = ""
            
            // .first is the first element of the collection
            // .name is the name of the landmark
            // .locality is the city associated with the landmark
            address += safeData.first?.name ?? ""
            address += ","
            address += safeData.first?.locality ?? ""
            
            // update the address in the field
            self.userAddress = address
            
        }
        
        
        
    }
}

