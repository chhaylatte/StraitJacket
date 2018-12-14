//
//  RestraintTargetableExtensions.swift
//  StraitJacket
//
//  Created by Danny Chhay on 10/1/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

extension RestraintTargetable {
    /**
     Returns `RestraintValue` to be used with self as the `RestraintTargetable` and `.equal` as the `NSLayoutRelation.`
     - Parameters:
     - value: The size in points
     - priority: A UILayoutPriority
     */
    public func equal(size value: CGFloat,
                      priority: UILayoutPriority = .required) -> RestraintValue {
        return RestraintValue(self,
                              value: value,
                              relation: .equal,
                              priority: priority)
    }
    
    /**
     Returns `RestraintValue` to be used with self as the `RestraintTargetable` and `.greaterThanOrEqual` as the `NSLayoutRelation.`
     - Parameters:
     - value: The size in points
     - priority: A UILayoutPriority
     */
    public func min(size value: CGFloat,
                    priority: UILayoutPriority = .required) -> RestraintValue {
        return RestraintValue(self,
                              value: value,
                              relation: .greaterThanOrEqual,
                              priority: priority)
    }
    
    /**
     Returns `RestraintValue` to be used with self as the `RestraintTargetable` and `.lessThanOrEqual` as the `NSLayoutRelation.`
     - Parameters:
     - value: The size in points
     - priority: A UILayoutPriority
     */
    public func max(size value: CGFloat,
                    priority: UILayoutPriority = .required) -> RestraintValue {
        return RestraintValue(self,
                              value: value,
                              relation: .lessThanOrEqual,
                              priority: priority)
    }
    
    /**
     Returns `RestraintRelation` struct.
     - Parameters:
     - multiple: The size as a normalized CGFloat
     - view: The target relational view
     - relation: An NSLayoutRelation
     - priority: A UILayoutPriority
     */
    public func multiple(_ multiple: CGFloat,
                         of view: RestraintTargetable,
                         relation: NSLayoutConstraint.Relation = .equal,
                         priority: UILayoutPriority = .required) -> RestraintRelation {
        return RestraintRelation(self,
                                 constant: 0,
                                 multiple: multiple,
                                 of: view,
                                 relation: relation,
                                 priority: priority)
    }
}
