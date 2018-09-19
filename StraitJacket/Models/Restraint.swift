//
//  Restraint.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public class Restraint<T: UIView> {
    
    /**
     - Parameters:
         - view: The root view.
         - subRestraints: Child `Restraint` objects.  `Restraint` can be composed and activated in at the same time when added as to `subRestraints`.
     */
    public init(_ view: T, subRestraints: [Restraint] = []) {
        self.view = view
    }
    
    private(set) weak var view: T!
    
    internal(set) var constraints: [NSLayoutConstraint] = []
    private(set) var subRestraints: [Restraint] = []
    internal var identifierToCostraint: [String: NSLayoutConstraint] = [:]
    
    /// Activates its constraints and `subSubrestraints`.  Also calls setNeedsLayout on its root view.
    public func activate() {
        NSLayoutConstraint.activate(constraints)
        subRestraints.forEach { $0.activate() }
        view.setNeedsLayout()
    }
    
    /// Deactivates its constraints and `subSubrestraints`.  Also calls setNeedsLayout on its root view.
    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
        subRestraints.forEach { $0.deactivate() }
        view.setNeedsLayout()
    }
    
    /// Returns all constraints on `Restraint` including all constraints in `subRestraints`
    public func totalConstraints() -> [NSLayoutConstraint] {
        let subConstraints = subRestraints
            .map { $0.constraints }
            .reduce([]) { (result, additionalConstraints) -> [NSLayoutConstraint] in
                return result + additionalConstraints
        }
        
        return constraints + subConstraints
    }
    
    /**
     Activates `newRestraint` while deactivating `oldRestraints`.  This method skips deactivating constraints that are active in `newRestraint`.
     - Parameters:
         - newRestraints: The new `Restraint` object to activate.
         - oldRestraints: The old `Restraint` object to deactivate.
     */
    public static func activate(_ newRestraints: Restraint, andDeactivate oldRestraints: Restraint) {
        let newConstraints = Set(newRestraints.totalConstraints())
        let oldConstraints = Set(oldRestraints.totalConstraints())
        
        let deactivatedConstraintsSet = oldConstraints.subtracting(newConstraints)
        let activatedConstraintsSet = newConstraints.subtracting(oldConstraints)
        
        let deactivatedConstraints = Array(deactivatedConstraintsSet)
        let activatedConstraints = Array(activatedConstraintsSet)
        
        NSLayoutConstraint.deactivate(deactivatedConstraints)
        NSLayoutConstraint.activate(activatedConstraints)
    }
    
    /**
     Adds such as `UIView` to the root view.
     - Parameters:
         - items: A list of `RestraintTargetable` items.
     */
    @discardableResult
    public func addItems(_ items: RestraintTargetable...) -> Restraint {
        items.forEach {
            $0.addToRootView(view)
        }
        
        return self
    }
    
    /**
     Adds a `Restraint` object to `subRestraints`
     - Parameters:
         - subRestraints: An array of `Restraint` objects.
     */
    @discardableResult
    public func addRestraints(_ subRestraints: [Restraint]) -> Restraint {
        self.subRestraints.append(contentsOf: subRestraints)
        
        return self
    }
    
    /**
     Adds `NSLayoutConstraint`s to be used by `Restraint`.  Constraints are not automatically activated.
     - Parameters:
         - constraints: A collection of `NSLayoutConstraint`.
     */
    @discardableResult
    public func addConstraints(_ constraints: [NSLayoutConstraint]) -> Restraint {
        self.constraints.append(contentsOf: constraints)
        
        return self
    }
    
    /**
     Removes `NSLayoutConstraint`s from `Restraint`.  Constraints are automatically deactivated.
     - Parameters:
         - constraints: A collection of `NSLayoutConstraint`.
     */
    @discardableResult
    public func removeConstraints(_ constraints: [NSLayoutConstraint]) -> Restraint {
        let constraintSet = Set(constraints)
        let removeStartIndex = self.constraints.partition { constraintSet.contains($0) }
        self.constraints.removeSubrange(removeStartIndex..<self.constraints.count)
        NSLayoutConstraint.deactivate(constraints)
        
        return self
    }
    
    /**
     Returns the underlying `NSLayoutConstraint` created by `Restraint` with the respective withId method.
     - Parameters:
         - id: The key corresponding to the constraint.
     */
    public func constraintWithId(_ id: String) -> NSLayoutConstraint? {
        return identifierToCostraint[id]
    }
}

public extension Restraint {
    
    // MARK: - Aligning
    
    /**
     Aligns many items to the same target with the same alignment.  This method will crash the program if using alignment identifiers with multiple alignment items since identifiers must be unique.
     
     - Parameters:
         - views: A collection of `RestraintTargetable` to be aligned.
         - alignment: The set of `Alignment` to align to `target`.
         - target: The `RestraintTargetable` that the `views` will be aligned to.
     
     - SeeAlso: alignItems(_ views:to alignment:)
     */
    @discardableResult
    public func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>, of target: RestraintTargetable) -> Restraint {
        let restraintValues = views.map { RestraintValue($0, value: 0) }
        process(restraintValues: restraintValues, buildConstraints: { (view, modifier) in
            return Array(alignment).map { $0.modifiedAlignmentConstraint(forSource: view, target: target, modifier: modifier) }
        })
        
        return self
    }
    
    /**
     Calls alignItems(_ views: to alignment: of target:) with `target = self.view`
     
     - Parameters:
         - views: A collection of `RestraintTargetable` to be aligned.
         - alignment: The set of `Alignment` to align to `target`.
     
     - SeeAlso: alignItems(_ views: to alignment: of target:)
     */
    @discardableResult
    public func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>) -> Restraint {
        return alignItems(views, to: alignment, of: self.view)
    }
    
    
    /// Aligns many items with different alignments to the same target.
    ///
    /// - Parameters:
    ///     - target: A `RestraintTargetable` to align items to.
    ///     - viewAlignment: Enum with associated type to denote an item and its alignment.
    @discardableResult
    public func alignItems(to target: RestraintTargetable, viewAlignment: [ViewAlignment]) -> Restraint {
        viewAlignment.forEach {
            if case let .view(aView, alignment) = $0 {
                _ = alignItems([aView], to: alignment, of: target)
            }
        }
        
        return self
    }
    
    // MARK: - Sizing
    @discardableResult
    public func setSizes(widths values: [RestraintValue]) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .width, v0: view, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    @discardableResult
    public func setSizes(heights values: [RestraintValue]) -> Restraint {
        process(restraintValues: values) { (view, modifier) in
            let aConstraint = modifiedSizeConstraint(for: .height, v0: view, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    @discardableResult
    public func setRelativeSizes(widths relations: [RelativeSize]) -> Restraint {
        process(restraintRelations: relations) { (v0, v1, modifier) in
            let aConstraint = modifiedRelativeSizeConstraint(for: .width, v0: v0, v1: v1, modifier: modifier)
            
            return [aConstraint]
        }
        
        return self
    }
    
    @discardableResult
    public func setRelativeSizes(heights relations: [RelativeSize]) -> Restraint {
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
    @discardableResult
    public func chainHorizontally(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        return chainHorizontally(views, spacing: spacing)
    }
    
    @discardableResult
    public func chainHorizontally(_ views: [Restrainable],
                                  in guide: RestraintTargetable,
                                  spacing: CGFloat = 8,
                                  aligning: Set<Alignment> = [.top, .bottom, .left, .right]) -> Restraint {
        let targetable = views.compactMap { $0 as? RestraintTargetable }
        let beginningAlignment = aligning.intersection(AlignmentSet.horizontalChainBeginning)
        let endingAlignment = aligning.intersection(AlignmentSet.horizontalChainEnding)
        let chainAlignment = aligning.intersection(AlignmentSet.horizontalChainAlignment)
        
        _ = chainHorizontally(views, spacing: spacing)
        _ = alignItems(targetable, to: chainAlignment, of: guide)
        
        if let first = targetable.first {
            _ = alignItems([first], to: beginningAlignment, of: guide)
        }
        
        if let last = targetable.last {
            _ = alignItems([last], to: endingAlignment, of: guide)
        }
        
        return self
    }
    
    /// Creates constraints to define spacing between each element in every views array argument.
    ///
    /// - Parameters:
    ///     - views: The `Restrainable` items to chain
    ///     - spacing: The default spacing between each view
    @discardableResult
    public func chainVertically(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint {
        return chainVertically(views, spacing: spacing)
    }
    
    @discardableResult
    public func chainVertically(_ views: [Restrainable],
                                in guide: RestraintTargetable,
                                spacing: CGFloat = 8,
                                aligning: Set<Alignment> = [.top, .bottom, .left, .right]) -> Restraint {
        let targetable = views.compactMap { $0 as? RestraintTargetable }
        let beginningAlignment = aligning.intersection(AlignmentSet.verticalChainBeginning)
        let endingAlignment = aligning.intersection(AlignmentSet.verticalChainEnding)
        let chainAlignment = aligning.intersection(AlignmentSet.verticalChainAlignment)
        
        _ = chainVertically(views, spacing: spacing)
        _ = alignItems(targetable, to: chainAlignment, of: guide)
        
        if let first = targetable.first {
            _ = alignItems([first], to: beginningAlignment, of: guide)
        }
        
        if let last = targetable.last {
            _ = alignItems([last], to: endingAlignment, of: guide)
        }
        
        return self
    }
}

extension Restraint {
    // MARK: - Private
    
    @discardableResult
    private func chainHorizontally(_ views: [[Restrainable]], spacing: CGFloat = 8) -> Restraint {
        views.forEach { _ = chainHorizontally($0, spacing: spacing) }
        
        return self
    }
    
    @discardableResult
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
    
    @discardableResult
    private func chainVertically(_ views: [[Restrainable]], spacing: CGFloat = 8) -> Restraint {
        views.forEach { _ = chainVertically($0, spacing: spacing) }
        
        return self
    }
    
    @discardableResult
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
