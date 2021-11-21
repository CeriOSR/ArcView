//
//  ViewModelTest.swift
//  MyArcViewProjectTests
//
//  Created by Rey Cerio on 2021-11-19.
//

import XCTest
import CoreGraphics
@testable import MyArcViewProject

class ViewModelTest: XCTestCase {
    
    let vc = ArcController(viewmodel: ArcControllerViewModel() ) as ArcController

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewModelExist() {
        XCTAssertNotNil(vc.viewmodel)
    }
    
    func testNumberOfItemsInColorArray() {
        XCTAssertEqual(vc.viewmodel.colors.count, 20)
    }
    
    func testRandomItemInColorArray() {
        XCTAssertEqual(vc.viewmodel.colors[10], .systemRed)
    }
}
