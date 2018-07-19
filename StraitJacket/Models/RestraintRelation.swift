//
//  RestraintRelation.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/// Model for a relational modifier between two `UIView`.
public struct RestraintRelation {
    
    public let view0: UIView
    public let view1: UIView
    public let modifier: RestraintModifier
    
    public init (_ sourceView: UIView,
                 constant: CGFloat = 0,
                 multiple: CGFloat,
                 of targetView: UIView,
                 relation: NSLayoutRelation = .equal,
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
    
    init (_ sourceView: UIView,
          targetView: UIView,
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
