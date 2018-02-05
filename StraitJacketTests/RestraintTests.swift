//
//  RestraintTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

import XCTest
@testable import StraitJacket

class RestraintTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActiveConstraints() {
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2)
        
        let viewRestraint = Restraint(view).vertical([label1, label2])
        
        XCTAssert(view.constraints.isEmpty)
        XCTAssert(!viewRestraint.isActive)
        
        viewRestraint.isActive = true
        
        XCTAssert(!view.constraints.isEmpty)
        XCTAssert(viewRestraint.isActive == true)
    }
    
    func testVerticalChain() {
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2, label3)
        
        // label1 - label2 - label3
        let viewRestraint = Restraint(view).vertical([label1, label2, label3])
        viewRestraint.isActive = true
        
        // Test label1 - label2
        let constraint = view.constraints[0]
        
        guard let firstItem = constraint.firstItem as? UILabel,
            let secondItem = constraint.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem === label2)
        XCTAssert(secondItem === label1)
        XCTAssert(constraint.relation == .equal)
        XCTAssert(constraint.firstAttribute == .top)
        XCTAssert(constraint.secondAttribute == .bottom)
        
        // Test label2 - label3
        let constraint2 = view.constraints[1]
        
        guard let firstItem2 = constraint2.firstItem as? UILabel,
            let secondItem2 = constraint2.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem2 === label3)
        XCTAssert(secondItem2 === label2)
        XCTAssert(constraint2.relation == .equal)
        XCTAssert(constraint2.firstAttribute == .top)
        XCTAssert(constraint2.secondAttribute == .bottom)
    }
    
    func testVerticalChainWithConstantSpace() {
        let expectedSpace: CGFloat = 11
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2)
        
        // label1 -(8)- label2
        let viewRestraint = Restraint(view).vertical([label1, Space(expectedSpace), label2])
        viewRestraint.isActive = true
        
        // Test label1 - label2
        let constraint = view.constraints[0]
        
        guard let firstItem = constraint.firstItem as? UILabel,
            let secondItem = constraint.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem === label2)
        XCTAssert(secondItem === label1)
        XCTAssert(constraint.relation == .equal)
        XCTAssert(constraint.firstAttribute == .top)
        XCTAssert(constraint.secondAttribute == .bottom)
        XCTAssert(constraint.constant == expectedSpace)
    }
    
    func testMultipleVerticalChain() {
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel(), label4 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2, label3, label4)
        
        // Column 1: label1 - label2
        // Column 2: label3 - label4
        let viewRestraint = Restraint(view).vertical([label1, label2],
                                                     [label3, label4])
        viewRestraint.isActive = true
        
        // Test Column 1
        let constraint = view.constraints[0]
        
        guard let firstItem = constraint.firstItem as? UILabel,
            let secondItem = constraint.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem === label2)
        XCTAssert(secondItem === label1)
        XCTAssert(constraint.relation == .equal)
        XCTAssert(constraint.firstAttribute == .top)
        XCTAssert(constraint.secondAttribute == .bottom)
        
        // Test Column 2
        let constraint2 = view.constraints[1]
        
        guard let firstItem2 = constraint2.firstItem as? UILabel,
            let secondItem2 = constraint2.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem2 === label4)
        XCTAssert(secondItem2 === label3)
        XCTAssert(constraint2.relation == .equal)
        XCTAssert(constraint2.firstAttribute == .top)
        XCTAssert(constraint2.secondAttribute == .bottom)
    }
    
    func testHorizontalChain() {
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2, label3)
        
        // label1 - label2 - label3
        let viewRestraint = Restraint(view).horizontal([label1, label2, label3])
        viewRestraint.isActive = true
        
        // Test label1 - label2
        let constraint = view.constraints[0]
        
        guard let firstItem = constraint.firstItem as? UILabel,
            let secondItem = constraint.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem === label2)
        XCTAssert(secondItem === label1)
        XCTAssert(constraint.relation == .equal)
        XCTAssert(constraint.firstAttribute == .leading)
        XCTAssert(constraint.secondAttribute == .trailing)
        
        // Test label2 - label3
        let constraint2 = view.constraints[1]
        
        guard let firstItem2 = constraint2.firstItem as? UILabel,
            let secondItem2 = constraint2.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem2 === label3)
        XCTAssert(secondItem2 === label2)
        XCTAssert(constraint2.relation == .equal)
        XCTAssert(constraint2.firstAttribute == .leading)
        XCTAssert(constraint2.secondAttribute == .trailing)
    }
    
    func testHorizontalChainWithConstantSpace() {
        let expectedSpace: CGFloat = 11
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2)
        
        // label1 -(11)- label2
        let viewRestraint = Restraint(view).horizontal([label1, Space(expectedSpace), label2])
        viewRestraint.isActive = true
        
        // Test label1 - label2
        let constraint = view.constraints[0]
        
        guard let firstItem = constraint.firstItem as? UILabel,
            let secondItem = constraint.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem === label2)
        XCTAssert(secondItem === label1)
        XCTAssert(constraint.relation == .equal)
        XCTAssert(constraint.constant == expectedSpace)
        XCTAssert(constraint.firstAttribute == .leading)
        XCTAssert(constraint.secondAttribute == .trailing)
    }
    
    func testMultipleHorizontalChain() {
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel(), label4 = UILabel()
        let view = UIView()
        view.addSubviews(label1, label2, label3, label4)
        
        // Row 1: label1 - label2
        // Row 2: label3 - label4
        let viewRestraint = Restraint(view).horizontal([label1, label2],
                                                       [label3, label4])
        viewRestraint.isActive = true
        
        // Test Row 1
        let constraint = view.constraints[0]
        
        guard let firstItem = constraint.firstItem as? UILabel,
            let secondItem = constraint.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem === label2)
        XCTAssert(secondItem === label1)
        XCTAssert(constraint.relation == .equal)
        XCTAssert(constraint.firstAttribute == .leading)
        XCTAssert(constraint.secondAttribute == .trailing)
        
        // Test Row 2
        let constraint2 = view.constraints[1]
        
        guard let firstItem2 = constraint2.firstItem as? UILabel,
            let secondItem2 = constraint2.secondItem as? UILabel else { return XCTFail() }
        
        XCTAssert(firstItem2 === label4)
        XCTAssert(secondItem2 === label3)
        XCTAssert(constraint2.relation == .equal)
        XCTAssert(constraint2.firstAttribute == .leading)
        XCTAssert(constraint2.secondAttribute == .trailing)
    }
}
