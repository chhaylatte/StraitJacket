//
//  UIView+StraitJacket.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

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
}
