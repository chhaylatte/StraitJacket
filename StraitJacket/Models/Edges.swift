//
//  Edges.swift
//  StraitJacket
//
//  Created by Danny Chhay on 5/24/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public struct Edges: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = Edges(rawValue: 1 << 0)
    public static let bottom = Edges(rawValue: 1 << 1)
    public static let left = Edges(rawValue: 1 << 2)
    public static let right = Edges(rawValue: 1 << 3)
    
    public static let all: Edges = [.top, .bottom, .left, .right]
    public static let vertical: Edges = [.top, .bottom]
    public static let horizontal: Edges = [.left, .right]
}
