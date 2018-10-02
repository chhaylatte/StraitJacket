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

var aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

var graySubview = UIView()
graySubview.backgroundColor = .gray

var aRestraint = Restraint(aView, items: [graySubview])
    .alignItems([graySubview], to: [.centerX, .centerY])
    .setSizes(widths: [graySubview.equal(200)])
    .setSizes(heights: [graySubview.equal(50)])
aRestraint.activate()
aView

/*:
 ## Relative Sizing
 `Restraint` can create normalized size constraints with:
 
 ````
 func setRelativeSizes(widths relations: [RelativeSize]) -> Restraint
 
 func setRelativeSizes(heights relations: [RelativeSize]) -> Restraint
 ````
 
 `RelativeSize` is a value type that can be created from StraitJacket's `RestraintTargetable` extension:
 ````
 func multiple(_ multiple: CGFloat,
                  of view: RestraintTargetable,
                 relation: NSLayoutRelation = .equal,
                 priority: UILayoutPriority = .required) -> RestraintRelation
 ````
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

graySubview = UIView()
graySubview.backgroundColor = .gray

aRestraint = Restraint(aView, items: [graySubview])
    .alignItems([graySubview], to: [.centerX, .centerY])
    .setRelativeSizes(widths: [graySubview.multiple(0.5, of: aView)])
    .setRelativeSizes(heights: [graySubview.multiple(1.0, of: aView)])
aRestraint.activate()
aView


//: [Next](@next)
