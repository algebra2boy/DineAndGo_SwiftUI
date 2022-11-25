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
        
        VStack(spacing: 10){
            // hor space size for each item
            HStack(spacing: 15){
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                        .foregroundColor(Color.pink)
                }
                )
                
                Text("Deliver To")
                    .foregroundColor(.black)
                
                Text("Apple")
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
    }
}

