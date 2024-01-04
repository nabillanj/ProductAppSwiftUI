//
//  Product.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import Foundation

struct Product: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var desc: String
    var price: String
}
