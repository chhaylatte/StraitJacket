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
                .alignItems([view1], to: [$0], of: guide)
            restraint.activate()
            
            let constraints = containerView.constraints
            let expectedRelation: NSLayoutRelation = alignmentToRelation[$0]!
            
            XCTAssert(constraints[0].firstItem === view1)
            XCTAssert(constraints[0].firstAttribute == alignmentToLayoutAtribute[$0])
            XCTAssert(constraints[0].secondItem === guide)
            XCTAssert(constraints[0].secondAttribute == alignmentToLayoutAtribute[$0])
            XCTAssert(constraints[0].relation == expectedRelation)
        }
    }
    
    func testVerticalToGuide() {
        let containerView = UIView()
        let guide: UILayoutGuide = UILayoutGuide()
        let view1 = UIView()
        
        let restraint = Restraint(containerView)
            .addItems([guide, view1])
            .chainVertically([guide, view1])
        restraint.activate()
        
        let constraints = containerView.constraints
        XCTAssert(constraints[0].firstItem === view1)
        XCTAssert(constraints[0].secondItem === guide)
        XCTAssert(constraints[0].firstAttribute == .top)
        XCTAssert(constraints[0].secondAttribute == .bottom)
    }
    
    func testAlignemntIdentifiers() {
        let alignment: [Alignment] = [.top, .bottom, .left, .right]
        let centerAlignment: [Alignment] = [.centerX, .centerY]
        let softAlignment: [Alignment] = [.softTop, .softBottom, .softLeft, .softRight]
        let allAlignment: [Alignment] = alignment + centerAlignment + softAlignment
        
        allAlignment.forEach {
            let view = UIView(frame: .zero)
            let subview = UIView(frame: .zero)
            let expectedId = String(describing: $0) + "Id"
            
            let restraint = Restraint(view)
                .addItems([subview])
                .alignItems([subview], to: [$0.withId(expectedId)])
            restraint.activate()
            
            let actualId: String = restraint.constraints[0].identifier ?? "no value"
            XCTAssert(actualId == expectedId)
        }
    }
    
    func testAlignmentMultipleIdentifiers() {
        let view = UIView(frame: .zero)
        let subview = UIView(frame: .zero)
        let subview2 = UIView(frame: .zero)
        let expectedId = "exp1"
        let expectedId2 = "exp2"
        
        let restraint = Restraint(view)
            .addItems([subview, subview2])
            .alignItems(to: view, viewAlignment: [
                .view(subview, [Alignment.left.withId(expectedId)]),
                .view(subview2, [Alignment.right.withId(expectedId2)])
                ])
        
        restraint.activate()
        
        let constraint = restraint.constraints[0]
        let actualId: String = constraint.identifier ?? "no value"
        XCTAssert(actualId == expectedId)
        XCTAssert(constraint.firstItem === subview)
        XCTAssert(constraint.secondItem === view)
        XCTAssert(constraint.firstAttribute == .left)
        XCTAssert(constraint.secondAttribute == .left)
        
        let constraint2 = restraint.constraints[1]
        let actualId2: String = constraint2.identifier ?? "no value"
        XCTAssert(actualId2 == expectedId2)
        XCTAssert(constraint2.firstItem === subview2)
        XCTAssert(constraint2.secondItem === view)
        XCTAssert(constraint2.firstAttribute == .right)
        XCTAssert(constraint2.secondAttribute == .right)
    }
    
    func testChainHorizontallyInGuide() {
        let view = UIView()
        let subview1 = UIView(), subview2 = UIView()
        let guide = UILayoutGuide()
        
        let restraint = Restraint(view)
            .addItems([subview1, subview2, guide])
            .chainHorizontally([subview1, subview2], in: guide)
        restraint.activate()
        
        let alignmentConstraints = view.constraints.filter { $0.secondItem === guide }
        
        let subview1AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview1 }
        let subview1Attributes = subview1AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview1AttributeSet = Set(subview1Attributes)
        let expectedSubview1AttributeSet = Set([NSLayoutAttribute.top, .bottom, .left, .centerY].map { String(describing: $0) })
        XCTAssert(expectedSubview1AttributeSet == actualSubview1AttributeSet)
        
        let subview2AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview2 }
        let subview2Attributes = subview2AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview2AttributeSet = Set(subview2Attributes)
        let expectedSubview2AttributeSet = Set([NSLayoutAttribute.top, .bottom, .right, .centerY].map { String(describing: $0) })
        XCTAssert(expectedSubview2AttributeSet == actualSubview2AttributeSet)
    }
    
    func testChainVerticallyInGuide() {
        let view = UIView()
        let subview1 = UIView(), subview2 = UIView()
        let guide = UILayoutGuide()
        
        let restraint = Restraint(view)
            .addItems([subview1, subview2, guide])
            .chainVertically([subview1, subview2], in: guide)
        restraint.activate()
        
        let alignmentConstraints = view.constraints.filter { $0.secondItem === guide }
        
        let subview1AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview1 }
        let subview1Attributes = subview1AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview1AttributeSet = Set(subview1Attributes)
        let expectedSubview1AttributeSet = Set([NSLayoutAttribute.top, .left, .right, .centerX].map { String(describing: $0) })
        XCTAssert(expectedSubview1AttributeSet == actualSubview1AttributeSet)
        
        let subview2AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview2 }
        let subview2Attributes = subview2AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview2AttributeSet = Set(subview2Attributes)
        let expectedSubview2AttributeSet = Set([NSLayoutAttribute.left, .bottom, .right, .centerX].map { String(describing: $0) })
        XCTAssert(expectedSubview2AttributeSet == actualSubview2AttributeSet)
    }
    
    func testGuideAxisCenterAlignment() {
        let view = UIView()
        let restraint = Restraint(view)
        
        let alignmentFromGuideXCentering =  [GuideXCentering.centerX, .left, .right]
            .map { restraint.alignment(with: $0) }
        
        XCTAssert(alignmentFromGuideXCentering == [Alignment.centerX, .left, .right])
        
        let alignmentFromGuideYCentering =  [GuideYCentering.centerY, .top, .bottom]
            .map { restraint.alignment(with: $0) }
        
        XCTAssert(alignmentFromGuideYCentering == [Alignment.centerY, .top, .bottom])
    }
    
    func testGuideHorizontalEndingAlignment() {
        let view = UIView()
        let restraint = Restraint(view)
        
        let (first, last) = restraint.horizontalEndingAlignment(for: .normal)
        XCTAssert(first == .left && last == .right)
        
        let (first2, last2) = restraint.horizontalEndingAlignment(for: .soft)
        XCTAssert(first2 == .softLeft && last2 == .softRight)
    }
    
    func testGuideVerticalEndingAlignment() {
        let view = UIView()
        let restraint = Restraint(view)
        
        let (first, last) = restraint.verticalEndingAlignment(for: .normal)
        XCTAssert(first == .top && last == .bottom)
        
        let (first2, last2) = restraint.verticalEndingAlignment(for: .soft)
        XCTAssert(first2 == .softTop && last2 == .softBottom)
    }
    
    func testGuideAxisAlignment() {
        let view = UIView()
        let restraint = Restraint(view)
        
        let actualVerticalNormalAlignment = restraint.alignment(for: .vertical, with: .normal)
        let expectedVerticalNormalAlignmentSet: Set<Alignment> = [.left, .right]
        XCTAssert(actualVerticalNormalAlignment == expectedVerticalNormalAlignmentSet)
        
        let actualVerticalSoftAlignment = restraint.alignment(for: .vertical, with: .soft)
        let expectedVerticalSoftAlignmentSet: Set<Alignment> = [.softLeft, .softRight]
        XCTAssert(actualVerticalSoftAlignment == expectedVerticalSoftAlignmentSet)
        
        let actualHorizontalNormalAlignment = restraint.alignment(for: .horizontal, with: .normal)
        let expectedHorizontalNormalAlignmentSet: Set<Alignment> = [.top, .bottom]
        XCTAssert(actualHorizontalNormalAlignment == expectedHorizontalNormalAlignmentSet)
        
        let actualHorizontalSoftAlignment = restraint.alignment(for: .horizontal, with: .soft)
        let expectedHorizontalSoftAlignmentSet: Set<Alignment> = [.softTop, .softBottom]
        XCTAssert(actualHorizontalSoftAlignment == expectedHorizontalSoftAlignmentSet)
    }
}
