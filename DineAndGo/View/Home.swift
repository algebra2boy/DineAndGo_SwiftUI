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
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundColor(Color.pink)
                    })
                    
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
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $HomeModel.search) //'Binding<String>'
                    
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                // ?
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    VStack(spacing: 25){
                        
                        ForEach(HomeModel.filtered){item in
                            
                            // Item View...
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content:
                                    {

                                ItemView(item: item)
                                
                                HStack{
                                    
                                    Text("Free Delivery!")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 10)
                                        .background(.pink)
                                    
                                    Spacer()
                                    
                                    Button(action: {HomeModel.addToCart(item: item)}, label: {

                                        Image(systemName: item.isAdded ? "checkmark" : "plus")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(item.isAdded ? .green : .pink)
                                            .clipShape(Circle())

                                    })
                                    
                                }
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                                
                            })
                            .frame(width: UIScreen.main.bounds.width - 30)
                            
                        }
                    }
                })
            }
            
            //Side Menu...
            HStack{
                Menu(homeData: HomeModel)
                    // Move Effect from left...
                    .offset(x:HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                // clsing when Taps on outside...
                    .onTapGesture(perform: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    })
                )
            
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
        })
        .onChange(of: HomeModel.search, perform: {value in
            
            // to avoid Continues search reqests...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                if value == HomeModel.search && (HomeModel.search != "") {
                    
                    // Search data...
                    HomeModel.filterData()
                }
            }
            
            if HomeModel.search == ""{
                
                // reset all data...
                withAnimation(.linear){HomeModel.filtered = HomeModel.items}
            }
        })
        
        
    }
}

