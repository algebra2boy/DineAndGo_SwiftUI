//
//  Home.swift
//  DineAndGo
//
//  Created by Yongye on 11/25/22.
//
import SwiftUI

struct Home: View {
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
       
        ZStack {
            VStack(spacing: 10){
                /// topmost section
                // create space size for each item
                HStack(spacing: 15){
                    // create a clickable button
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()
                        }},
                           label: {
                        // the Button has a label which is a 3 line image
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
                
                /// search bar section
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
                
                // displaying the scroll view for the food pictures
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    VStack(spacing: 25) {
                        
                        // accessing each item using for each loop
                        ForEach(HomeModel.items) { item in
                            
                            // Item View
                            // Adding another layer, which is for delivery status and plus sign, on top of the picture
                            
                            ZStack(alignment: Alignment(horizontal: .center,
                                                        vertical: .top), content: {
                                ItemView(item: item)
                                
                                HStack {
                                    
                                    // delivery status
                                    Text("Free Delivery")
                                        .foregroundColor(.white) // the text color
                                        .padding(.vertical, 10) // adding padding on top and bottom
                                        .padding(.horizontal)
                                        .background(Color.pink) // the container's background color
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {}, label: {
                                        
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.pink)
                                            .clipShape(Circle()) // set a clipped circle shape
                                    })
                                    
                                }
                                .padding(.trailing, 10)
                                .padding(.top, 10)
   
                            })
                        }
                    }.padding(.top, 10) // add a little bit of space betweeen pictures on top
                    
                })
                
            }
            
            // Side Menu
            HStack {
                Menu(homeData: HomeModel)
                    // move effect from left (this is where show we show the sidebar)
                    .offset(x: HomeModel.showMenu ? 0: -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            }
            // change the tranparency of the background after opening the sidebar
            .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0)
                .ignoresSafeArea()
                // closing when Taps on outside
                .onTapGesture(perform: {
                    withAnimation(.easeIn) {
                        // toggle flip the the bool value(from true to false or false to true)
                        HomeModel.showMenu.toggle()
                    }
                }))
            
            // Non closable Alert If permission denined
            // user must exit the app to grant us the permission
            
            if HomeModel.noLocation {
                Text("Please Enable Location Access In Settings to Further Move on!!")
                    // change the color of text
                    .foregroundColor(.red)
                    // make a small alert window
                    .frame(width: -UIScreen.main.bounds.width - 100, height: 100)
                    // make the pop up alert's background to white
                    .background(.white)
                    // add a bit of corner
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // make the screen background to have a lower transparency so it make the window feels like a pop up
                    .background(Color.black.opacity(0.5).ignoresSafeArea())
                    
                
            }
        }
        
        /// add an action to perform before this view happens
        .onAppear(perform: {
            // calling location delgate...
            HomeModel.locationManager.delegate = HomeModel
        }
        
        )
    }
}

