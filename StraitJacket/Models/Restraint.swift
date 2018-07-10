//
//  Restraint.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

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

public class Restraint<T: UIView> {
    public init(_ view: T, subRestraints: [Restraint] = []) {
        self.view = view
        self.subRestraints = subRestraints
    }
    
    private(set) weak var view: T!
    
    private(set) var constraints: [NSLayoutConstraint] = []
    private(set) var subRestraints: [Restraint] = []
    private var identifierToCostraint: [String: NSLayoutConstraint] = [:]
    
    public var isActive: Bool = false {
        didSet {
            isActive
                ? NSLayoutConstraint.activate(constraints)
                : NSLayoutConstraint.deactivate(constraints)
            subRestraints.forEach { $0.isActive = isActive }
            view.setNeedsLayout()
        }
    }
    
    public func addItems(_ items: [RestraintTargetable]) -> Restraint {
        items.forEach {
            $0.addToRootView(view)
        }
        
        return self
    }
    
    public func constraintWithId(_ id: String) -> NSLayoutConstraint? {
        return identifierToCostraint[id]
    }
}

public extension Restraint {
    
    // MARK: - Chaining
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    /// Creates constraints to define spacing between each element in every views array argument.
    ///
    /// - Parameters:
    ///     - views: The `Restrainable` items to chain
    ///     - spacing: The default spacing between each view
    public func chainHorizontally(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        for restrainableChain in views {
            movingProcess(restrainables: restrainableChain, buildConstraints: { (v0, v1, modifiers) in
                var builtConstraints: [NSLayoutConstraint] = []
                
                if modifiers.isEmpty {
                    let aConstraint = v0.leadingAnchor.constraint(equalTo: v1.trailingAnchor, constant: spacing)
                    builtConstraints.append(aConstraint)
                } else {
                    
                    for modifier in modifiers {
                        let aConstraint = modifiedChainConstraint(for: .horizontal, v0: v0, v1: v1, modifier: modifier)
                        builtConstraints.append(aConstraint)
                    }
                }
                
                return builtConstraints
            })
        }
        
        return self
    }
    
    /// Creates constraints to define spacing between each element in every views array argument.
    ///
    /// - Parameters:
    ///     - views: The `Restrainable` items to chain
    ///     - spacing: The default spacing between each view
    public func chainVertically(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        for restrainableChain in views {
            movingProcess(restrainables: restrainableChain, buildConstraints: { (v0, v1, modifiers) in
                var builtConstraints: [NSLayoutConstraint] = []
                
                if modifiers.isEmpty {
                    let aConstraint = v0.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: spacing)
                    builtConstraints.append(aConstraint)
                } else {
                    for modifier in modifiers {
                        let aConstraint = modifiedChainConstraint(for: .vertical, v0: v0, v1: v1, modifier: modifier)
                        builtConstraints.append(aConstraint)
                    }
                }
                
                return builtConstraints
            })
        }
        
        return self
    }
}

public extension Restraint {
    
    // MARK: - Sizing
    
    enum Size {
        case width
        case height
    }
    
    public func setWidths(_ values: [Width]...) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .width, v0: view, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    public func setHeights(_ values: [Height]...) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .height, v0: view, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    public func setRelativeWidths(_ relations: [RelativeWidth]...) -> Restraint {
        process(restraintRelations: relations) { (v0, v1, modifier) in
            let aConstraint = modifiedRelativeSizeConstraint(for: .width, v0: v0, v1: v1, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    public func setRelativeHeights(_ relations: [RelativeHeight]...) -> Restraint {
        process(restraintRelations: relations) { (v0, v1, modifier) in
            let aConstraint = modifiedRelativeSizeConstraint(for: .height, v0: v0, v1: v1, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    public func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>, of target: RestraintTargetable) -> Restraint {
        let restraintValues = views.map { RestraintValue($0, value: 0) }
        process(restraintValues: [restraintValues], buildConstraints: { (view, modifier) in
            return Array(alignment).map { $0.modifiedAlignmentConstraint(forSource: view, target: target, modifier: modifier) }
        })
        
        return self
    }
    
    public func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>) -> Restraint {
        return alignItems(views, to: alignment, of: self.view)
    }
}

internal extension Restraint {
    
    // MARK: - Processing
    
    func process(restraintRelations: [[RestraintRelation]],
                 buildConstraints: (RestraintTargetable, RestraintTargetable, RestraintModifier) -> [NSLayoutConstraint]) {
        for relations in restraintRelations {
            for relation in relations {
                let builtConstraints = buildConstraints(relation.view0, relation.view1, relation.modifier)
                builtConstraints.forEach { didBuildConstraint($0) }
            }
        }
    }
    
    func process(restraintValues: [[RestraintValue]],
                 buildConstraints: (RestraintTargetable, RestraintModifier) -> [NSLayoutConstraint]) {
        
        for values in restraintValues {
            for value in values {
                let builtConstraints = buildConstraints(value.view, value.modifier)
                builtConstraints.forEach { didBuildConstraint($0) }
            }
        }
    }
    
    func movingProcess(restrainables: [Restrainable],
                       buildConstraints: (RestraintTargetable, RestraintTargetable, [RestraintModifier]) -> [NSLayoutConstraint]) {
        
        var restraintModifiers: [RestraintModifier] = []
        var (view0, view1): (RestraintTargetable?, RestraintTargetable?) = (nil, nil)
        for restrainable in restrainables {
            let view = restrainable as? RestraintTargetable
            view0 = view
            
            if let modifier = restrainable as? RestraintModifier {
                assert(view1 != nil, "Malformed restrainable chain: \(restrainables)")
                restraintModifiers.append(modifier)
            }
            
            if let view0 = view0, let view1 = view1 {
                let builtConstraints = buildConstraints(view0, view1, restraintModifiers)
                builtConstraints.forEach { didBuildConstraint($0) }
                restraintModifiers.removeAll()
            }
            
            if view != nil {
                view1 = view0
            }
        }
    }
    
    // MARK: - Constraint Building
    
    private func modifiedChainConstraint(for direction: Direction, v0: RestraintTargetable, v1: RestraintTargetable, modifier: RestraintModifier) -> NSLayoutConstraint {
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
        aConstraint.identifier = modifier.identifier
        
        return aConstraint
    }
    
    private func modifiedRelativeSizeConstraint(for size: Size, v0: RestraintTargetable, v1: RestraintTargetable, modifier: RestraintModifier) -> NSLayoutConstraint {
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
        aConstraint.identifier = modifier.identifier
        
        return aConstraint
    }
    
    private func modifiedSizeConstraint(for size: Size, v0: RestraintTargetable, modifier: RestraintModifier) -> NSLayoutConstraint {
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
        aConstraint.identifier = modifier.identifier
        
        return aConstraint
    }
        
    static func constraintFunction<AnchorType>(_ anchor: NSLayoutAnchor<AnchorType>,
                                                relation: NSLayoutRelation) -> (NSLayoutAnchor<AnchorType>, CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return anchor.constraint(equalTo:constant:)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo:constant:)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo:constant:)
        }
    }
    
    func didBuildConstraint(_ constraint: NSLayoutConstraint) {
        constraints.append(constraint)
        
        guard let identifier = constraint.identifier else { return }
        
        assert(!identifierToCostraint.keys.contains(identifier), "Identifier must be unique: \(identifier)")
        identifierToCostraint[identifier] = constraint
    }
}
