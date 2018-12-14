//
//  RestraintModifierTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 12/13/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest
@testable import StraitJacket

class RestraintModifierTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDescription() {
        let constant: CGFloat = 123
        let multiple: CGFloat = 0.23
        let relation = NSLayoutRelation.equal
        let priority = UILayoutPriority(999)
        let identifier = "testID"
        let aModifier = RestraintModifier(constant, multiple: multiple, relation: relation, priority: priority, identifier: identifier)

        let description = aModifier.description
        XCTAssert(description.contains("\(constant)"))
        XCTAssert(description.contains("\(multiple)"))
        XCTAssert(description.contains("=="))
        XCTAssert(description.contains("\(priority.rawValue)"))
        XCTAssert(description.contains(identifier))
    }

    func testNoIdDescription() {
        let constant: CGFloat = 123
        let multiple: CGFloat = 0.23
        let relation = NSLayoutRelation.equal
        let priority = UILayoutPriority(999)
        let identifier: String? = nil
        let aModifier = RestraintModifier(constant, multiple: multiple, relation: relation, priority: priority, identifier: identifier)

        let description = aModifier.description
        XCTAssert(description.contains("\(constant)"))
        XCTAssert(description.contains("\(multiple)"))
        XCTAssert(description.contains("=="))
        XCTAssert(description.contains("\(priority.rawValue)"))
        XCTAssert(!description.contains("RestraintModifier."))
    }
}
