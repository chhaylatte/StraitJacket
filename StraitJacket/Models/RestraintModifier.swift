//
//  RestraintModifier.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/// Model for constraint properties.
public struct RestraintModifier: Restrainable, CustomStringConvertible {
    public let value: CGFloat
    public let multiple: CGFloat
    public let relation: NSLayoutRelation
    public let priority: UILayoutPriority
    
    /// An optional user identifier.  `Restraint` associates this identifier with its generated constraint.
    public var identifier: String?
    
    public init(_ constant: CGFloat,
                multiple: CGFloat = 1,
                relation: NSLayoutRelation = .equal,
                priority: UILayoutPriority = .required,
                identifier: String? = nil) {
        self.value = constant
        self.multiple = multiple
        self.relation = relation
        self.priority = priority
        self.identifier = identifier
    }
    
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
    
    func withId(_ identifier: String) -> RestraintModifier {
        return RestraintModifier(value, multiple: multiple, relation: relation, priority: priority, identifier: identifier)
    }
}
