//: [Previous](@previous)

import UIKit
import StraitJacket

/*:
 # Sizing
 
 ## RestraintValue
 `Restraint` creates size constraints with:
 ````
 func setSizes(widths values: [RestraintValue]) -> Restraint

 func setSizes(heights values: [RestraintValue]) -> Restraint
 ````
 
 RestraintValue is a value type that can be created from StraitJacket's `RestraintTargetable` extensions:
 ````
 func equal(_ value: CGFloat, priority: UILayoutPriority = .required) -> RestraintValue
 
 func min(_ value: CGFloat, priority: UILayoutPriority = .required) -> RestraintValue
 
 func max(_ value: CGFloat, priority: UILayoutPriority = .required) -> RestraintValue
 ````
 
 These methods correspond to constraint layout relations equal, greaterThanOrEqual, and lessThanOrEqual respectively.
 
 */

let aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

let graySubview = UIView()
graySubview.backgroundColor = .gray

let aRestraint = Restraint(aView, items: [graySubview])
    .alignItems([graySubview], to: [.centerX, .centerY])
    .setSizes(widths: [graySubview.equal(200)])
    .setSizes(heights: [graySubview.equal(50)])
aRestraint.activate()
aView

//: [Next](@next)
