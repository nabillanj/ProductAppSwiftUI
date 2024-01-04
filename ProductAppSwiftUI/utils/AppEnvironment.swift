//
//  AppEnvironment.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import Foundation

enum Endpoints {
    case products
    case addProducts
    case deleteProduct(id: Int)
    case updateProduct(id: Int)
    
    var path: String {
        switch self {
        case .products, .addProducts:
            return "product"
        case .deleteProduct(let id), .updateProduct(let id):
            return "product/\(id)"
        }
    }
}

struct Configuration {
    lazy var environment: AppEnvironment = {
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return .dev
        }
        
        if env.lowercased() == "test" {
            return .test
        }
        
        return .dev
    }()
}

enum AppEnvironment: String {
    case dev
    case test
    
    var baseUrl: URL {
        return URL(string: "https://5fda73f96cf2e7001737f5e4.mockapi.io/test/")!
    }
}
