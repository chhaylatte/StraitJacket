//
//  RestraintValue.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/// Model for a modifier for a single `RestraintTargetable`.
public struct RestraintValue {
    
    public let view: RestraintTargetable
    public let modifier: RestraintModifier
    
    public init (_ view: RestraintTargetable,
                 value: CGFloat,
                 relation: NSLayoutRelation = .equal,
                 priority: UILayoutPriority = .required) {
        self.view = view
        modifier = RestraintModifier(value, relation: relation, priority: priority)
    }
}
