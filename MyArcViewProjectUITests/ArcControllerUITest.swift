//
//  ArcControllerUITest.swift
//  MyArcViewProjectUITests
//
//  Created by Rey Cerio on 2021-11-21.
//

import XCTest
@testable import MyArcViewProject

class ArcControllerUITest: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBackgroundColorViewExist() {
        let backgroundColorView = XCUIApplication().otherElements["backgroundColorView"]
        XCTAssertNotNil(backgroundColorView)
    }

    func testCollectionViewExist() {
        let collectionView = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView)
        XCTAssertTrue(collectionView.element.exists)
    }
    
    func testCollectionViewVisibleCellsExists() {
        let collectionView = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView)
        XCTAssertEqual(collectionView.cells.count, 5)
        
        let collectionViewsQuery = XCUIApplication()/*@START_MENU_TOKEN@*/.collectionViews/*[[".otherElements[\"backgroundColorView\"].collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let farLeftCellColorView = collectionViewsQuery.children(matching: .cell).element(boundBy: 3).otherElements["colorView"]
        let leftOfMidCellColorView = collectionViewsQuery.children(matching: .cell).element(boundBy: 0).otherElements["colorView"]
        let centerCellColorView = collectionViewsQuery.children(matching: .cell).element(boundBy: 1).otherElements["colorView"]
        let rightOfMidCellColorView = collectionViewsQuery.children(matching: .cell).element(boundBy: 2).otherElements["colorView"]
        let farRightCellColorView = collectionViewsQuery.children(matching: .cell).element(boundBy: 4).otherElements["colorView"]
        
        XCTAssertTrue(farLeftCellColorView.exists)
        XCTAssertTrue(leftOfMidCellColorView.exists)
        XCTAssertTrue(centerCellColorView.exists)
        XCTAssertTrue(rightOfMidCellColorView.exists)
        XCTAssertTrue(farRightCellColorView.exists)

    }
    
    
}
