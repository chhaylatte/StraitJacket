//
//  RestraintModifier.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation
import UIKit

/// Model for constraint properties.  Modeled after the properties of `UILayoutConstraint`.
public struct RestraintModifier: Restrainable, CustomStringConvertible {
    public var value: CGFloat
    public var multiple: CGFloat
    public var relation: NSLayoutConstraint.Relation
    public var priority: UILayoutPriority
    
    /// An optional user identifier.  `Restraint` associates this identifier with its generated constraint.
    public var identifier: String?
    
    public init(_ constant: CGFloat,
                multiple: CGFloat = 1,
                relation: NSLayoutConstraint.Relation = .equal,
                priority: UILayoutPriority = .required,
                identifier: String? = nil) {
        self.value = constant
        self.multiple = multiple
        self.relation = relation
        self.priority = priority
        self.identifier = identifier
    }
    
    public var description: String {
        let identifierString: String = {
            guard let identifier = identifier else { return "" }
            return "." + identifier
        }()

        return "RestraintModifier\(identifierString)(\(relationString) *\(multiple) + \(value) @ \(priority.rawValue))"
    }
    
    private var relationString: String {
        switch relation {
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        @unknown default:
            return "??"
        }
    }
    
    public func withId(_ identifier: String) -> RestraintModifier {
        return RestraintModifier(value, multiple: multiple, relation: relation, priority: priority, identifier: identifier)
    }
}
