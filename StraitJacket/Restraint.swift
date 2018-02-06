//
//  Restraint.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public protocol Restrainable {}

public struct RestraintRelation: Restrainable {
    
    public let view0: UIView
    public let view1: UIView
    public let modifier: RestraintModifier
    
    public init (_ sourceView: UIView,
                 constant: CGFloat = 0,
                 multiple: CGFloat,
                 of targetView: UIView,
                 relation: NSLayoutRelation = .equal,
                 priority: UILayoutPriority = .required) {
        view0 = sourceView
        view1 = targetView
        modifier = RestraintModifier(constant,
                                     multiple: multiple,
                                     relation: relation,
                                     priority: priority)
    }
}

public struct RestraintValue: Restrainable {
    
    public let view: UIView
    public let modifier: RestraintModifier
    
    public init (_ view: UIView,
                 value: CGFloat,
                 relation: NSLayoutRelation = .equal,
                 priority: UILayoutPriority = .required) {
        self.view = view
        modifier = RestraintModifier(value, relation: relation, priority: priority)
    }
}

public struct RestraintModifier: Restrainable, CustomStringConvertible {
    public init(_ constant: CGFloat,
                multiple: CGFloat = 1,
                relation: NSLayoutRelation = .equal,
                priority: UILayoutPriority = .required) {
        self.value = constant
        self.multiple = multiple
        self.relation = relation
        self.priority = priority
    }
    
    public let value: CGFloat
    public let multiple: CGFloat
    public let relation: NSLayoutRelation
    public let priority: UILayoutPriority
    
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
}

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
}

public extension Restraint {
    enum Direction {
        case horizontal
        case vertical
    }
    
    public func horizontal(_ views: [Restrainable]...) -> Restraint {
        movingProcess(restrainables: views, buildConstraint: { (v0, v1, modifiers) in
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
        movingProcess(restrainables: views, buildConstraint: { (v0, v1, modifiers) in
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

public extension Restraint {
    
    enum Size {
        case width
        case height
    }
    
    public func widths(_ values: [Width]...) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .width, v0: view, modifier: modifier)
            constraints.append(aConstraint)
        }
        
        return self
    }
    
    public func heights(_ values: [Height]...) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .width, v0: view, modifier: modifier)
            constraints.append(aConstraint)
        }
        
        return self
    }
    
    public func relativeWidths(_ relations: [RelativeWidth]...) -> Restraint {
        process(restraintRelations: relations) { (v0, v1, modifier) in
            let aConstraint = modifiedRelativeSizeConstraint(for: .width, v0: v0, v1: v1, modifier: modifier)
            constraints.append(aConstraint)
        }
        
        return self
    }
    
    public func relativeHeights(_ relations: [RelativeHeight]...) -> Restraint {
        process(restraintRelations: relations) { (v0, v1, modifier) in
            let aConstraint = modifiedRelativeSizeConstraint(for: .height, v0: v0, v1: v1, modifier: modifier)
            constraints.append(aConstraint)
        }
        
        return self
    }
}

fileprivate extension Restraint {
    func process(restraintRelations: [[RestraintRelation]],
                 buildConstraint: (UIView, UIView, RestraintModifier) -> Void) {
        for relations in restraintRelations {
            for relation in relations {
                buildConstraint(relation.view0, relation.view1, relation.modifier)
            }
        }
    }
    
    func process(restraintValues: [[RestraintValue]],
                 buildConstraint: (UIView, RestraintModifier) -> Void) {
        
        for values in restraintValues {
            for value in values {
                buildConstraint(value.view, value.modifier)
            }
        }
    }
    
    func movingProcess(restrainables: [[Restrainable]],
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
    
    private func modifiedRelativeSizeConstraint(for size: Size, v0: UIView, v1: UIView, modifier: RestraintModifier) -> NSLayoutConstraint {
        let aConstraint: NSLayoutConstraint = {
            switch size {
            case .width:
                switch modifier.relation {
                case .equal:
                    return v0.widthAnchor.constraint(equalTo: v1.widthAnchor, multiplier: modifier.multiple, constant: modifier.value)
                case .lessThanOrEqual:
                    return v0.widthAnchor.constraint(lessThanOrEqualTo: v1.widthAnchor, multiplier: modifier.multiple, constant: modifier.value)
                case .greaterThanOrEqual:
                    return v0.widthAnchor.constraint(greaterThanOrEqualTo: v1.widthAnchor, multiplier: modifier.multiple, constant: modifier.value)
                }
            case .height:
                switch modifier.relation {
                case .equal:
                    return v0.heightAnchor.constraint(equalTo: v1.heightAnchor, multiplier: modifier.multiple, constant: modifier.value)
                case .lessThanOrEqual:
                    return v0.heightAnchor.constraint(lessThanOrEqualTo: v1.heightAnchor, multiplier: modifier.multiple, constant: modifier.value)
                case .greaterThanOrEqual:
                    return v0.heightAnchor.constraint(greaterThanOrEqualTo: v1.heightAnchor, multiplier: modifier.multiple, constant: modifier.value)
                }
            }
        }()
        aConstraint.priority = modifier.priority
        
        return aConstraint
    }
    
    private func modifiedSizeConstraint(for size: Size, v0: UIView, modifier: RestraintModifier) -> NSLayoutConstraint {
        let aConstraint: NSLayoutConstraint = {
            switch size {
            case .width:
                switch modifier.relation {
                case .equal:
                    return v0.widthAnchor.constraint(equalToConstant: modifier.value)
                case .lessThanOrEqual:
                    return v0.widthAnchor.constraint(lessThanOrEqualToConstant: modifier.value)
                case .greaterThanOrEqual:
                    return v0.widthAnchor.constraint(greaterThanOrEqualToConstant: modifier.value)
                }
            case .height:
                switch modifier.relation {
                case .equal:
                    return v0.heightAnchor.constraint(equalToConstant: modifier.value)
                case .lessThanOrEqual:
                    return v0.heightAnchor.constraint(lessThanOrEqualToConstant: modifier.value)
                case .greaterThanOrEqual:
                    return v0.heightAnchor.constraint(greaterThanOrEqualToConstant: modifier.value)
                }
            }
        }()
        aConstraint.priority = modifier.priority
        
        return aConstraint
    }
}
