//
//  RestraintInternalExtensions.swift
//  StraitJacket
//
//  Created by Danny Chhay on 7/18/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

extension Restraint {
    
    // MARK: - Private/Internal Guide Support
    
    // MARK: Alignment
    internal func alignment(with centering: GuideYCentering) -> Alignment {
        switch centering {
        case .top:
            return Alignment.top
        case .bottom:
            return Alignment.bottom
        case .centerY:
            return Alignment.centerY
        }
    }
    
    internal func alignment(with centering: GuideXCentering) -> Alignment {
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
    
    internal func verticalEndingAlignment(for pinning: GuidePinning) -> (Alignment, Alignment) {
        switch pinning {
        case .normal:
            return (Alignment.top, Alignment.bottom)
        case .soft:
            return (Alignment.softTop, Alignment.softBottom)
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
    
    // MARK: Chaining
    internal func horizontalAxisAlignment(for pinning: GuidePinning, centering: GuideYCentering) -> Set<Alignment> {
        var alignmentSet = alignment(for: .horizontal, with: pinning)
        let centerAlignment = alignment(with: centering)
        alignmentSet.insert(centerAlignment)
        
        return alignmentSet
    }
    
    internal func verticalAxisAlignment(for pinning: GuidePinning, centering: GuideXCentering) -> Set<Alignment> {
        var alignmentSet = alignment(for: .vertical, with: pinning)
        let centerAlignment = alignment(with: centering)
        alignmentSet.insert(centerAlignment)
        
        return alignmentSet
    }
}

extension Restraint {
    
    // MARK: - Internal Processing
    
    internal func process(restraintRelations: [[RestraintRelation]],
                          buildConstraints: (RestraintTargetable, RestraintTargetable, RestraintModifier) -> [NSLayoutConstraint]) {
        for relations in restraintRelations {
            for relation in relations {
                let builtConstraints = buildConstraints(relation.view0, relation.view1, relation.modifier)
                builtConstraints.forEach { didBuildConstraint($0) }
            }
        }
    }
    
    internal func process(restraintValues: [[RestraintValue]],
                 buildConstraints: (RestraintTargetable, RestraintModifier) -> [NSLayoutConstraint]) {
        
        for values in restraintValues {
            for value in values {
                let builtConstraints = buildConstraints(value.view, value.modifier)
                builtConstraints.forEach { didBuildConstraint($0) }
            }
        }
    }
    
    internal func movingProcess(restrainables: [Restrainable],
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
    
    internal func modifiedChainConstraint(for direction: Direction, v0: RestraintTargetable, v1: RestraintTargetable, modifier: RestraintModifier) -> NSLayoutConstraint {
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
    
    internal func modifiedRelativeSizeConstraint(for size: Size, v0: RestraintTargetable, v1: RestraintTargetable, modifier: RestraintModifier) -> NSLayoutConstraint {
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
    
    internal func modifiedSizeConstraint(for size: Size, v0: RestraintTargetable, modifier: RestraintModifier) -> NSLayoutConstraint {
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
