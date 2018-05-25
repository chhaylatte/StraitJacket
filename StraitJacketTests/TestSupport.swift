//
//  TestSupport.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 5/24/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation
@testable import StraitJacket

extension Edges: Hashable {
    public var hashValue: Int {
        return rawValue
    }
}

extension Alignment: Hashable {
    public var hashValue: Int {
        return rawValue
    }
}
