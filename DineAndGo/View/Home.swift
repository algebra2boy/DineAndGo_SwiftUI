//
//  Home.swift
//  DineAndGo
//
//  Created by CHENGTAO on 11/25/22.
//
import SwiftUI

struct Home: View {
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        // vertical space size
        ZStack {
            
            // vertical space size
            VStack(spacing: 10){
                // hor space size for each item
                HStack(spacing: 15){
                    Button(action: {}, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(Color.pink)
                    }
                    )
                    
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver To")
                        .foregroundColor(.black)
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.pink)
                    // push HStack to left
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 15){
                    TextField("Search", text: $HomeModel.search) //'Binding<String>'
                    
                    if HomeModel.search != "" {
                        Button(action: {}, label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                        }).animation(.easeIn, value: 0)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                // ?
                Spacer()
            }
            
            if HomeModel.noLocation{
                Text("Please Enable Location Access In Setttings to Further Move On!!!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
            
        }
        .onAppear(perform: {
            HomeModel.loactionManager.delegate = HomeModel
            HomeModel.loactionManager.requestWhenInUseAuthorization()
        })
        
    }
}

