//
//  DineAndGoApp.swift
//  DineAndGo
//
//  Created by Yongye Tan on 11/25/22.
//

import SwiftUI
import Firebase

@main
struct DineAndGoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Intitalizing Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
    
}
