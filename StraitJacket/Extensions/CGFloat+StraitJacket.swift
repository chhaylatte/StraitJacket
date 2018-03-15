//
//  CGFloat+StraitJacket.swift
//  StraitJacket
//
//  Created by Danny Chhay on 3/14/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

extension CGFloat {
    public var sWidth: CGFloat {
        return CGFloat.scaledWidth(self)
    }
    
    public var sHeight: CGFloat {
        return CGFloat.scaledHeight(self)
    }
    
    public static func scaledWidth(_ multiple: CGFloat, of size: CGSize = UIScreen.main.bounds.size) -> CGFloat {
        return size.width * multiple
    }
    
    public static func scaledHeight(_ multiple: CGFloat, of size: CGSize = UIScreen.main.bounds.size) -> CGFloat {
        return size.height * multiple
    }
}
