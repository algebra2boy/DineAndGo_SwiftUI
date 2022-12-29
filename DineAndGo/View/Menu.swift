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
                    
                    Spacer(minLength: 0) // push all the way to left
                }.padding()
                
            })
            
            Spacer() // push all the way to buttom
            
            HStack {
                
                Spacer() // push to right
                
                Text("Version 0.1")
                    .fontWeight(.bold)
                    .foregroundColor(Color.pink)
            }.padding(10) // 10 pixel away from the sidebar
            
        }
        // width: UIScreen.main.bounds.width / 2 is half of the width of the phone sccreen
        .frame(width: UIScreen.main.bounds.width / 1.6) // important to set up the sidebar view
        .background(Color.white)
    }
}

