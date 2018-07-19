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
    }
    
    private(set) weak var view: T!
    
    internal(set) var constraints: [NSLayoutConstraint] = []
    private(set) var subRestraints: [Restraint] = []
    internal var identifierToCostraint: [String: NSLayoutConstraint] = [:]
    
    public func activate() {
        NSLayoutConstraint.activate(constraints)
        subRestraints.forEach { $0.activate() }
        view.setNeedsLayout()
    }
    
    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
        subRestraints.forEach { $0.deactivate() }
        view.setNeedsLayout()
    }
    
    public func addItems(_ items: [RestraintTargetable]) -> Restraint {
        items.forEach {
            $0.addToRootView(view)
        }
        
        return self
    }
    
    public func addRestraints(_ subRestraints: [Restraint]) -> Restraint {
        self.subRestraints.append(contentsOf: subRestraints)
        
        return self
    }
    
    public func constraintWithId(_ id: String) -> NSLayoutConstraint? {
        return identifierToCostraint[id]
    }
}

public extension Restraint {
    
    // MARK: - Aligning
    
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
    
    // MARK: - Sizing
    
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
        let axisAlignmentSet = horizontalAxisAlignment(for: pinningOnAxis, centering: centering)
        let (firstAlignment, lastAlignment) = horizontalEndingAlignment(for: pinningOnEnds)
        
        _ = chainHorizontally(views, spacing: spacing)
        _ = alignItems(targetable, to: axisAlignmentSet, of: guide)
        
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
    public func chainVertically(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        return chainVertically(views, spacing: spacing)
    }
    
    public func chainVertically(_ views: [Restrainable],
                                in guide: UILayoutGuide,
                                spacing: CGFloat = 8,
                                pinningOnAxis: GuidePinning = .soft,
                                pinningOnEnds: GuidePinning = .normal,
                                centering: GuideXCentering = .centerX) -> Restraint {
        let targetable = views.compactMap { $0 as? RestraintTargetable }
        let axisAlignmentSet = verticalAxisAlignment(for: pinningOnAxis, centering: centering)
        let (firstAlignment, lastAlignment) = verticalEndingAlignment(for: pinningOnEnds)
        
        _ = chainVertically(views, spacing: spacing)
        _ = alignItems(targetable, to: axisAlignmentSet, of: guide)
        
        if let first = targetable.first {
            _ = alignItems([first], to: [firstAlignment], of: guide)
        }
        
        if let last = targetable.last {
            _ = alignItems([last], to: [lastAlignment], of: guide)
        }
        
        return self
    }
}

extension Restraint {
    // MARK: - Private
    
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
    
    private func chainVertically(_ views: [[Restrainable]], spacing: CGFloat = 8) -> Restraint {
        views.forEach { _ = chainVertically($0, spacing: spacing) }
        
        return self
    }
    
    private func chainVertically(_ restrainableChain: [Restrainable], spacing: CGFloat = 8) -> Restraint {
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
        
        return self
    }
}
