//
//  RestraintRelation.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/// Model for a relational modifier for building a constraint between two `RestraintTargetable`.
public struct RestraintRelation {
    
    public let view0: RestraintTargetable
    public let view1: RestraintTargetable
    public let modifier: RestraintModifier
    
    public init (_ sourceView: RestraintTargetable,
                 constant: CGFloat = 0,
                 multiple: CGFloat,
                 of targetView: RestraintTargetable,
                 relation: NSLayoutConstraint.Relation = .equal,
                 priority: UILayoutPriority = .required,
                 identifier: String? = nil) {
        view0 = sourceView
        view1 = targetView
        modifier = RestraintModifier(constant,
                                     multiple: multiple,
                                     relation: relation,
                                     priority: priority,
                                     identifier: identifier)
    }
    
    init (_ sourceView: RestraintTargetable,
          targetView: RestraintTargetable,
          modifier: RestraintModifier) {
        view0 = sourceView
        view1 = targetView
        self.modifier = modifier
    }
    
    public func withId(_ identifier: String) -> RestraintRelation {
        var newModifier = modifier
        newModifier.identifier = identifier
        
        return RestraintRelation(view0, targetView: view1, modifier: newModifier)
    }
}
