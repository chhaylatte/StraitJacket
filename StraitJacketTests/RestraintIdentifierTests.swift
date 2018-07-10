//
//  RestraintIdentifierTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 7/10/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest
@testable import StraitJacket

class RestraintIdentifierTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Identifier
    
    func testHorizontalChainConstraintIdentifiers() {
        let expectedSpace: CGFloat = 11
        let expectedIdentifier: String = "spaceIdentifier"
        let expectedIdentifier2: String = "spaceIdentifier2"
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel()
        let view = UIView()
        
        // label1 -(11)- label2
        let viewRestraint = Restraint(view)
            .addItems([label1, label2, label3])
            .chainHorizontally([label1, Space(expectedSpace).withId(expectedIdentifier),
                                label2, Space(expectedSpace).withId(expectedIdentifier2),
                                label3])
        viewRestraint.isActive = true
        
        // Test label1 - label2 - label3
        let constraint = view.constraints[0]
        XCTAssert(constraint.identifier == expectedIdentifier)
        XCTAssert(constraint === viewRestraint.constraintWithId(expectedIdentifier))
        
        let constraint2 = view.constraints[1]
        XCTAssert(constraint2.identifier == expectedIdentifier2)
        XCTAssert(constraint2 === viewRestraint.constraintWithId(expectedIdentifier2))
    }
    
    func testVerticalChainConstraintIdentifiers() {
        let expectedSpace: CGFloat = 11
        let expectedIdentifier: String = "spaceIdentifier"
        let expectedIdentifier2: String = "spaceIdentifier2"
        let label1 = UILabel(), label2 = UILabel(), label3 = UILabel()
        let view = UIView()
        
        // label1 -(11)- label2 -(11)- label3
        let viewRestraint = Restraint(view)
            .addItems([label1, label2, label3])
            .chainVertically([label1, Space(expectedSpace).withId(expectedIdentifier),
                              label2, Space(expectedSpace).withId(expectedIdentifier2),
                              label3])
        viewRestraint.isActive = true
        
        // Test label1 - label2 - label3
        let constraint = view.constraints[0]
        XCTAssert(constraint.identifier == expectedIdentifier)
        XCTAssert(constraint === viewRestraint.constraintWithId(expectedIdentifier))
        
        let constraint2 = view.constraints[1]
        XCTAssert(constraint2.identifier == expectedIdentifier2)
        XCTAssert(constraint2 === viewRestraint.constraintWithId(expectedIdentifier2))
    }
    
    func testWidthIdentifiers() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        
        let expectedId1 = "id1", expectedId2 = "id2"
        
        let viewRestraint = Restraint(view)
            .setWidths([view1.width(1).withId(expectedId1),
                        Width(view2, value: 1).withId(expectedId2)])
        
        viewRestraint.isActive = true
        
        let constraint1 = view1.constraints[0]
        let constraint2 = view2.constraints[0]
        
        XCTAssert(constraint1.identifier == expectedId1, "\(constraint1.identifier!) != \(expectedId1)")
        XCTAssert(constraint1 === viewRestraint.constraintWithId(expectedId1))
        XCTAssert(constraint2.identifier == expectedId2, "\(constraint2.identifier!) != \(expectedId2)")
        XCTAssert(constraint2 === viewRestraint.constraintWithId(expectedId2))
    }
    
    func testHeightIdentifiers() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        
        let expectedId1 = "id1", expectedId2 = "id2"
        
        let viewRestraint = Restraint(view)
            .setHeights([view1.height(1).withId(expectedId1),
                         Height(view2, value: 1).withId(expectedId2)])
        
        viewRestraint.isActive = true
        
        let constraint1 = view1.constraints[0]
        let constraint2 = view2.constraints[0]
        
        XCTAssert(constraint1.identifier == expectedId1, "\(constraint1.identifier!) != \(expectedId1)")
        XCTAssert(constraint1 === viewRestraint.constraintWithId(expectedId1))
        XCTAssert(constraint2.identifier == expectedId2, "\(constraint2.identifier!) != \(expectedId2)")
        XCTAssert(constraint2 === viewRestraint.constraintWithId(expectedId2))
    }
    
    func testScaledWidthIdentifiers() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        
        let expectedId1 = "id1", expectedId2 = "id2"
        
        let viewRestraint = Restraint(view)
            .addItems([view1, view2])
            .setRelativeWidths([view1.relativeWidth(1.0, of: view).withId(expectedId1),
                                view2.relativeWidth(1.0, of: view).withId(expectedId2)])
        
        viewRestraint.isActive = true
        
        let constraint1 = view.constraints[0]
        let constraint2 = view.constraints[1]
        
        XCTAssert(constraint1.identifier == expectedId1, "\(constraint1.identifier!) != \(expectedId1)")
        XCTAssert(constraint1 === viewRestraint.constraintWithId(expectedId1))
        XCTAssert(constraint2.identifier == expectedId2, "\(constraint2.identifier!) != \(expectedId2)")
        XCTAssert(constraint2 === viewRestraint.constraintWithId(expectedId2))
    }
    
    func testScaledHeightIdentifiers() {
        let view1 = UIView(), view2 = UIView()
        let view = UIView()
        
        let expectedId1 = "id1", expectedId2 = "id2"
        
        let viewRestraint = Restraint(view)
            .addItems([view1, view2])
            .setRelativeHeights([view1.relativeHeight(1.0, of: view).withId(expectedId1),
                                 view2.relativeHeight(1.0, of: view).withId(expectedId2)])
        
        viewRestraint.isActive = true
        
        let constraint1 = view.constraints[0]
        let constraint2 = view.constraints[1]
        
        XCTAssert(constraint1.identifier == expectedId1, "\(constraint1.identifier!) != \(expectedId1)")
        XCTAssert(constraint1 === viewRestraint.constraintWithId(expectedId1))
        XCTAssert(constraint2.identifier == expectedId2, "\(constraint2.identifier!) != \(expectedId2)")
        XCTAssert(constraint2 === viewRestraint.constraintWithId(expectedId2))
    }
}
