//
//  ProductAppSwiftUIApp.swift
//  ProductAppSwiftUI
//
//  Created by nabilla on 03/01/24.
//

import SwiftUI

@main
struct ProductAppSwiftUIApp: App {
    
    @StateObject private var vm: ProductVM
    
    init() {
        var config = Configuration()
        let webservice = Webservices(baseUrl: config.environment.baseUrl)
        _vm = StateObject(wrappedValue: ProductVM(webservice: webservice))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(vm)
        }
    }
}
