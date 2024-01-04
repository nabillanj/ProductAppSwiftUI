//
//  Webservices.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case badUrl
}

class Webservices {
    
    private var baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func getProducts() async throws -> [Product] {
        guard let url = URL(string: Endpoints.products.path, relativeTo: baseUrl) else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let products = try await generateResponse(data, response) as [Product]
        
        return products
    }
    
    func addProduct(product: Product) async throws -> Product {
        guard let url = URL(string: Endpoints.addProducts.path, relativeTo: baseUrl) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(product)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let product = try await generateResponse(data, response) as [Product]
        
        return product.first!
    }
    
    func deleteProduct(id: Int) async throws -> Product  {
        guard let url = URL(string: Endpoints.deleteProduct(id: id).path, relativeTo: baseUrl) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let product = try await generateResponse(data, response) as [Product]
        
        return product.first!
    }
    
    func updateProduct(product: Product) async throws -> Product  {
        guard let url = URL(string: Endpoints.updateProduct(id: Int(product.id) ?? 0).path, relativeTo: baseUrl) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(product)

        let (data, response) = try await URLSession.shared.data(for: request)
        let product = try await generateResponse(data, response) as [Product]
        
        return product.first!
    }
    
    private func generateResponse<T: Codable>(_ data: Data, _ response: URLResponse) async throws -> T {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let model = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return model
    }
}
