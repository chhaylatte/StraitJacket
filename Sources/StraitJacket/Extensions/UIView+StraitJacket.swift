//
//  UIView+StraitJacket.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func sWidth(_ multiple: CGFloat) -> CGFloat {
        return frame.size.width * multiple
    }
    
    func sHeight(_ multiple: CGFloat) -> CGFloat {
        return frame.size.height * multiple
    }
    
    internal func addItems(_ items: [RestraintTargetable]) {
        items.forEach {
            $0.addToRootView(self)
        }
    }
    
    /// Returns a `RestraintProxy` for replacing anchors in place.  The `RestraintProxy` can be used in place of a view in `Restraint` methods.
    var proxy: RestraintProxy {
        return RestraintProxy(view: self)
    }
}
