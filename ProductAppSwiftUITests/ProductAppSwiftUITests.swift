//
//  ProductAppSwiftUITests.swift
//  ProductAppSwiftUITests
//
//  Created by nabilla on 03/01/24.
//

import XCTest

final class ProductAppSwiftUITests: XCTestCase {

    func testShouldShowEmptyProductMessage() throws {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "Test"]
        app.launch()
        
        XCTAssertEqual("No products available", app.staticTexts["labelNoProducts"].label)
    }
}
