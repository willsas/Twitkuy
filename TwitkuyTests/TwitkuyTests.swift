//
//  TwitkuyTests.swift
//  TwitkuyTests
//
//  Created by Willa on 30/09/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import XCTest
@testable import Twitkuy

class TwitkuyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let placeVC = PlaceViewController()
        XCTAssertNotNil(placeVC.fetchData, "success")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
