//
//  RestraintPriorityTest.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 8/8/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest
@testable import StraitJacket

class RestraintPriorityTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPriority() {
        let expPriority: UILayoutPriority = .defaultHigh
        let alignmentWithPriority = Alignment.right.withPriority(expPriority).withId("dont care").withPriority(.defaultLow).withId("sss")
        
        let view = UIView()
        let subview = UIView()
        
        let constraint = alignmentWithPriority.modifiedAlignmentConstraint(forSource: subview, target: view, modifier: RestraintModifier(0))
        XCTAssert(constraint.priority == expPriority)
    }
    
}
