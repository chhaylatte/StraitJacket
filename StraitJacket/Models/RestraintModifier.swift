//
//  RestraintModifier.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public struct RestraintModifier: Restrainable, CustomStringConvertible {
    public init(_ constant: CGFloat,
                multiple: CGFloat = 1,
                relation: NSLayoutRelation = .equal,
                priority: UILayoutPriority = .required) {
        self.value = constant
        self.multiple = multiple
        self.relation = relation
        self.priority = priority
    }
    
    public let value: CGFloat
    public let multiple: CGFloat
    public let relation: NSLayoutRelation
    public let priority: UILayoutPriority
    
    public var description: String {
        return "Modifier(\(relationString) \(value) @ \(priority.rawValue))"
    }
    
    private var relationString: String {
        switch relation {
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        }
    }
}
