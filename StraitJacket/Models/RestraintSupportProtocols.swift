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
     Returns `RestraintValue` to be used with self as the `RestraintTargetable` and `.equal` as the `NSLayoutRelation.`
     - Parameters:
     - value: The size in points
     - priority: A UILayoutPriority
     */
    public func equal(_ value: CGFloat,
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
    public func min(_ value: CGFloat,
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
    public func max(_ value: CGFloat,
                    priority: UILayoutPriority = .required) -> RestraintValue {
        return RestraintValue(self,
                              value: value,
                              relation: .lessThanOrEqual,
                              priority: priority)
    }
    
    /**
     Returns `RelateiveWidth` to be used with `Restraint.setRelativeWidths`
     - Parameters:
         - multiple: The size as a normalized CGFloat
         - view: The target relational view
         - relation: An NSLayoutRelation
         - priority: A UILayoutPriority
     */
    public func multiple(_ multiple: CGFloat,
                         of view: RestraintTargetable,
                         relation: NSLayoutRelation = .equal,
                         priority: UILayoutPriority = .required) -> RestraintRelation {
        return RestraintRelation(self,
                                 constant: 0,
                                 multiple: multiple,
                                 of: view,
                                 relation: relation,
                                 priority: priority)
    }
}
