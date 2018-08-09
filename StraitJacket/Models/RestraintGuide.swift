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

public struct AlignmentSet {
    static let horizontalChainAlignment: Set<Alignment> = [.top, .bottom, .centerY, .softTop, .softBottom]
    static let horizontalChainBeginning: Set<Alignment> = [.left, .softLeft]
    static let horizontalChainEnding: Set<Alignment> = [.right, .softRight]
    
    static let verticalChainAlignment: Set<Alignment> = [.left, .right, .centerX, .softLeft, .softRight]
    static let verticalChainBeginning: Set<Alignment> = [.top, .softTop]
    static let verticalChainEnding: Set<Alignment> = [.bottom, .softBottom]
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
        return .alignementWithId(self, identifier)
    }
    
    public func withPriority(_ priority: UILayoutPriority) -> Alignment {
        return .alignementWithPriority(self, priority)
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
                
                let aConstraint = modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
                newModifier.identifier = aConstraint.identifier
                newModifier.priority = aConstraint.priority
                
                return aConstraint
                
            case .alignementWithPriority(let alignment, let priority):
                newModifier.priority = priority
                
                let aConstraint = modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
                newModifier.identifier = aConstraint.identifier
                newModifier.priority = aConstraint.priority
                
                return aConstraint
            }
        }()
        
        constraint.identifier = newModifier.identifier
        constraint.priority = newModifier.priority
        
        return constraint
    }
}
