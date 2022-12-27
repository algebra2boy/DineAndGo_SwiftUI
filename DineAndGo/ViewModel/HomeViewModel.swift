//
//  HomeViewModel.swift
//  DineAndGo
//
//  Created by Yongye on 11/25/22.
//

import SwiftUI
import CoreLocation
import Firebase

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
    
    // ItemData
    @Published var items: [Item] = []
    
    
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
        
        // after extracting location loggining
        self.login()
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
    
    // anynomous login for reading database ...
    
    func login() {
        
        Auth.auth().signInAnonymously { (auth_data_result, error) in
            
            // if there is an error, then print out localized error description
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            // otherwise print out the user's id from the data result
            print("Success \(auth_data_result!.user.uid)")
            
            // After loggining to Firestore
            self.fetchData()
        }
    }
    
    // Fetching Items data from the firestore
    
    func fetchData() {
        
        let database = Firestore.firestore()
        
        database.collection("Items").getDocuments { (snapshot, error) in
            // making sure that snap is not nil
            guard let itemData = snapshot else {return}
            
            self.items = itemData.documents.compactMap({ (document) -> Item? in
                
                // all the item fields must be filled because I assume they not nil (indicated by the !)
                let id = document.documentID
                let name = document.get("item_name") as! String
                // must declare a number in Firestore, otherwise it would have a lot of error
                let cost = document.get("item_cost") as! NSNumber
                let ratings = document.get("item_ratings") as! String
                let image = document.get("item_image") as! String
                let details = document.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
                
            })
            
            
        }
        
    }
}

