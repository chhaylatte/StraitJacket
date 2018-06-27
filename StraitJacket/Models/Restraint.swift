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
    
    public var isActive: Bool = false {
        didSet {
            isActive
                ? NSLayoutConstraint.activate(constraints)
                : NSLayoutConstraint.deactivate(constraints)
            subRestraints.forEach { $0.isActive = isActive }
            view.setNeedsLayout()
        }
    }
    
    public func addSubviews(_ subviews: UIView...) -> Restraint {
        return addSubviews(subviews)
    }
    
    public func addSubviews(_ subviews: [UIView]) -> Restraint {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        return self
    }
    
    public func addItems(_ items: [RestraintTargetable]) -> Restraint {
        items.forEach {
            $0.addToRootView(view)
        }
        
        return self
    }
}

public extension Restraint {
    
    // MARK: - Chaining
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    public func horizontal(_ views: [Restrainable]...) -> Restraint {
        for restrainableChain in views {
            movingProcess(restrainables: restrainableChain, buildConstraint: { (v0, v1, modifiers) in
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
        }
        
        return self
    }
    
    public func vertical(_ views: [Restrainable]...) -> Restraint {
        for restrainableChain in views {
            movingProcess(restrainables: restrainableChain, buildConstraint: { (v0, v1, modifiers) in
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
    
    public func widths(_ values: [Width]...) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .width, v0: view, modifier: modifier)
            constraints.append(aConstraint)
        }
        
        return self
    }
    
    public func heights(_ values: [Height]...) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .height, v0: view, modifier: modifier)
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
    
    public func aligns(_ views: [RestraintTargetable], sides: Edges) -> Restraint {
        return aligns(views, sides: sides, to: self.view)
    }
    
    internal func aligns(_ views: [RestraintTargetable], sides: Edges, to target: RestraintTargetable) -> Restraint {
        let restraintValues = views.map { RestraintValue($0, value: 0) }
        process(restraintValues: [restraintValues], buildConstraint: { (view, modifier) in
            let someConstraints = modifiedAlignmentConstraint(for: view , sides: sides, v1: target, modifier: modifier)
            constraints.append(contentsOf: someConstraints)
        })
        
        return self
    }
    
    internal func aligns(_ views: [UIView], with alignment: Alignment, to target: RestraintTargetable) -> Restraint {
        let restraintValues = views.map { RestraintValue($0, value: 0) }
        process(restraintValues: [restraintValues], buildConstraint: { (view, modifier) in
            let someConstraints = alignment.modifiedAlignmentConstraints(forSource: view, target: target, modifier: modifier)
            constraints.append(contentsOf: someConstraints)
        })
        
        return self
    }
}

internal extension Restraint {
    
    // MARK: - Processing
    
    func process(restraintRelations: [[RestraintRelation]],
                 buildConstraint: (UIView, UIView, RestraintModifier) -> Void) {
        for relations in restraintRelations {
            for relation in relations {
                buildConstraint(relation.view0, relation.view1, relation.modifier)
            }
        }
    }
    
    func process(restraintValues: [[RestraintValue]],
                 buildConstraint: (RestraintTargetable, RestraintModifier) -> Void) {
        
        for values in restraintValues {
            for value in values {
                buildConstraint(value.view, value.modifier)
            }
        }
    }
    
    func movingProcess(restrainables: [Restrainable],
                       buildConstraint: (RestraintTargetable, RestraintTargetable, [RestraintModifier]) -> Void) {
        
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
                buildConstraint(view0, view1, restraintModifiers)
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
        
        return aConstraint
    }
    
    private func modifiedAlignmentConstraint(for v0: RestraintTargetable, sides: Edges, v1: RestraintTargetable, modifier: RestraintModifier) -> [NSLayoutConstraint] {
        let aConstraint: [NSLayoutConstraint] = {
            var constraints: [NSLayoutConstraint] = []
            
            if sides.contains(.top) {
                let constraintFunc = Restraint.constraintFunction(v0.topAnchor, relation: modifier.relation)
                constraints.append(constraintFunc(v1.topAnchor, modifier.value))
            }
            
            if sides.contains(.bottom) {
                let constraintFunc = Restraint.constraintFunction(v0.bottomAnchor, relation: modifier.relation)
                constraints.append(constraintFunc(v1.bottomAnchor, modifier.value))
            }
            
            if sides.contains(.left) {
                let constraintFunc = Restraint.constraintFunction(v0.leftAnchor, relation: modifier.relation)
                constraints.append(constraintFunc(v1.leftAnchor, modifier.value))
            }
            
            if sides.contains(.right) {
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: modifier.relation)
                constraints.append(constraintFunc(v1.rightAnchor, modifier.value))
            }
            
            return constraints
        }()
        
        constraints.forEach { $0.priority = modifier.priority }
        
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
}
