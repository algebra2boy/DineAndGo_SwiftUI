//
//  CartView.swift
//  DineAndGo
//
//  Created by CHENGTAO on 12/27/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.dismiss) var present
    
    
    var body: some View {
        
        
        VStack{
            
            // "< back" and "My cart" title
            HStack(spacing: 20){
                
                Button(action: {present.callAsFunction()}) {
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(Color.pink)
                }
                
                Text("My cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
                
            }
            .padding()
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(spacing: 0){
                                        
                    // Cart ItemView...
                    ForEach(homeData.cartItems){cart in
                        
                        HStack(spacing: 15){
                    
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 10){

                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(cart.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                HStack(spacing: 15){
                                    
                                    //Need to optimize
                                    //Problem: do Float(truncating:..) twice at here and getPrice(value: ...) at HomeView
                                    Text(homeData.getPrice(value: Float(truncating: cart.item.item_cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {
                                        if cart.quantity > 1{
                                            homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                        }
                                    }) {
                                        
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal,  10)
                                        .background(Color.black.opacity(0.06))
                                    
                                    Button(action: {
                                       
                                        homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1
                                        
                                    }) {
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                        
                                        
                                    }
                                }
                            }
                        }
                        .padding()
                        .contextMenu{
                            
                            // deleting order...
                            Button(action: {
                                
                                // deleting items from cart
                                let indx = homeData.getIndex(item: cart.item, isCartIndex: true)
                                let itemIndx = homeData.getIndex(item: cart.item, isCartIndex: false)
                                
                                homeData.items[itemIndx].isAdded = false
                                homeData.filtered[itemIndx].isAdded = false
                                                                
                                homeData.cartItems.remove(at: indx)
                                
                            }) {
                                Text("Remove")
                                    .font(.title2)
                            }
                            
                        }
                    }
                }
            }
            
            
            // total and checkout
            VStack{
                HStack{
                    
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // calculating total price...
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top, .horizontal])
                
                Button(action: homeData.updateOrder) {
                    Text(homeData.isOrdered ? "Cancel Order" : "Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            (homeData.isOrdered ? (LinearGradient(gradient: .init(colors: [Color.pink, Color.red]), startPoint: .leading, endPoint: .trailing)) :
                                (LinearGradient(gradient: .init(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)))
                        )
                        .cornerRadius(15)
                }
                                
            }
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

