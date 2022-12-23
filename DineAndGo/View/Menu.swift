//
//  Menu.swift
//  DineAndGo
//
//  Created by Yongye Tan on 12/23/22.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    var body: some View {
        VStack {
            Button(action: {}, label: {
                HStack(spacing: 10) {
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(Color.pink)
                    
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }.padding()
                
            })
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Text("Version 0.1")
                    .fontWeight(.bold)
                    .foregroundColor(Color.pink)
            }.padding(10) // 10 pixel away from the sidebar
            
        }
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white)
    }
}

