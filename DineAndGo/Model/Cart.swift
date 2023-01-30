//
//  Cart.swift
//  DineAndGo
//
//  Created by Yongye Tan on 1/29/23.
//

import SwiftUI

struct Cart: Identifiable {
    
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
