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
        let alignment: [Alignment] = [.top, .bottom, .leading, .trailing]
        let centerAlignment: [Alignment] = [.centerX, .centerY]
        let softAlignment: [Alignment] = [.softTop, .softBottom, .softLeading, .softTrailing]
        let allAlignment: [Alignment] = alignment + centerAlignment + softAlignment
        
        let alignmentToLayoutAtribute: [Alignment: NSLayoutConstraint.Attribute] = [
            .top: .top,
            .bottom: .bottom,
            .leading: .leading,
            .trailing: .trailing,
            .centerX: .centerX,
            .centerY: .centerY,
            .softTop: .top,
            .softBottom: .bottom,
            .softLeading: .leading,
            .softTrailing: .trailing
        ]
        
        let alignmentToRelation: [Alignment: NSLayoutConstraint.Relation] = [
            .top: .equal,
            .bottom: .equal,
            .leading: .equal,
            .trailing: .equal,
            .centerX: .equal,
            .centerY: .equal,
            .softTop: .greaterThanOrEqual,
            .softBottom: .lessThanOrEqual,
            .softLeading: .greaterThanOrEqual,
            .softTrailing: .lessThanOrEqual
        ]
        
        allAlignment.forEach {
            let containerView = UIView()
            let view1 = UIView()
            let guide = UILayoutGuide()
            
            let restraint = Restraint(containerView, items: [view1, guide])
                .alignItems([view1], to: [$0], of: guide)
            restraint.activate()
            
            let constraints = containerView.constraints
            let expectedRelation: NSLayoutConstraint.Relation = alignmentToRelation[$0]!
            
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
        
        let restraint = Restraint(containerView, items: [guide, view1])
            .chainVertically([guide, view1])
        restraint.activate()
        
        let constraints = containerView.constraints
        XCTAssert(constraints[0].firstItem === view1)
        XCTAssert(constraints[0].secondItem === guide)
        XCTAssert(constraints[0].firstAttribute == .top)
        XCTAssert(constraints[0].secondAttribute == .bottom)
    }
    
    func testAlignemntIdentifiers() {
        let alignment: [Alignment] = [.top, .bottom, .leading, .trailing]
        let centerAlignment: [Alignment] = [.centerX, .centerY]
        let softAlignment: [Alignment] = [.softTop, .softBottom, .softLeading, .softTrailing]
        let allAlignment: [Alignment] = alignment + centerAlignment + softAlignment
        
        allAlignment.forEach {
            let view = UIView(frame: .zero)
            let subview = UIView(frame: .zero)
            let expectedId = String(describing: $0) + "Id"
            
            let restraint = Restraint(view, items: [subview])
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
        
        let restraint = Restraint(view, items: [subview, subview2])
            .alignItems(to: view, viewAlignment: [
                .view(subview, [Alignment.leading.withId(expectedId)]),
                .view(subview2, [Alignment.trailing.withId(expectedId2)])
                ])
        
        restraint.activate()
        
        let constraint = restraint.constraints[0]
        let actualId: String = constraint.identifier ?? "no value"
        XCTAssert(actualId == expectedId)
        XCTAssert(constraint.firstItem === subview)
        XCTAssert(constraint.secondItem === view)
        XCTAssert(constraint.firstAttribute == .leading)
        XCTAssert(constraint.secondAttribute == .leading)
        
        let constraint2 = restraint.constraints[1]
        let actualId2: String = constraint2.identifier ?? "no value"
        XCTAssert(actualId2 == expectedId2)
        XCTAssert(constraint2.firstItem === subview2)
        XCTAssert(constraint2.secondItem === view)
        XCTAssert(constraint2.firstAttribute == .trailing)
        XCTAssert(constraint2.secondAttribute == .trailing)
    }
    
    func testChainHorizontallyInGuide() {
        let view = UIView()
        let subview1 = UIView(), subview2 = UIView()
        let guide = UILayoutGuide()
        
            let restraint = Restraint(view, items: [subview1, subview2, guide])
            .chainHorizontally([subview1, subview2], in: guide)
        restraint.activate()
        
        let alignmentConstraints = view.constraints.filter { $0.secondItem === guide }
        
        let subview1AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview1 }
        let subview1Attributes = subview1AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview1AttributeSet = Set(subview1Attributes)
        let expectedSubview1AttributeSet = Set([NSLayoutConstraint.Attribute.top, .bottom, .leading].map { String(describing: $0) })
        XCTAssert(expectedSubview1AttributeSet == actualSubview1AttributeSet)
        
        let subview2AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview2 }
        let subview2Attributes = subview2AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview2AttributeSet = Set(subview2Attributes)
        let expectedSubview2AttributeSet = Set([NSLayoutConstraint.Attribute.top, .bottom, .trailing].map { String(describing: $0) })
        XCTAssert(expectedSubview2AttributeSet == actualSubview2AttributeSet)
    }

    func testHorizontalChainInGuideCanInset() {
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()

        let viewRestraint = Restraint(view, items: [label1, label2])
            .chainHorizontally([label1], in: view, aligning: [Alignment.leading.inset(11), Alignment.trailing.inset(12), Alignment.top.inset(13), Alignment.bottom.inset(14)])
        viewRestraint.activate()

        let expectedAttributeToConstant: [
            NSLayoutConstraint.Attribute: CGFloat] = [
            NSLayoutConstraint.Attribute.leading: 11,
            NSLayoutConstraint.Attribute.trailing: -12,
            NSLayoutConstraint.Attribute.top: 13,
            NSLayoutConstraint.Attribute.bottom: -14
        ]

        let constraints = view.constraints
        for i in 0..<constraints.count {
            let aConstraint = constraints[i]
            XCTAssert(aConstraint.firstAttribute == aConstraint.secondAttribute)
            XCTAssert(aConstraint.constant == expectedAttributeToConstant[aConstraint.secondAttribute])
        }

        let allAlignmentAttributes = Set(constraints.map { $0.secondAttribute })
        let expectedAlignmentAttributes = Set([NSLayoutConstraint.Attribute.leading,
                                               NSLayoutConstraint.Attribute.trailing,
                                               NSLayoutConstraint.Attribute.top,
                                               NSLayoutConstraint.Attribute.bottom])

        XCTAssert(allAlignmentAttributes == expectedAlignmentAttributes)
    }

    func testHorizontalChainInGuideCentersY() {
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()

        let viewRestraint = Restraint(view, items: [label1, label2])
            .chainHorizontally([label1, label2], in: view, aligning: [.centerY])
        viewRestraint.activate()
        let constraints = view.constraints.filter { $0.firstAttribute == $0.secondAttribute && $0.firstAttribute == .centerY }

        let views = constraints.compactMap { $0.firstItem as? UIView }
        let viewSet = Set(views)

        XCTAssert(viewSet.contains(label1))
        XCTAssert(viewSet.contains(label2))
    }

    func testChainVerticallyInGuide() {
        let view = UIView()
        let subview1 = UIView(), subview2 = UIView()
        let guide = UILayoutGuide()
        
        let restraint = Restraint(view, items: [subview1, subview2, guide])
            .chainVertically([subview1, subview2], in: guide)
        restraint.activate()
        
        let alignmentConstraints = view.constraints.filter { $0.secondItem === guide }
        
        let subview1AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview1 }
        let subview1Attributes = subview1AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview1AttributeSet = Set(subview1Attributes)
        let expectedSubview1AttributeSet = Set([NSLayoutConstraint.Attribute.top, .leading, .trailing].map { String(describing: $0) })
        XCTAssert(expectedSubview1AttributeSet == actualSubview1AttributeSet)
        
        let subview2AlignmentConstraints = alignmentConstraints.filter { $0.firstItem === subview2 }
        let subview2Attributes = subview2AlignmentConstraints.map { String(describing: $0.firstAttribute) }
        let actualSubview2AttributeSet = Set(subview2Attributes)
        let expectedSubview2AttributeSet = Set([NSLayoutConstraint.Attribute.leading, .bottom, .trailing].map { String(describing: $0) })
        XCTAssert(expectedSubview2AttributeSet == actualSubview2AttributeSet)
    }

    func testVerticalChainInGuideCentersX() {
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()

        let viewRestraint = Restraint(view, items: [label1, label2])
            .chainVertically([label1, label2], in: view, aligning: [.centerX])
        viewRestraint.activate()
        let constraints = view.constraints.filter { $0.firstAttribute == $0.secondAttribute && $0.firstAttribute == .centerX }

        let views = constraints.compactMap { $0.firstItem as? UIView }
        let viewSet = Set(views)

        XCTAssert(viewSet.contains(label1))
        XCTAssert(viewSet.contains(label2))
    }

    func testVerticalChainInGuideCanInset() {
        let label1 = UILabel(), label2 = UILabel()
        let view = UIView()

        let viewRestraint = Restraint(view, items: [label1, label2])
            .chainVertically([label1], in: view, aligning: [Alignment.leading.inset(11), Alignment.trailing.inset(12), Alignment.top.inset(13), Alignment.bottom.inset(14)])
        viewRestraint.activate()

        let expectedAttributeToConstant: [NSLayoutConstraint.Attribute: CGFloat] = [
            NSLayoutConstraint.Attribute.leading: 11,
            NSLayoutConstraint.Attribute.trailing: -12,
            NSLayoutConstraint.Attribute.top: 13,
            NSLayoutConstraint.Attribute.bottom: -14
        ]

        let constraints = view.constraints
        for i in 0..<constraints.count {
            let aConstraint = constraints[i]
            XCTAssert(aConstraint.firstAttribute == aConstraint.secondAttribute)
            XCTAssert(aConstraint.constant == expectedAttributeToConstant[aConstraint.secondAttribute])
        }

        let allAlignmentAttributes = Set(constraints.map { $0.secondAttribute })
        let expectedAlignmentAttributes = Set([NSLayoutConstraint.Attribute.leading,
                                               NSLayoutConstraint.Attribute.trailing,
                                               NSLayoutConstraint.Attribute.top,
                                               NSLayoutConstraint.Attribute.bottom])
        XCTAssert(allAlignmentAttributes == expectedAlignmentAttributes)
    }
}
