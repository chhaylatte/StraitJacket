//
//  RestraintGuide.swift
//  StraitJacket
//
//  Created by Danny Chhay on 5/24/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public struct Alignment: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = Alignment(rawValue: 1 << 0)
    public static let bottom = Alignment(rawValue: 1 << 1)
    public static let left = Alignment(rawValue: 1 << 2)
    public static let right = Alignment(rawValue: 1 << 3)
    
    public static let softTop = Alignment(rawValue: 1 << 4)
    public static let softBottom = Alignment(rawValue: 1 << 5)
    public static let softLeft = Alignment(rawValue: 1 << 6)
    public static let softRight = Alignment(rawValue: 1 << 7)
    
    public static let centerY = Alignment(rawValue: 1 << 8)
    public static let centerX = Alignment(rawValue: 1 << 9)
    
    public static let vertical: Alignment = [.top, .bottom]
    public static let horizontal: Alignment = [.left, .right]
    
    /// Generates array of constraints for Alignment set
    ///
    /// - Parameters:
    ///     - modifier: Only the modifier.value and modifier.priority is used.
    func modifiedAlignmentConstraints(forSource v0: RestraintTargetable,
                                     target v1: RestraintTargetable,
                                     modifier: RestraintModifier) -> [NSLayoutConstraint] {
        
        let constraints: [NSLayoutConstraint] = {
            var constraints: [NSLayoutConstraint] = []
            
            if contains(.top) {
                let constraintFunc = Restraint.constraintFunction(v0.topAnchor, relation: .equal)
                constraints.append(constraintFunc(v1.topAnchor, modifier.value))
            }
            
            if contains(.bottom) {
                let constraintFunc = Restraint.constraintFunction(v0.bottomAnchor, relation: .equal)
                constraints.append(constraintFunc(v1.bottomAnchor, modifier.value))
            }
            
            if contains(.left) {
                let constraintFunc = Restraint.constraintFunction(v0.leftAnchor, relation: .equal)
                constraints.append(constraintFunc(v1.leftAnchor, modifier.value))
            }
            
            if contains(.right) {
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: .equal)
                constraints.append(constraintFunc(v1.rightAnchor, modifier.value))
            }
            
            if contains(.centerX) {
                let constraintFunc = Restraint.constraintFunction(v0.centerXAnchor, relation: .equal)
                constraints.append(constraintFunc(v1.centerXAnchor, modifier.value))
            }
            
            if contains(.centerY) {
                let constraintFunc = Restraint.constraintFunction(v0.centerYAnchor, relation: .equal)
                constraints.append(constraintFunc(v1.centerYAnchor, modifier.value))
            }
            
            if contains(.softTop) {
                let constraintFunc = Restraint.constraintFunction(v0.topAnchor, relation: .greaterThanOrEqual)
                constraints.append(constraintFunc(v1.topAnchor, modifier.value))
            }
            
            if contains(.softBottom) {
                let constraintFunc = Restraint.constraintFunction(v0.bottomAnchor, relation: .lessThanOrEqual)
                constraints.append(constraintFunc(v1.bottomAnchor, modifier.value))
            }
            
            if contains(.softLeft) {
                let constraintFunc = Restraint.constraintFunction(v0.leftAnchor, relation: .greaterThanOrEqual)
                constraints.append(constraintFunc(v1.leftAnchor, modifier.value))
            }
            
            if contains(.softRight) {
                let constraintFunc = Restraint.constraintFunction(v0.rightAnchor, relation: .lessThanOrEqual)
                constraints.append(constraintFunc(v1.rightAnchor, modifier.value))
            }
            
            return constraints
        }()
        
        constraints.forEach { $0.priority = modifier.priority }
        
        return constraints
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
    
    public func alignItems(_ views: [UIView], with alignment: Alignment) -> Restraint<T> {
        return restraint.alignItems(views, with: alignment, to: layoutGuide)
    }
    
}
