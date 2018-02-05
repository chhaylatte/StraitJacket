//
//  Restraint.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public protocol Restrainable {}

extension UIView: Restrainable {}

public struct RestraintModifier: Restrainable, CustomStringConvertible {
    public init(_ value: CGFloat,
                relation: NSLayoutRelation = .equal,
                priority: UILayoutPriority = .required) {
        self.value = value
        self.relation = relation
        self.priority = priority
    }
    
    public let value: CGFloat
    public let relation: NSLayoutRelation
    public let priority: UILayoutPriority
    
    public var description: String {
        return "Space(\(relationString) \(value) @ \(priority.rawValue))"
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

typealias Space = RestraintModifier

public class Restraint<T: UIView> {
    public init(_ view: T, subRestraints: [Restraint] = []) {
        self.view = view
        self.subRestraints = subRestraints
    }
    
    private(set) weak var view: T!
    
    private(set) var constraints: [NSLayoutConstraint] = []
    private(set) var subRestraints: [Restraint] = []
    
    public var isActive: Bool = false {
        didSet {
            isActive
                ? NSLayoutConstraint.activate(constraints)
                : NSLayoutConstraint.deactivate(constraints)
            subRestraints.forEach { $0.isActive = isActive }
        }
    }
    
    enum Direction {
        case vertical
        case horizontal
    }
    
    public func horizontal(_ views: [Restrainable]...) -> Restraint {
        chain(restrainables: views, buildConstraint: { (v0, v1, modifiers) in
            if modifiers.isEmpty {
                let aConstraint = v0.leadingAnchor.constraint(equalTo: v1.trailingAnchor)
                constraints.append(aConstraint)
            } else {
                for modifier in modifiers {
                    let aConstraint = modifiedChainConstraint(for: .horizontal, v0: v0, v1: v1, modifier: modifier)
                    constraints.append(aConstraint)
                }
            }
        })
        
        return self
    }
    
    public func vertical(_ views: [Restrainable]...) -> Restraint {
        chain(restrainables: views, buildConstraint: { (v0, v1, modifiers) in
            if modifiers.isEmpty {
                let aConstraint = v0.topAnchor.constraint(equalTo: v1.bottomAnchor)
                constraints.append(aConstraint)
            } else {
                for modifier in modifiers {
                    let aConstraint = modifiedChainConstraint(for: .vertical, v0: v0, v1: v1, modifier: modifier)
                    constraints.append(aConstraint)
                }
            }
        })
        
        return self
    }
}

fileprivate extension Restraint {
    func chain(restrainables: [[Restrainable]],
               buildConstraint: (UIView, UIView, [RestraintModifier]) -> Void) {
        
        var restraintModifiers: [RestraintModifier] = []
        
        for restrainableChain in restrainables {
            var (view0, view1): (UIView?, UIView?) = (nil, nil)
            for restrainable in restrainableChain {
                let view = restrainable as? UIView
                
                view0 = view
                
                if let modifier = restrainable as? RestraintModifier {
                    assert(view1 != nil, "Malformed restrainable chain: \(restrainableChain)")
                    restraintModifiers.append(modifier)
                }
                
                if let view0 = view0, let view1 = view1 {
                    buildConstraint(view0, view1, restraintModifiers)
                    restraintModifiers.removeAll()
                }
                
                if view != nil {
                    view1 = view0
                }
            }
        }
    }
    
    private func modifiedChainConstraint(for direction: Direction, v0: UIView, v1: UIView, modifier: RestraintModifier) -> NSLayoutConstraint {
        let aConstraint: NSLayoutConstraint = {
            switch direction {
            case .vertical:
                switch modifier.relation {
                case .equal:
                    return v0.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: modifier.value)
                case .lessThanOrEqual:
                    return v0.topAnchor.constraint(lessThanOrEqualTo: v1.bottomAnchor, constant: modifier.value)
                case .greaterThanOrEqual:
                    return v0.topAnchor.constraint(greaterThanOrEqualTo: v1.bottomAnchor, constant: modifier.value)
                }
            case .horizontal:
                switch modifier.relation {
                case .equal:
                    return v0.leadingAnchor.constraint(equalTo: v1.trailingAnchor, constant: modifier.value)
                case .lessThanOrEqual:
                    return v0.leadingAnchor.constraint(lessThanOrEqualTo: v1.trailingAnchor, constant: modifier.value)
                case .greaterThanOrEqual:
                    return v0.leadingAnchor.constraint(greaterThanOrEqualTo: v1.trailingAnchor, constant: modifier.value)
                }
            }
        }()
        aConstraint.priority = modifier.priority
        
        return aConstraint
    }
}
