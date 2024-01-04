//
//  ProductCellView.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.name).accessibilityIdentifier("productTitle").bold()
            let price = Double(product.price) ?? 0
            Text(price as NSNumber, formatter: NumberFormatter.currency).accessibilityIdentifier("productPrice")
            Text(product.desc).accessibilityIdentifier("productDesc").opacity(0.5)
        }
    }
}
