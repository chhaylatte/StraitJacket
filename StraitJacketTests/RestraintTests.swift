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
    
    // MARK: - Vertical
    
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
    
    // MARK: - Horizontal
    
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
    
    // MARK: - Sizing
    
    func testSetWidths() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        let expectedWidth1 = CGFloat(100), expectedWidth2 = CGFloat(50)
        
        let viewRestraint = Restraint(view)
            .widths([view1.width(expectedWidth1), Width(view2, value: expectedWidth2)])
        
        viewRestraint.isActive = true
        
        let constraint1 = view1.constraints[0]
        let constraint2 = view2.constraints[0]
        XCTAssert(constraint1.constant == expectedWidth1)
        XCTAssert(constraint2.constant == expectedWidth2)
    }
    
    func testSetRelativeWidths() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        view.addSubviews(view1, view2)
        
        let expectedFactor1 = CGFloat(1.0/4.0), expectedFactor2 = CGFloat(3.0/4.0)
        let viewRestraint = Restraint(view)
            .relativeWidths([view1.relativeWidth(expectedFactor1, of: view),
                             RelativeWidth(view2, multiple: expectedFactor2, of: view)
                ])
        
        viewRestraint.isActive = true
        
        let constraint1 = view.constraints[0]
        let constraint2 = view.constraints[1]
        
        XCTAssert(constraint1.firstItem === view1)
        XCTAssert(constraint1.secondItem === view)
        XCTAssert(constraint1.multiplier == expectedFactor1)
        
        XCTAssert(constraint2.firstItem === view2)
        XCTAssert(constraint2.secondItem === view)
        XCTAssert(constraint2.multiplier == expectedFactor2)
    }
    
    func testSetHeight() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        let expectedHeight1 = CGFloat(100), expectedHeight2 = CGFloat(50)
        
        let viewRestraint = Restraint(view)
            .heights([view1.height(expectedHeight1), Height(view2, value: expectedHeight2)])
        
        viewRestraint.isActive = true
        
        let constraint1 = view1.constraints[0]
        let constraint2 = view2.constraints[0]
        XCTAssert(constraint1.constant == expectedHeight1)
        XCTAssert(constraint2.constant == expectedHeight2)
    }
    
    func testSetRelativeHeights() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        view.addSubviews(view1, view2)
        
        let expectedFactor1 = CGFloat(1.0/4.0), expectedFactor2 = CGFloat(3.0/4.0)
        let viewRestraint = Restraint(view)
            .relativeHeights([view1.relativeHeight(expectedFactor1, of: view),
                             RelativeHeight(view2, multiple: expectedFactor2, of: view)
                ])
        
        viewRestraint.isActive = true
        
        let constraint1 = view.constraints[0]
        let constraint2 = view.constraints[1]
        
        XCTAssert(constraint1.firstItem === view1)
        XCTAssert(constraint1.secondItem === view)
        XCTAssert(constraint1.multiplier == expectedFactor1)
        
        XCTAssert(constraint2.firstItem === view2)
        XCTAssert(constraint2.secondItem === view)
        XCTAssert(constraint2.multiplier == expectedFactor2)
    }
    
    func testSiblingRelativeSizes() {
        let view1 = UIView(), view2 = UIView(), view3 = UIView()
        let view = UIView()
        view.addSubviews(view1, view2, view3)
        
        let expectedFactor2 = CGFloat(3.0/4.0), expectedFactor3 = CGFloat(1.0/2.0)
        let viewRestraint = Restraint(view).relativeHeights([
            view2.relativeHeight(expectedFactor2, of: view1),
            view3.relativeHeight(expectedFactor3, of: view1)
            ])
        
        viewRestraint.isActive = true
        
        let constraint21 = view.constraints[0]
        let constraint31 = view.constraints[1]
        
        
        XCTAssert(constraint21.firstItem === view2)
        XCTAssert(constraint21.secondItem === view1)
        XCTAssert(constraint21.constant == 0)
        XCTAssert(constraint21.multiplier == expectedFactor2)
        
        XCTAssert(constraint31.firstItem === view3)
        XCTAssert(constraint31.secondItem === view1)
        XCTAssert(constraint31.constant == 0)
        XCTAssert(constraint31.multiplier == expectedFactor3)
    }
    
    // MARK: - Aligning
    
    func testAlignSidesToSuperview() {
        let checkSides: [Sides] = [.top, .bottom, .left, .right]
        let sideToLayoutAtribute: [Sides: NSLayoutAttribute] = [
            .top: .top,
            .bottom: .bottom,
            .left: .left,
            .right:.right
        ]
        
        for side in checkSides {
            let view1 = UIView(), view2 = UIView()
            let view = UIView([view1, view2])
            let restraint = Restraint(view).aligns([view1, view2], sides: side)
            restraint.isActive = true
            
            let constraint1 = view.constraints[0]
            
            let expectedAttribute = sideToLayoutAtribute[side]!
            
            XCTAssert(constraint1.constant == 0)
            XCTAssert(constraint1.firstItem === view1)
            XCTAssert(constraint1.secondItem === view)
            XCTAssert(constraint1.firstAttribute == constraint1.secondAttribute)
            XCTAssert(constraint1.firstAttribute == expectedAttribute, "Expected \(side) to connect \(expectedAttribute) anchor")
        }
    }
}
