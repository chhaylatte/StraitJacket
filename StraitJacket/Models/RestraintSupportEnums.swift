//
//  RestraintSupportEnums.swift
//  StraitJacket
//
//  Created by Danny Chhay on 7/18/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

internal enum Direction {
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

enum Size {
    case width
    case height
}
