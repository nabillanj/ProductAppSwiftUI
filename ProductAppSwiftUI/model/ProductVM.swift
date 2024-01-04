//
//  ProductVM.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import Foundation

enum ProductError: Error {
    case invalidProductId
}

@MainActor
class ProductVM: ObservableObject {
    
    let webservice: Webservices
    @Published private(set) var products: [Product] = []
    
    init(webservice: Webservices) {
        self.webservice = webservice
    }
    
    func populateProducts() async throws {
        products = try await webservice.getProducts()
    }
    
    func addProducts(_ product: Product) async throws {
        let product = try await webservice.addProduct(product: product)
        products.append(product)
    }
    
    func deleteProduct(id: String, index: Int?) async throws {
        _ = try await webservice.deleteProduct(id: Int(id) ?? 0)
        if let index = index {
            products.remove(at: index)
        }
    }
    
    func updateProduct(_ product: Product) async throws {
        let product = try await webservice.updateProduct(product: product)
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { throw ProductError.invalidProductId }
        products[index] = product
    }
    
    func getProductDetail(id: String) -> Product? {
        guard let product = products.first(where: { $0.id == id }) else { return nil }
        return product
    }
}
