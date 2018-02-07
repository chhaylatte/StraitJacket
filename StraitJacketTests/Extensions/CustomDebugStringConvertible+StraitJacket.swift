//
//  CustomDebugStringConvertible+StraitJacket.swift
//  StraitJacketTests
//
//  Created by Danny Chhay on 2/7/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutAttribute: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .left:
            return "left"
        case .right:
            return "right"
        default:
            return String(describing: self)
        }
    }
}
