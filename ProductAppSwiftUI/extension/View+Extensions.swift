//
//  View+Extensions.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import SwiftUI

extension View {
    func centerHorizontal() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    @ViewBuilder
    func visible(_ visible: Bool) -> some View {
        if visible {
            self
        } else {
            EmptyView()
        }
    }
}
