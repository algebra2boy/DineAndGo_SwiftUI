//
//  Item.swift
//  DineAndGo
//
//  Created by Yongye Tan on 12/27/22.
//

import Foundation

import SwiftUI

// Identifiable is a class of type whose instances hold the value of an entity with stable identity
struct Item: Identifiable {
    
    var id : String
    var item_name : String
    var item_cost : NSNumber
    var item_details : String
    var item_image : String
    var item_ratings : String
    
}
