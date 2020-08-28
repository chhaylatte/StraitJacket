//
//  Alignment.swift
//  StraitJacket
//
//  Created by Danny Chhay on 8/10/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation
import UIKit

public enum ViewAlignment {
    case view(RestraintTargetable, Set<Alignment>)
}

public struct AlignmentSet {
    public static let allSides: Set<Alignment> = [.top, .bottom, .leading, .trailing]
    public static let vertical: Set<Alignment> = [.top, .bottom]
    public static let horizontal: Set<Alignment> = [.leading, .trailing]
    
    public static let allSoftSides: Set<Alignment> = [.softTop, .softBottom, .softLeading, .softTrailing]
    public static let softVertical: Set<Alignment> = [.softTop, .softBottom]
    public static let softHorizontal: Set<Alignment> = [.softLeading, .softTrailing]
    
    public static let centerXY: Set<Alignment> = [.centerX, .centerY]
    
    static let horizontalChainAlignment: Set<Alignment> = [.top, .bottom, .centerY, .softTop, .softBottom]
    static let verticalChainAlignment: Set<Alignment> = [.leading, .trailing, .centerX, .softLeading, .softTrailing]
}

public enum Alignment: Hashable {
    
    case top
    case bottom
    case left
    case leading
    case right
    case trailing
    
    case softTop
    case softBottom
    case softLeft
    case softLeading
    case softRight
    case softTrailing
    
    case centerY
    case centerX
    
    indirect case alignmentWithId(Alignment, String)
    indirect case alignmentWithPriority(Alignment, UILayoutPriority)
    indirect case alignmentWithOffset(Alignment, CGFloat)
    indirect case alignmentWithInset(Alignment, CGFloat)
    
    public func withId(_ identifier: String) -> Alignment {
        return .alignmentWithId(self, identifier)
    }
    
    public func priority(_ priority: UILayoutPriority) -> Alignment {
        return .alignmentWithPriority(self, priority)
    }
    
    public func offset(_ offset: CGFloat) -> Alignment {
        return .alignmentWithOffset(self, offset)
    }
    
    public func inset(_ inset: CGFloat) -> Alignment {
        return .alignmentWithInset(self, inset)
    }

    internal var isTopAlignment: Bool {
        switch self {
        case .top, .softTop:
            return true
        case .alignmentWithInset(let alignment, _):
            return alignment.isTopAlignment
        case .alignmentWithId(let alignment, _):
            return alignment.isTopAlignment
        case .alignmentWithOffset(let alignment, _):
            return alignment.isTopAlignment
        case .alignmentWithPriority(let alignment, _):
            return alignment.isTopAlignment
        default:
            return false
        }
    }

    internal var isBottomAlignment: Bool {
        switch self {
        case .bottom, .softBottom:
            return true
        case .alignmentWithInset(let alignment, _):
            return alignment.isBottomAlignment
        case .alignmentWithId(let alignment, _):
            return alignment.isBottomAlignment
        case .alignmentWithOffset(let alignment, _):
            return alignment.isBottomAlignment
        case .alignmentWithPriority(let alignment, _):
            return alignment.isBottomAlignment
        default:
            return false
        }
    }

    internal var isLeadingAlignment: Bool {
        switch self {
        case .leading, .softLeading:
            return true
        case .alignmentWithInset(let alignment, _):
            return alignment.isLeadingAlignment
        case .alignmentWithId(let alignment, _):
            return alignment.isLeadingAlignment
        case .alignmentWithOffset(let alignment, _):
            return alignment.isLeadingAlignment
        case .alignmentWithPriority(let alignment, _):
            return alignment.isLeadingAlignment
        default:
            return false
        }
    }

    internal var isTrailingAlignment: Bool {
        switch self {
        case .trailing, .softTrailing:
            return true
        case .alignmentWithInset(let alignment, _):
            return alignment.isTrailingAlignment
        case .alignmentWithId(let alignment, _):
            return alignment.isTrailingAlignment
        case .alignmentWithOffset(let alignment, _):
            return alignment.isTrailingAlignment
        case .alignmentWithPriority(let alignment, _):
            return alignment.isTrailingAlignment
        default:
            return false
        }
    }

    internal var isHorizontalAlignment: Bool {
        switch self {
        case .leading, .softLeading, .trailing, .softTrailing, .left, .softLeft, .right, .softRight, .centerX:
            return true
        case .alignmentWithInset(let alignment, _):
            return alignment.isHorizontalAlignment
        case .alignmentWithId(let alignment, _):
            return alignment.isHorizontalAlignment
        case .alignmentWithOffset(let alignment, _):
            return alignment.isHorizontalAlignment
        case .alignmentWithPriority(let alignment, _):
            return alignment.isHorizontalAlignment
        default:
            return false
        }
    }

    internal var isVerticalAlignment: Bool {
        switch self {
        case .top, .softTop, .bottom, .softBottom, .centerY:
            return true
        case .alignmentWithInset(let alignment, _):
            return alignment.isVerticalAlignment
        case .alignmentWithId(let alignment, _):
            return alignment.isVerticalAlignment
        case .alignmentWithOffset(let alignment, _):
            return alignment.isVerticalAlignment
        case .alignmentWithPriority(let alignment, _):
            return alignment.isVerticalAlignment
        default:
            return false
        }
    }
    
    internal func modifiedAlignmentConstraint(forSource v0: RestraintTargetable,
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
    internal static func modifiedAlignmentConstraint(alignment: Alignment,
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

            case .leading:
                let constraintFunc = Restraint.constraintFunction(v0.leadingAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.leadingAnchor, modifier.value)

                return aConstraint
                
            case .right:
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.rightAnchor, modifier.value)
                
                return aConstraint

            case .trailing:
                let constraintFunc = Restraint.constraintFunction(v0.trailingAnchor, relation: .equal)
                let aConstraint = constraintFunc(v1.trailingAnchor, modifier.value)

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

            case .softLeading:
                let constraintFunc = Restraint.constraintFunction(v0.leadingAnchor, relation: .greaterThanOrEqual)
                let aConstraint = constraintFunc(v1.leadingAnchor, modifier.value)

                return aConstraint
                
            case .softRight:
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: .lessThanOrEqual)
                let aConstraint = constraintFunc(v1.rightAnchor, modifier.value)
                
                return aConstraint

            case .softTrailing:
                let constraintFunc = Restraint.constraintFunction(v0.trailingAnchor, relation: .lessThanOrEqual)
                let aConstraint = constraintFunc(v1.trailingAnchor, modifier.value)

                return aConstraint
                
            case .alignmentWithId(let alignment, let identifier):
                newModifier.identifier = identifier
                
                let aConstraint = modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
                didRecurse(updateModifier: &newModifier, with: aConstraint)
                
                return aConstraint
                
            case .alignmentWithPriority(let alignment, let priority):
                newModifier.priority = priority
                
                let aConstraint = modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
                didRecurse(updateModifier: &newModifier, with: aConstraint)
                
                return aConstraint
                
            case .alignmentWithOffset(let alignment, let offset):
                newModifier.value = offset
                
                let aConstraint = modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
                didRecurse(updateModifier: &newModifier, with: aConstraint)
                
                return aConstraint
                
            case .alignmentWithInset(let alignment, let inset):
                newModifier.value = modifierValue(for: alignment, inset: inset)
                
                let aConstraint = modifiedAlignmentConstraint(alignment: alignment, forSource: v0, target: v1, modifier: newModifier)
                didRecurse(updateModifier: &newModifier, with: aConstraint)
                
                return aConstraint
            }
        }()
        
        constraint.identifier = newModifier.identifier
        constraint.priority = newModifier.priority
        constraint.constant = newModifier.value
        
        return constraint
    }
    
    private static func didRecurse(updateModifier: inout RestraintModifier, with constraint: NSLayoutConstraint) {
        updateModifier.identifier = constraint.identifier
        updateModifier.priority = constraint.priority
        updateModifier.value = constraint.constant
        updateModifier.multiple = constraint.multiplier
    }
    
    private static func modifierValue(for alignment: Alignment, inset: CGFloat) -> CGFloat {
        switch alignment {
        case .top, .left, .leading, .softTop, .softLeft, .softLeading:
            return inset
        case .right, .trailing, .bottom, .softRight, .softTrailing, .softBottom:
            return -inset
        default:
            return 0
        }
    }
}
