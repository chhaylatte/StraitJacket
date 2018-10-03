//: [Previous](@previous)

import UIKit
import StraitJacket


/*:
 # Chaining
 Restraint can chain views using:
 
 ````
 func chainHorizontally(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint
 
 func chainVertically(_ views: [Restrainable]..., spacing: CGFloat = 8) -> Restraint
 ````
 
 ## Restrainable
 `Restrainable` can be `UIView`, `UILayoutGuide`, or `Space`.  `Space` is a type alias for the value type `RestraintModifier`.
 */

var label1 = UILabel()
label1.backgroundColor = .white
label1.text = "1"

var label2 = UILabel()
label2.backgroundColor = .white
label2.text = "2"

var label3 = UILabel()
label3.backgroundColor = .white
label3.text = "3"

var aView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
aView.backgroundColor = .black

var aRestraint = Restraint(aView, items: [label1, label2, label3])
    .chainHorizontally([label1, label2, label3])
    .alignItems([label1], to: [.left])
    .alignItems([label1, label2, label3], to: [.centerY])

aRestraint.activate()
aView


/*:
 ## Space
 `Space` is a `RestraintModifier` type alias which conforms to `Restrainable`.  It can be used with the chain methods.
*/

aView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
aView.backgroundColor = .black

aRestraint = Restraint(aView, items: [label1, label2, label3])
    .chainHorizontally([label1, Space(20), label2, Space(30), label3])
    .alignItems([label1], to: [.left])
    .alignItems([label1, label2, label3], to: [.centerY])

aRestraint.activate()
aView

/*:
 ## Chaining in RestraintTargetable
 To chain views together and also align to a `RestraintTargetable` at the same time:
 
 ````
 func chainHorizontally(_ views: [Restrainable],
                       in guide: RestraintTargetable,
                        spacing: CGFloat = 8,
                       aligning: Set<Alignment> = [.top, .bottom, .left, .right]) -> Restraint
 
 func chainVertically(_ views: [Restrainable],
                       in guide: RestraintTargetable,
                        spacing: CGFloat = 8,
                       aligning: Set<Alignment> = [.top, .bottom, .left, .right]) -> Restraint
 ````
 
 When chaining horizontally, each item is aligned to the top and bottom, and the first and last is aligned to the left and right respectively if specified in `aligning`.
 
 When chaining vertically, each item is aligned to the left and right, and the first and last is aligned to the top and bottom respectively if specified in `aligning`.
 
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
aView.backgroundColor = .black

let aGuide = UILayoutGuide()

aRestraint = Restraint(aView, items: [label1, label2, label3, aGuide])
    .chainHorizontally([label1, Space(20), label2, Space(20), label3], in: aGuide)
    .alignItems([aGuide], to: AlignmentSet.centerXY)

aRestraint.activate()
aView

//: [Next](@next)
