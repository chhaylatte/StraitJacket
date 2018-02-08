//
//  UIView+StraitJacket.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public extension UIView {
    
    func addSubviews(_ viewCollections: [UIView]...) {
        for views in viewCollections {
            for view in views {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)
            }
        }
    }
    
    func addSubviews(_ subviews: UIView...) {
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}

extension UIView: Restrainable {
    public func width(_ value: CGFloat,
                      relation: NSLayoutRelation = .equal,
                      priority: UILayoutPriority = .required) -> Width {
        return Width(self,
                     value: value,
                     relation: relation,
                     priority: priority)
    }
    
    public func height(_ value: CGFloat,
                       relation: NSLayoutRelation = .equal,
                       priority: UILayoutPriority = .required) -> Width {
        return Height(self,
                      value: value,
                      relation: relation,
                      priority: priority)
    }
    
    public func relativeWidth(_ multiple: CGFloat,
                              of view: UIView,
                              relation: NSLayoutRelation = .equal,
                              priority: UILayoutPriority = .required) -> RelativeWidth {
        return factor(multiple, of: view, relation: relation, priority: priority)
    }
    
    public func relativeHeight(_ multiple: CGFloat,
                               of view: UIView,
                               relation: NSLayoutRelation = .equal,
                               priority: UILayoutPriority = .required) -> RelativeWidth {
        return factor(multiple, of: view, relation: relation, priority: priority)
    }
    
    public func factor(_ multiple: CGFloat,
                       of view: UIView,
                       relation: NSLayoutRelation,
                       priority: UILayoutPriority) -> RestraintRelation {
        return RestraintRelation(self,
                                 constant: 0,
                                 multiple: multiple,
                                 of: view,
                                 relation: relation,
                                 priority: priority
        )
    }
}
