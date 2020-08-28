//
//  CGFloat+StraitJacket.swift
//  StraitJacket
//
//  Created by Danny Chhay on 3/14/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    /// Returns the current value multiplied to UIScreen.main.bounds.size.width
    public var sWidth: CGFloat {
        return CGFloat.scaledWidth(self)
    }
    
    /// Returns the current value multiplied to height
    public var sHeight: CGFloat {
        return CGFloat.scaledHeight(self)
    }
    
    /**
     Returns size.width * multiple
     - Parameters:
         - multiple: A `CGFloat`
         - size: The reference size CGSize.  Default is UIScreen.main.bounds.size.width
     */
    public static func scaledWidth(_ multiple: CGFloat, of size: CGSize = UIScreen.main.bounds.size) -> CGFloat {
        return size.width * multiple
    }
    
    /**
     Returns size.height * multiple
     - Parameters:
         - multiple: A `CGFloat`
         - size: The reference size CGSize.  Default is UIScreen.main.bounds.size.height
     */
    public static func scaledHeight(_ multiple: CGFloat, of size: CGSize = UIScreen.main.bounds.size) -> CGFloat {
        return size.height * multiple
    }
}
