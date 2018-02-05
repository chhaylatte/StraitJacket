//
//  UIView+StraitJacket.swift
//  StraitJacket
//
//  Created by Danny Chhay on 1/15/18.
//  Copyright © 2018 Danny Chhay. All rights reserved.
//

import Foundation

public extension UIView {
    public func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
