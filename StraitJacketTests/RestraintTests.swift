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
        
        let viewRestraint = Restraint(view)
            .addItems([label1, label2])
            .chainVertically([label1, label2])
        
        XCTAssert(view.constraints.isEmpty)
        
        viewRestraint.activate()
        XCTAssert(!view.constraints.isEmpty)
        
        viewRestraint.deactivate()
        XCTAssert(view.constraints.isEmpty)
    }
    
    func testSubRestraintsActivation() {
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()
        
        let viewRestraint = Restraint(view)
            .addItems([label1, label2])
            .chainVertically([label1, label2])
        
        let superRestraint = Restraint(view)
            .addRestraints([viewRestraint])
        
        XCTAssert(view.constraints.isEmpty)
        
        superRestraint.activate()
        XCTAssert(!view.constraints.isEmpty)
        
        superRestraint.deactivate()
        XCTAssert(view.constraints.isEmpty)
    }
    
    // MARK: - Vertical
    
    func testVerticalChain() {
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel()
        let view = UIView()
        
        // label1 - label2 - label3
        let viewRestraint = Restraint(view)
            .addItems([label1, label2, label3])
            .chainVertically([label1, label2, label3])
        viewRestraint.activate()
        
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
        
        // label1 -(8)- label2
        let viewRestraint = Restraint(view)
            .addItems([label1, label2])
            .chainVertically([label1, Space(expectedSpace), label2])
        viewRestraint.activate()
        
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
    
    func testVerticalChainWithDefaultSpace() {
        let expectedSpace: CGFloat = 8
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()
        
        // label1 - label2
        let viewRestraint = Restraint(view)
            .addItems([label1, label2])
            .chainVertically([label1, label2])
        viewRestraint.activate()
        
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
        
        // Column 1: label1 - label2
        // Column 2: label3 - label4
        let viewRestraint = Restraint(view)
            .addItems([label1, label2, label3, label4])
            .chainVertically([label1, label2],
                      [label3, label4])
        viewRestraint.activate()
        
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
        
        // label1 - label2 - label3
        let viewRestraint = Restraint(view)
            .addItems([label1, label2, label3])
            .chainHorizontally([label1, label2, label3])
        viewRestraint.activate()
        
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
        
        // label1 -(11)- label2
        let viewRestraint = Restraint(view)
            .addItems([label1, label2])
            .chainHorizontally([label1, Space(expectedSpace), label2])
        viewRestraint.activate()
        
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
    
    func testHorizontalChainWithDefaultSpace() {
        let expectedSpace: CGFloat = 8
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()
        
        // label1 - label2
        let viewRestraint = Restraint(view)
            .addItems([label1, label2])
            .chainHorizontally([label1, label2])
        viewRestraint.activate()
        
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
        
        // Row 1: label1 - label2
        // Row 2: label3 - label4
        let viewRestraint = Restraint(view)
            .addItems([label1, label2, label3, label4])
            .chainHorizontally([label1, label2],
                        [label3, label4])
        viewRestraint.activate()
        
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
            .setWidths([view1.width(expectedWidth1), Width(view2, value: expectedWidth2)])
        
        viewRestraint.activate()
        
        let constraint1 = view1.constraints[0]
        let constraint2 = view2.constraints[0]
        XCTAssert(constraint1.constant == expectedWidth1)
        XCTAssert(constraint1.firstAttribute == .width)
        XCTAssert(constraint2.constant == expectedWidth2)
        XCTAssert(constraint2.firstAttribute == .width)
    }
    
    func testSetRelativeWidths() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        
        let expectedFactor1 = CGFloat(1.0/4.0), expectedFactor2 = CGFloat(3.0/4.0)
        let viewRestraint = Restraint(view)
            .addItems([view1, view2])
            .setRelativeWidths([view1.relativeWidth(expectedFactor1, of: view), RelativeWidth(view2, multiple: expectedFactor2, of: view)
                ])
        
        viewRestraint.activate()
        
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
            .setHeights([view1.height(expectedHeight1), Height(view2, value: expectedHeight2)])
        
        viewRestraint.activate()
        
        let constraint1 = view1.constraints[0]
        let constraint2 = view2.constraints[0]
        XCTAssert(constraint1.constant == expectedHeight1)
        XCTAssert(constraint1.firstAttribute == .height)
        XCTAssert(constraint2.constant == expectedHeight2)
        XCTAssert(constraint2.firstAttribute == .height)
    }
    
    func testSetRelativeHeights() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        
        let expectedFactor1 = CGFloat(1.0/4.0), expectedFactor2 = CGFloat(3.0/4.0)
        let viewRestraint = Restraint(view)
            .addItems([view1, view2])
            .setRelativeHeights([view1.relativeHeight(expectedFactor1, of: view),
                             RelativeHeight(view2, multiple: expectedFactor2, of: view)
                ])
        
        viewRestraint.activate()
        
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
        
        let expectedFactor2 = CGFloat(3.0/4.0), expectedFactor3 = CGFloat(1.0/2.0)
        let viewRestraint = Restraint(view)
            .addItems([view1, view2, view3])
            .setRelativeHeights([
                view2.relativeHeight(expectedFactor2, of: view1),
                view3.relativeHeight(expectedFactor3, of: view1)
            ])
        
        viewRestraint.activate()
        
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
        let checkSides: [Alignment] = [.top, .bottom, .left, .right]
        let sideToLayoutAtribute: [Alignment: NSLayoutAttribute] = [
            .top: .top,
            .bottom: .bottom,
            .left: .left,
            .right:.right
        ]
        
        for side in checkSides {
            let view1 = UIView(), view2 = UIView()
            let view = UIView()
            
            let restraint = Restraint(view)
                .addItems([view1, view2])
                .alignItems([view1, view2], to: [side])
            restraint.activate()
            
            let constraint1 = view.constraints[0]
            
            let expectedAttribute = sideToLayoutAtribute[side]!
            
            XCTAssert(constraint1.constant == 0)
            XCTAssert(constraint1.firstItem === view1)
            XCTAssert(constraint1.secondItem === view)
            XCTAssert(constraint1.firstAttribute == constraint1.secondAttribute)
            XCTAssert(constraint1.firstAttribute == expectedAttribute, "Expected \(side) to connect \(expectedAttribute) anchor")
        }
    }
    
    // MARK: - Constraint Building
    
    func testModifiedChainConstraint() {
        let directions: [Direction] = [Direction.horizontal, .vertical]
        let modifiers = [RestraintModifier(0, multiple: 0.25, relation: .equal),
                         RestraintModifier(0, multiple: 0.25, relation: .greaterThanOrEqual),
                         RestraintModifier(0, multiple: 0.25, relation: .lessThanOrEqual)]
        let restraint = Restraint(UIView())
        let v0 = UIView(), v1 = UIView()
        
        modifiers.forEach { modifier in
            directions.forEach { direction in
                let aConstraint = restraint.modifiedChainConstraint(for: direction, v0: v0, v1: v1, modifier: modifier)
                XCTAssert(aConstraint.constant == modifier.value)
                XCTAssert(aConstraint.relation == modifier.relation)
            }
        }
    }
    
    func testModifiedSizeConstraint() {
        let modifiers = [RestraintModifier(0, multiple: 0.25, relation: .equal),
                         RestraintModifier(0, multiple: 0.25, relation: .greaterThanOrEqual),
                         RestraintModifier(0, multiple: 0.25, relation: .lessThanOrEqual)]
        let size: [Size] = [.width, .height]
        let restraint = Restraint(UIView())
        let v0 = UIView()
        
        modifiers.forEach { modifier in
            size.forEach { size in
                let aConstraint = restraint.modifiedSizeConstraint(for: size, v0: v0, modifier: modifier)
                XCTAssert(aConstraint.relation == modifier.relation)
                XCTAssert(aConstraint.constant == modifier.value)
            }
        }
    }
    
    func testModifiedRelativeSizeConstraint() {
        let modifiers = [RestraintModifier(0, multiple: 0.25, relation: .equal),
                         RestraintModifier(0, multiple: 0.25, relation: .greaterThanOrEqual),
                         RestraintModifier(0, multiple: 0.25, relation: .lessThanOrEqual)]
        let size: [Size] = [.width, .height]
        let restraint = Restraint(UIView())
        let v0 = UIView(), v1 = UIView()
        
        modifiers.forEach { modifier in
            size.forEach { size in
                let aRelativeConstraint = restraint.modifiedRelativeSizeConstraint(for: size, v0: v0, v1: v1, modifier: modifier)
                XCTAssert(aRelativeConstraint.constant == modifier.value)
                XCTAssert(aRelativeConstraint.relation == modifier.relation)
                XCTAssert(aRelativeConstraint.multiplier == modifier.multiple)
            }
        }
    }
    
    func testModifiedAlignmentConstraint() {
        let expOffset: CGFloat = 130
        let alignmentWithPriority = Alignment.centerY.offset(expOffset).withId("dont care").priority(.defaultLow).withId("sss")
        
        let view = UIView()
        let subview = UIView()
        
        let constraint = alignmentWithPriority.modifiedAlignmentConstraint(forSource: subview, target: view, modifier: RestraintModifier(0))
        XCTAssert(constraint.constant == expOffset)
    }
    
    func testActivateAndDeactivateRestraints() {
        let view = UIView()
        let subview = UIView()
        
        let widthRestraint = Restraint(view)
            .addItems([subview])
            .setWidths([subview.width(20)])
        
        let alignLeftRestraint = Restraint(view)
            .addRestraints([widthRestraint])
            .addItems([subview])
            .alignItems([subview], to: [.left])
        
        let alignRightRestraint = Restraint(view)
            .addRestraints([widthRestraint])
            .addItems([subview])
            .alignItems([subview], to: [.right])
        
        alignLeftRestraint.activate()
        
        Restraint.activate(alignRightRestraint, andDeactivate: alignLeftRestraint)
        
        XCTAssert(widthRestraint.constraints.first!.isActive == true)
        
        let leftConstraintsActive = alignLeftRestraint.constraints
            .map { $0.isActive }
            .reduce(true) { (result, current) -> Bool in
                return result && current
        }
        
        XCTAssert(leftConstraintsActive == false)
        
        let rightConstraintsActive = alignRightRestraint.constraints
            .map { $0.isActive }
            .reduce(true) { (result, current) -> Bool in
                return result && current
        }
        
        XCTAssert(rightConstraintsActive == true)
    }
    
    func testAddAndRemoveConstraints() {
        let aView = UIView()
        
        let aRestraint = Restraint(aView)
        let aWidthConstraint = aView.widthAnchor.constraint(equalToConstant: 100)
        aRestraint.addConstraints([aWidthConstraint])
        
        XCTAssert(aView.constraints.isEmpty)
        XCTAssert(aRestraint.constraints.contains(aWidthConstraint))
        
        aRestraint.activate()
        XCTAssert(aView.constraints.contains(aWidthConstraint))
        
        aRestraint.removeConstraints([aWidthConstraint])
        XCTAssert(aRestraint.constraints.isEmpty)
        XCTAssert(aView.constraints.isEmpty)
    }
}
