//
//  HomeViewModel.swift
//  DineAndGo
//
//  Created by CHENGTAO on 11/25/22.
//

import SwiftUI
import CoreLocation
import Firebase
import FirebaseAuth

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var loactionManager = CLLocationManager()
    @Published var search = ""
    
    // location details...
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    //Menu...
    @Published var showMenu = false
    
    //ItemData
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    // Cart items...
    @Published var cartItems: [Cart] = []
    
    @Published var isOrdered = false
    
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
        
        // after extracting location looging ing.....
        self.login()
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
    
    // anynomus login for reading batabase...
    func login(){
        Auth.auth().signInAnonymously { (res, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            print("Success = uid: \(res!.user.uid))")
            
            // After Logging in Fetching Data...
            self.fetchData()
        }
    }
    
    // Fetching Items Data...
    func fetchData(){
        let db = Firestore.firestore()
        
        db.collection("Items").getDocuments { (snap, err) in
            
            guard let itemData = snap else{return}
            self.items = itemData.documents.compactMap({ (doc) -> Item? in
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let details = doc.get("item_details") as! String
                let image = doc.get("item_image") as! String
                let ratings = doc.get("item_ratings") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
                
            })
            
            self.filtered = self.items
        }
    }
    
    func filterData(){
        
        withAnimation(.linear) {
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
        
    
    func addToCart(item: Item) {
        
        // checking it is added...
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        // updating filtered arry also for search bar result...
        let filterIndx = self.filtered.firstIndex{ (item1)->Bool in
            return item.id == item1.id
        } ?? 0
        
        self.filtered[filterIndx].isAdded = !item.isAdded
        
        if item.isAdded{
            
            // remove from the list...
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            
            return
            
        } else {
            // else adding
            
            self.cartItems.append(Cart(item: item, quantity: 1))
        }
        
    }
    
    // writing user's oder data to firebase...
    func updateOrder(){
        
        // connect to firestore
        let db = Firestore.firestore()
        
        // creating dict of food detail...
                
        if isOrdered{
            
            // for cancel order
            isOrdered = false
            
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete{ (err) in
                
                if err != nil{
                    self.isOrdered = true
                }
                
            }
            return
        }
        
        var details : [[String: Any]] = []
        
        cartItems.forEach { (cart) in
            
            details.append([
                
                "item_name": cart.item.item_name,
                "item_quantity": cart.quantity,
                "item_cost": cart.item.item_cost
                
            ])
        }
        
        isOrdered = true
                
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            
            "ordered_food": details,
            "total_cost": calculateTotalPrice(),
            "ordered_location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
        ]) { (err) in
            
            if err != nil {
                self.isOrdered = false
                return
            }
            
            print("Success")
            
        }
        print(isOrdered)
    }
    
    
    func getIndex(item:  Item, isCartIndex: Bool)->Int{
        
        let index = self.items.firstIndex { (item1) -> Bool in
            
            return item.id == item1.id
            
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { (item1) -> Bool in
            return item.id == item1.item.id
            
        } ?? 0
        
        return isCartIndex ? cartIndex : index
      
    }
    
    func calculateTotalPrice()->String{
        
        var price : Float = 0
        
        cartItems.forEach{ (item) in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        
        return getPrice(value: price)
    }
    
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
        
    }
    
}

