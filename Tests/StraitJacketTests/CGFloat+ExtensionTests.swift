//
//  CGFloat+ExtensionTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 3/14/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import XCTest

class CGFloat_ExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWidthFactor() {
        let screenSize = UIScreen.main.bounds
        let widthFactor: CGFloat = 0.5
        
        let expWidth = screenSize.width * widthFactor
        
        XCTAssertEqual(widthFactor.sWidth, expWidth)
    }
    
    func testHeightFactor() {
        let screenSize = UIScreen.main.bounds
        let heightFactor: CGFloat = 0.25
        
        let expHeight = screenSize.height * heightFactor
        
        XCTAssertEqual(heightFactor.sHeight, expHeight)
    }
}
