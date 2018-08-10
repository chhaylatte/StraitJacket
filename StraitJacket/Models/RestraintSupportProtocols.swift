//
//  RestraintSupportProtocols.swift
//  StraitJacket
//
//  Created by Danny Chhay on 5/24/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/// A type used by `Restraint`
public protocol Restrainable {}


/// A constraint targettable type used by the `Restraint`
public protocol RestraintTargetable: class, Restrainable {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    
    func addToRootView(_ view: UIView)
}

extension UILayoutGuide: RestraintTargetable {
    public func addToRootView(_ view: UIView) {
        view.addLayoutGuide(self)
    }
}

extension UIView: RestraintTargetable {
    public func addToRootView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
    }
}

extension RestraintTargetable {
    /**
     Returns `Width` to be used with `Restraint.setWidths`
     - Parameters:
         - value: The width in points
         - relation: An NSLayoutRelation
         - priority: A UILayoutPriority
     */
    public func width(_ value: CGFloat,
                      relation: NSLayoutRelation = .equal,
                      priority: UILayoutPriority = .required) -> Width {
        return Width(self,
                     value: value,
                     relation: relation,
                     priority: priority)
    }
    
    /**
     Returns `Height` to be used with `Restraint.setWidths`
     - Parameters:
         - value: The height in points
         - relation: An NSLayoutRelation
         - priority: A UILayoutPriority
     */
    public func height(_ value: CGFloat,
                       relation: NSLayoutRelation = .equal,
                       priority: UILayoutPriority = .required) -> Height {
        return Height(self,
                      value: value,
                      relation: relation,
                      priority: priority)
    }
    
    /**
     Returns `RelateiveWidth` to be used with `Restraint.setRelativeWidths`
     - Parameters:
         - multiple: The width as a normalized CGFloat
         - view: The target relational view
         - relation: An NSLayoutRelation
         - priority: A UILayoutPriority
     */
    public func relativeWidth(_ multiple: CGFloat,
                              of view: RestraintTargetable,
                              relation: NSLayoutRelation = .equal,
                              priority: UILayoutPriority = .required) -> RelativeWidth {
        return factor(multiple, of: view, relation: relation, priority: priority)
    }
    
    /**
     Returns `RelateiveWidth` to be used with Restraint.setRelativeWidths
     - Parameters:
         - multiple: The width as a normalized CGFloat
         - view: The target relational view
         - relation: An NSLayoutRelation
         - priority: A UILayoutPriority
     */
    public func relativeHeight(_ multiple: CGFloat,
                               of view: RestraintTargetable,
                               relation: NSLayoutRelation = .equal,
                               priority: UILayoutPriority = .required) -> RelativeHeight {
        return factor(multiple, of: view, relation: relation, priority: priority)
    }
    
    internal func factor(_ multiple: CGFloat,
                       of view: RestraintTargetable,
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
