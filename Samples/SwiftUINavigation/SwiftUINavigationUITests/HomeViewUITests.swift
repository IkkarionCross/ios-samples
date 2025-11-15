//
//  SwiftUINavigationUITests.swift
//  SwiftUINavigationUITests
//
//  Created by victor amaro on 10/10/25.
//

import XCTest

final class HomeViewUITests: XCTestCase {

    @MainActor
    func testAddLink() throws {
        
        let app = XCUIApplication()
        app.launch()

        let textField = app.textFields["enter url"]
        textField.tap()
        textField.typeText("https://www.github.com")
        app.buttons["Add"].tap()
        
        let newEntry = app.collectionViews["list_link_view"].cells.element(boundBy: 0).staticTexts["https://www.github.com"]
        
        XCTAssertTrue(newEntry.waitForExistence(timeout: 5))
        
    }
    
    @MainActor
    func testAddLink_IndalidURL() throws {
        
        let app = XCUIApplication()
        app.launch()

        let textField = app.textFields["enter url"]
        textField.tap()
        textField.typeText("hts://www.github.com")
        app.buttons["Add"].tap()
        
        let buttonTryAgain = app.buttons["Try Again"]
        
        XCTAssertTrue(buttonTryAgain.waitForExistence(timeout: 1))
        
        buttonTryAgain.tap()
        
        let collectionView = app.collectionViews["list_link_view"]
        
        XCTAssertTrue(collectionView.waitForExistence(timeout: 1))
        
    }

}
