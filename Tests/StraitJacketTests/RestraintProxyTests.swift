//
//  RestraintProxyTests.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 11/13/19.
//  Copyright © 2019 Danny Chhay. All rights reserved.
//

import XCTest
@testable import StraitJacket

class RestraintProxyTests: XCTestCase {
    
    let view = UIView()
    
    lazy var proxy = RestraintProxy(view: view)

    override func setUp() {
        proxy = RestraintProxy(view: view)
    }

    func testInitialAnchors() {
        XCTAssert(proxy.bottomAnchor == view.bottomAnchor)
        XCTAssert(proxy.centerXAnchor == view.centerXAnchor)
        XCTAssert(proxy.centerYAnchor == view.centerYAnchor)
        XCTAssert(proxy.heightAnchor == view.heightAnchor)
        XCTAssert(proxy.leadingAnchor == view.leadingAnchor)
        XCTAssert(proxy.leftAnchor == view.leftAnchor)
        XCTAssert(proxy.rightAnchor == view.rightAnchor)
        XCTAssert(proxy.topAnchor == view.topAnchor)
        XCTAssert(proxy.trailingAnchor == view.trailingAnchor)
        XCTAssert(proxy.widthAnchor == view.widthAnchor)
    }
    
    func testProxyTopIsCenterAnchor() {
        proxy.top(is: .centerY)
        XCTAssert(proxy.topAnchor == view.centerYAnchor)
    }
    
    func testProxyBottomIsCenterAnchor() {
        proxy.bottom(is: .centerY)
        XCTAssert(proxy.bottomAnchor == view.centerYAnchor)
    }
    
    func testProxyLeadingIsCenterAnchor() {
        proxy.leading(is: .centerX)
        XCTAssert(proxy.leadingAnchor == view.centerXAnchor)
    }
    
    func testProxyTrailingIsCenterAnchor() {
        proxy.trailing(is: .centerX)
        XCTAssert(proxy.trailingAnchor == view.centerXAnchor)
    }
    
    func testProxyConnectsView() {
        let restraintProxy = view.proxy
        XCTAssert(restraintProxy.proxiedView == view)
    }
}
