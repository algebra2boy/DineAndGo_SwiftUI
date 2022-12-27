//
//  ItemView.swift
//  DineAndGo
//
//  Created by Yongye Tan on 12/27/22.
//

import SwiftUI
import SDWebImageSwiftUI


// This is where we create the view for each picture
struct ItemView: View {
    
    var item: Item
    var body: some View {
        
        VStack {
            
            // Downloading Image from the web using the URL
            
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill) // occupied all the available space
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
            
            
            /// display the item name and star rating
            HStack (spacing: 8) {
                
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                // Rating View (make the star yellow if there is rating)
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_ratings) ?? 0
                                         ? Color.yellow : .gray)
                    
                }
                
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            
            /// display the item details
            HStack {
                
                Text(item.item_details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2) // maximum line that can be allowed in this view
                
                Spacer(minLength: 0)
            }.padding(.horizontal, 15)
            
            
        }
        
    }
}
