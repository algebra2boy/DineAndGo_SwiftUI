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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        //Checking location assess...
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
        case .denied:
            print("denied")
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
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
