//
//  NumberFormatter+Extensions.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
