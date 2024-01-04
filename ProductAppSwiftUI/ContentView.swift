//
//  ContentView.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var vm: ProductVM
    @State private var isPresented: Bool = false
    
    private func populateProducts() async {
        do {
            try await vm.populateProducts()
        } catch {
            print(error)
        }
    }
    
    private func deleteProduct(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let products = vm.products[index]
            
            Task {
                do {
                    try await vm.deleteProduct(id: products.id, index: index)
                } catch {
                    print(error)
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if vm.products.isEmpty {
                    Text("No products available").accessibilityIdentifier("labelNoProducts")
                } else {
                    List {
                        ForEach(vm.products) { product in
                            NavigationLink(value: product.id) {
                                ProductCellView(product: product)
                            }
                        }.onDelete(perform: deleteProduct)
                    }.refreshable {
                        await populateProducts()
                    }
                }
            }.task {
                await populateProducts()
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Product") {
                        isPresented = true
                    }.accessibilityIdentifier("addProduct")
                }
            }.sheet(isPresented: $isPresented, content: {
                AddProductView()
            })
            .navigationDestination(for: String.self, destination: { id in
                ProductDetailView(id: id)
            })
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        var config = Configuration()
        let webservice = Webservices(baseUrl: config.environment.baseUrl)
        let vm = ProductVM(webservice: webservice)
        ContentView().environmentObject(vm)
    }
}
