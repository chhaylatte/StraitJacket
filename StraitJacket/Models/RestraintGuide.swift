//
//  RestraintGuide.swift
//  StraitJacket
//
//  Created by Danny Chhay on 5/24/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public enum ViewAlignment {
    case view(RestraintTargetable, Set<Alignment>)
}

public enum Alignment: Hashable {
    
    case top
    case bottom
    case left
    case right
    
    case softTop
    case softBottom
    case softLeft
    case softRight
    
    case centerY
    case centerX
    
    indirect case alignementWithId(Alignment, String)
    indirect case alignementWithPriority(Alignment, UILayoutPriority)
    
    public func withId(_ identifier: String) -> Alignment {
        switch self {
        case .alignementWithId(_, _):
            return self
        default:
            return .alignementWithId(self, identifier)
        }
    }
    
    public func withPriority(_ priority: UILayoutPriority) -> Alignment {
        switch self {
        case .alignementWithId(_, _):
            return self
        default:
            return .alignementWithPriority(self, priority)
        }
    }
    
    func modifiedAlignmentConstraint(forSource v0: RestraintTargetable,
                                     target v1: RestraintTargetable,
                                     modifier: RestraintModifier) -> NSLayoutConstraint {
        return Alignment.modifiedAlignmentConstraint(alignment: self,
                                                     forSource: v0,
                                                     target: v1,
                                                     modifier: modifier)
    }
    
    /// Generates array of constraints for Alignment set
    ///
    /// - Parameters:
    ///     - modifier: Only the modifier.value and modifier.priority is used.
    static func modifiedAlignmentConstraint(alignment: Alignment,
                                     forSource v0: RestraintTargetable,
                                     target v1: RestraintTargetable,
                                     modifier: RestraintModifier) -> NSLayoutConstraint {
        var newModifier: RestraintModifier = modifier
        let constraint: NSLayoutConstraint = {
            
            switch alignment {
            case .top:
                let constraintFunc = Restraint.constraintFunction(v0.topAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.topAnchor, modifier.value)
                
                return aConstraint
                
            case .bottom:
                let constraintFunc = Restraint.constraintFunction(v0.bottomAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.bottomAnchor, modifier.value)
                
                return aConstraint
                
            case .left:
                let constraintFunc = Restraint.constraintFunction(v0.leftAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.leftAnchor, modifier.value)
                
                return aConstraint
                
            case .right:
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.rightAnchor, modifier.value)
                
                return aConstraint
                
                
            case .centerX:
                let constraintFunc = Restraint.constraintFunction(v0.centerXAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.centerXAnchor, modifier.value)
                
                return aConstraint
                
                
            case .centerY:
                let constraintFunc = Restraint.constraintFunction(v0.centerYAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.centerYAnchor, modifier.value)
                
                return aConstraint
                
                
            case .softTop:
                let constraintFunc = Restraint.constraintFunction(v0.topAnchor, relation: .greaterThanOrEqual)
                let aConstraint = constraintFunc(v1.topAnchor, modifier.value)
                
                return aConstraint
                
            case .softBottom:
                let constraintFunc = Restraint.constraintFunction(v0.bottomAnchor, relation: .lessThanOrEqual)
                let aConstraint = constraintFunc(v1.bottomAnchor, modifier.value)
                
                return aConstraint
                
            case .softLeft:
                let constraintFunc = Restraint.constraintFunction(v0.leftAnchor, relation: .greaterThanOrEqual)
                let aConstraint = constraintFunc(v1.leftAnchor, modifier.value)
                
                return aConstraint
                
            case .softRight:
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: .lessThanOrEqual)
                let aConstraint = constraintFunc(v1.rightAnchor, modifier.value)
                
                return aConstraint
                
            case .alignementWithId(let alignment, let identifier):
                newModifier.identifier = identifier
                
                return modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
            case .alignementWithPriority(let alignment, let priority):
                newModifier.priority = priority
                
                return modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
            }
        }()
        
        constraint.identifier = newModifier.identifier
        constraint.priority = newModifier.priority
        
        return constraint
    }
    
}

public extension Restraint {
    func guide(_ guide: UILayoutGuide) -> GuidedRestraint<T> {
        return GuidedRestraint(layoutGuide: guide, restraint: self)
    }
    
    func guide(_ guide: UILayoutGuide, guideBlock: (GuidedRestraint<T>) -> Void) -> Restraint<T> {
        guideBlock(GuidedRestraint(layoutGuide: guide, restraint: self))
        
        return self
    }
}

public class GuidedRestraint<T: UIView> {
    private let layoutGuide: UILayoutGuide
    private let restraint: Restraint<T>
    
    public init(layoutGuide: UILayoutGuide, restraint: Restraint<T>) {
        self.layoutGuide = layoutGuide
        self.restraint = restraint
    }
    
    public func alignItems(_ views: [UIView], to alignment: Set<Alignment>) -> Restraint<T> {
        return restraint.alignItems(views, to: alignment, of: layoutGuide)
    }
    
}
