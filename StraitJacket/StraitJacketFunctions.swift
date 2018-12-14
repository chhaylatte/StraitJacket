//
//  StraitJacketFunctions.swift
//  StraitJacket
//
//  Created by Danny Chhay on 12/13/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/**
 Returns a `Space` for use by `Restraint`
 - Parameters:
    - value: The value in points
 */
public func equal(_ value: CGFloat) -> Space {
    return RestraintModifier(value)
}

/**
 Returns a `MaximumSpace` for use by `Restraint`
 - Parameters:
    - value: The value in points
 */
public func most(_ value: CGFloat) -> MaximumSpace {
    return RestraintModifier(value, multiple: 1.0, relation: .lessThanOrEqual)
}

/**
 Returns a `MinimumSpace` for use by `Restraint`
 - Parameters:
    - value: The value in points
 */
public func least(_ value: CGFloat) -> MinimumSpace {
    return RestraintModifier(value, multiple: 1.0, relation: .greaterThanOrEqual)
}
