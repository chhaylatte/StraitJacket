//
//  RestraintTypeAliases.swift
//  StraitJacket
//
//  Created by Danny Chhay on 2/5/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

/// Type defining layout distance in points
public typealias EqualSpace = RestraintModifier

/// Type defining greater than or equal to inequality layout distance in points
public typealias MaximumSpace = RestraintModifier

/// Type defining less than or equal to inequality layout distance in points
public typealias MinimumSpace = RestraintModifier

/// Type defining a size value in points
public typealias RestraintSize = RestraintValue

/// Type defining a relative size value scaled to 1.0
public typealias RelativeSize = RestraintRelation
