//
//  AddProductView.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import SwiftUI

struct AddProductErrors {
    var name: String = ""
    var price: String = ""
}

struct AddProductView: View {
    
    @State private var price: String = ""
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var errors: AddProductErrors = AddProductErrors()
    
    @EnvironmentObject private var vm: ProductVM
    @Environment(\.dismiss) private var dismiss
    
    var product: Product?

    var isValid: Bool {
        errors = AddProductErrors()
        
        if name.isEmpty {
            errors.name = "Name can't be empty"
        }
        
        if price.isEmpty {
            errors.price = "Price can't be empty"
        } else if !price.isNumeric {
            errors.price = "Price needs to be number"
        } else if price.isLessThan(1) {
            errors.price = "Price needs to more than 0"
        }
        
        return errors.name.isEmpty && errors.price.isEmpty
    }
    
    private func addProduct() async {
        do {
            let product = Product(id: UUID().uuidString, name: name, desc: desc, price: price)
            try await vm.addProducts(product)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func updateProduct() async {
        do {
            let product = Product(id: product!.id, name: name, desc: desc, price: price)
            try await vm.updateProduct(product)
            dismiss()
        } catch {
            print(error)
            dismiss()
        }
    }
    
    private func fillProductData() {
        if let product = product {
            price = product.price
            name = product.name
            desc = product.desc
        }
    }
    
    private func saveOrUpdateProduct() async {
        if product != nil {
            await updateProduct()
        } else {
            await addProduct()
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name).accessibilityIdentifier("productName")
                Text(errors.name).font(.caption).visible(!errors.name.isEmpty).accessibilityIdentifier("errorName")
                
                TextField("Price", text: $price).accessibilityIdentifier("productPrice")
                Text(errors.price).font(.caption).visible(!errors.price.isEmpty).accessibilityIdentifier("errorPrice")

                TextField("Desc", text: $desc, axis: .vertical).accessibilityIdentifier("productDesc")
                
                Button(product != nil ? "Update Product" : "Add Product") {
                    if isValid {
                        Task {
                            await saveOrUpdateProduct()
                        }
                    }
                }.accessibilityIdentifier("addProduct")
                    .centerHorizontal()

            }.navigationTitle(product != nil ? "Update Product" : "Add Product")
                .onAppear {
                    fillProductData()
                }
            
        }
    }
}

struct AddProductView_Preview: PreviewProvider {
    static var previews: some View {
        var config = Configuration()
        let webservice = Webservices(baseUrl: config.environment.baseUrl)
        let vm = ProductVM(webservice: webservice)
        AddProductView().environmentObject(vm)
    }
}
