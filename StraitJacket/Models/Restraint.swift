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
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    public enum GuidePinning {
        case normal
        case soft
    }
    
    public enum GuideYCentering {
        case top
        case bottom
        case centerY
    }
    
    public enum GuideXCentering {
        case left
        case right
        case centerX
    }
    
    // MARK: -
    
    func alignment(with centering: GuideYCentering) -> Alignment {
        switch centering {
        case .top:
            return Alignment.top
        case .bottom:
            return Alignment.bottom
        case .centerY:
            return Alignment.centerY
        }
    }
    
    func alignment(with centering: GuideXCentering) -> Alignment {
        switch centering {
        case .left:
            return Alignment.left
        case .right:
            return Alignment.right
        case .centerX:
            return Alignment.centerX
        }
    }
    
    internal func horizontalEndingAlignment(for pinning: GuidePinning) -> (Alignment, Alignment) {
        switch pinning {
        case .normal:
            return (Alignment.left, Alignment.right)
        case .soft:
            return (Alignment.softLeft, Alignment.softRight)
        }
    }
    
    internal func alignment(for direction: Direction, with pinning: GuidePinning) -> Set<Alignment> {
        switch direction {
        case .horizontal:
            switch pinning {
            case .normal:
                return [Alignment.top, .bottom]
            case .soft:
                return [Alignment.softTop, .softBottom]
            }
        case .vertical:
            switch pinning {
            case .normal:
                return [Alignment.left, .right]
            case .soft:
                return [Alignment.softLeft, .softRight]
            }
        }
    }
    
    // MARK: -
    
    private func horizontalAxisAlignment(for direction: Direction,
                                     pinning: GuidePinning,
                                     centering: GuideYCentering) -> Set<Alignment> {
        var alignmentSet = alignment(for: direction, with: pinning)
        let centerAlignment = alignment(with: centering)
        alignmentSet.insert(centerAlignment)
        
        return alignmentSet
    }
    
    private func chainHorizontally(_ views: [[Restrainable]], spacing: CGFloat = 8) -> Restraint {
        views.forEach { _ = chainHorizontally($0, spacing: spacing) }
        
        return self
    }
    
    private func chainHorizontally(_ restrainableChain: [Restrainable], spacing: CGFloat = 8) -> Restraint {
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
        
        return self
    }
}

public extension Restraint {
    
    // MARK: - Chaining

    /// Creates constraints to define spacing between each element in every views array argument.
    ///
    /// - Parameters:
    ///     - views: The `Restrainable` items to chain
    ///     - spacing: The default spacing between each view
    public func chainHorizontally(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        return chainHorizontally(views, spacing: spacing)
    }
    
    public func chainHorizontally(_ views: [Restrainable],
                                  in guide: UILayoutGuide,
                                  spacing: CGFloat = 8,
                                  pinningOnAxis: GuidePinning = .soft,
                                  pinningOnEnds: GuidePinning = .normal,
                                  centering: GuideYCentering = .centerY) -> Restraint {
        let targetable = views.compactMap { $0 as? RestraintTargetable }
        let axisAlignment = horizontalAxisAlignment(for: .horizontal, pinning: pinningOnAxis, centering: centering)
        let (firstAlignment, lastAlignment) = horizontalEndingAlignment(for: pinningOnEnds)
        
        _ = chainHorizontally(views, spacing: spacing)
        _ = alignItems(targetable, to: axisAlignment, of: guide)
        
        if let first = targetable.first {
            _ = alignItems([first], to: [firstAlignment], of: guide)
        }
        
        if let last = targetable.last {
            _ = alignItems([last], to: [lastAlignment], of: guide)
        }
        
        return self
    }
    
    /// Creates constraints to define spacing between each element in every views array argument.
    ///
    /// - Parameters:
    ///     - views: The `Restrainable` items to chain
    ///     - spacing: The default spacing between each view
    private func chainVertically(_ views: [[Restrainable]], spacing: CGFloat = 8) -> Restraint {
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
    
    public func chainVertically(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        return chainVertically(views, spacing: spacing)
    }
    
    public func chainVertically(_ views: [Restrainable]..., in guide: UILayoutGuide, spacing: CGFloat = 8) -> Restraint {
        _ = chainVertically(views, spacing: spacing)
        views.forEach {
            let targetable = $0.compactMap { $0 as? RestraintTargetable }
            _ = alignItems(targetable, to: [.left, .right], of: guide)
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
