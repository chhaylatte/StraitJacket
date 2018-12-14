//
//  StraitJacketFunctionTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 12/13/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest
@testable import StraitJacket

class StraitJacketFunctionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEqual() {
        let equalModifier = equal(100)

        XCTAssert(equalModifier.value == 100)
        XCTAssert(equalModifier.relation == .equal)
    }

    func testLeast() {
        let equalModifier = least(100)

        XCTAssert(equalModifier.value == 100)
        XCTAssert(equalModifier.relation == .greaterThanOrEqual)
    }

    func testMost() {
        let equalModifier = most(100)

        XCTAssert(equalModifier.value == 100)
        XCTAssert(equalModifier.relation == .lessThanOrEqual)
    }
}
