//
//  UIView+StraitJacketTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 3/14/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest

class UIView_StraitJacketTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWidthFactor() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        let factor: CGFloat = 0.5
        
        let expValue: CGFloat = 50
        
        XCTAssertEqual(view.sWidth(factor), expValue)
    }
    
    func testHeightFactor() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 1000))
        let factor: CGFloat = 0.5
        
        let expValue: CGFloat = 500
        
        XCTAssertEqual(view.sHeight(factor), expValue)
    }
}
