//
//  Cart.swift
//  DineAndGo
//
//  Created by CHENGTAO on 12/27/22.
//

import SwiftUI

struct Cart: Identifiable {
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}
