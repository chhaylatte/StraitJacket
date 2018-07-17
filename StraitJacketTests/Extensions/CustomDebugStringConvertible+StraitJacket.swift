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
        case .left:
            return "left"
            
        case .right:
            return "right"
            
        case .top:
            return "top"
            
        case .bottom:
            return "bottom"
            
        case .leading:
            return "leading"
            
        case .trailing:
            return "trailing"
            
        case .width:
            return "width"
            
        case .height:
            return "height"
            
        case .centerX:
            return "centerX"
            
        case .centerY:
            return "centerY"
            
        case .lastBaseline:
            return "lastBaseline"
            
        case .firstBaseline:
            return "firstBaseline"
            
        case .leftMargin:
            return "leftMargin"
            
        case .rightMargin:
            return "rightMargin"
            
        case .topMargin:
            return "topMargin"
            
        case .bottomMargin:
            return "bottomMargin"
            
        case .leadingMargin:
            return "leadingMargin"
            
        case .trailingMargin:
            return "trailingMargin"
            
        case .centerXWithinMargins:
            return "centerXWithinMargins"
            
        case .centerYWithinMargins:
            return "centerYWithinMargins"
            
        case .notAnAttribute:
            return "notAnAttribute"
        }
    }
}
