//
//  ProductDetailView.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 04/01/24.
//

import SwiftUI

struct ProductDetailView: View {
    
    let id: String
    
    @EnvironmentObject private var vm: ProductVM
    @State private var isPresented: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            if let product = vm.getProductDetail(id: id) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("productName")
                    let price = Double(product.price) ?? 0
                    Text(price as NSNumber, formatter: NumberFormatter.currency)
                        .accessibilityIdentifier("productPrice")
                    Text(product.desc)
                        .opacity(0.5)
                        .accessibilityIdentifier("productDesc")
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Delete Product", role: .destructive) {
                            Task {
                                await deleteProduct(id: product.id)
                            }
                        }.accessibilityIdentifier("btnDeleteProduct")
                        
                        Button("Edit Product") {
                            isPresented = true
                        }.accessibilityIdentifier("btnEditProduct")
                        Spacer()
                    }.sheet(isPresented: $isPresented) {
                        AddProductView(product: product)
                    }
                }
            }
        }.padding()
    }
    
    private func deleteProduct(id: String) async {
        do {
            try await vm.deleteProduct(id: id, index: nil)
            dismiss()
        } catch {
            print(error)
            dismiss()
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        var config = Configuration()
        let webservice = Webservices(baseUrl: config.environment.baseUrl)
        let vm = ProductVM(webservice: webservice)
        ProductDetailView(id: "5").environmentObject(vm)
    }
}
