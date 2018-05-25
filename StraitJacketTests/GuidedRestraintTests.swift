//
//  GuidedRestraintTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 5/24/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest
@testable import StraitJacket

class GuidedRestraintTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGuides() {
        let alignment: [Alignment] = [.top, .bottom, .left, .right]
        let centerAlignment: [Alignment] = [.centerX, .centerY]
        let softAlignment: [Alignment] = [.softTop, .softBottom, .softLeft, .softRight]
        let allAlignment: [Alignment] = alignment + centerAlignment + softAlignment
        
        let alignmentToLayoutAtribute: [Alignment: NSLayoutAttribute] = [
            .top: .top,
            .bottom: .bottom,
            .left: .left,
            .right: .right,
            .centerX: .centerX,
            .centerY: .centerY,
            .softTop: .top,
            .softBottom: .bottom,
            .softLeft: .left,
            .softRight: .right
        ]
        
        let alignmentToRelation: [Alignment: NSLayoutRelation] = [
            .top: .equal,
            .bottom: .equal,
            .left: .equal,
            .right: .equal,
            .centerX: .equal,
            .centerY: .equal,
            .softTop: .greaterThanOrEqual,
            .softBottom: .lessThanOrEqual,
            .softLeft: .greaterThanOrEqual,
            .softRight: .lessThanOrEqual
        ]
        
        allAlignment.forEach {
            let containerView = UIView()
            let view1 = UIView()
            let guide = UILayoutGuide()
            
            let restraint = Restraint(containerView)
                .addItems([view1, guide])
                .guide(guide).aligns([view1], with: $0)
            restraint.isActive = true
            
            let constraints = containerView.constraints
            let expectedRelation: NSLayoutRelation = alignmentToRelation[$0]!
            
            XCTAssert(constraints[0].firstItem === view1)
            XCTAssert(constraints[0].firstAttribute == alignmentToLayoutAtribute[$0])
            XCTAssert(constraints[0].secondItem === guide)
            XCTAssert(constraints[0].secondAttribute == alignmentToLayoutAtribute[$0])
            XCTAssert(constraints[0].relation == expectedRelation)
        }
    }
}
