//
//  HomeViewModel.swift
//  DineAndGo
//
//  Created by CHENGTAO on 11/25/22.
//

import SwiftUI
import CoreLocation

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var loactionManager = CLLocationManager()
    @Published var search = ""
    
    // location details...
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    //Menu...
    @Published var showMenu = false
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        //Checking location assess...
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            //Direct call
            loactionManager.requestWhenInUseAuthorization()
            // Modifying Info.plist...
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // reading User Location and Extracting details...
        self.userLocation = locations.last
        self.extractLocation()
    }
    
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) {(res, err) in
            guard let safeData = res else{return}
            
            var address = ""
            
            address += safeData.first?.name ?? ""
            address += ","
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
        }
    }
}

//struct HomeViewModel: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}
//
//struct HomeViewModel_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeViewModel()
//    }
//}
