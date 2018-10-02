//: [Previous](@previous)

import UIKit
import StraitJacket

/*:
 # Alignment
 
 ## Alignment Enum
 
 The `Alignment` enum specifies various possible ways to align items including aligning the sides and center.
 
 ## Aligning to the Root View
 
 To align many views to the root view:
 
 `func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>)`
 */
// Set up the views
var blackSubview = UIView()
blackSubview.backgroundColor = .black

let graySubview = UIView()
graySubview.backgroundColor = .gray

var aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

// Align items with a `Restraint`
var aRestraint = Restraint(aView, items: [graySubview])
    .alignItems([graySubview], to: [.top, .bottom, .left, .right])
aRestraint.activate()

aView


/*:
 ## Aligning with Inset
 The Alignment enum has a method to specify insets.  Currently the compiler is confused by shorthand enum notation so `Alignment` must still be written in the code.  Ex. `Alignment.top.inset(x)` instead of `.top.inset(x)`.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

// Align items with a `Restraint`
aRestraint = Restraint(aView, items: [graySubview])
    .alignItems([graySubview], to: [Alignment.top.inset(10), Alignment.bottom.inset(20), Alignment.left.inset(16), Alignment.right.inset(16)])
aRestraint.activate()

aView

/*:
 ## Aligning with offset
 The Alignment enum has a method to specify offsets.  Currently the compiler is confused by shorthand enum notation so  `Alignment` must still be written in the code.  Ex. `Alignment.top.offset(x)` instead of `.top.offset(x)`.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
aView.backgroundColor = .white

var aLabel = UILabel()
aLabel.text = "StraitJacket"
aLabel.lineBreakMode = .byTruncatingTail

// The label extends beyond the gray subview's bounds without boundary constraints
aRestraint = Restraint(aView, items: [graySubview, aLabel])
    .alignItems([graySubview], to: [.top, .bottom, Alignment.left.inset(20), Alignment.right.inset(20)], of: aView.layoutMarginsGuide)
    .alignItems([aLabel], to: [.centerX, Alignment.centerY.offset(20)], of: graySubview)
aRestraint.activate()
aView



/*:
 ## Aligning to a Target
 
 To align many views to the same target:
 
 `func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>, of target: RestraintTargetable)`
 
 `RestraintTargettable` can be either a kind of UIView or a UILayoutGuide.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

aRestraint = Restraint(aView, items: [graySubview, blackSubview])
    .alignItems([graySubview], to: [.top, .bottom, .left, .right], of: aView.layoutMarginsGuide)
    .alignItems([blackSubview], to: [.top, .bottom, Alignment.left.inset(20), Alignment.right.inset(20)], of: graySubview)
aRestraint.activate()

aView

/*:
 ## Soft Aligning
 
 Alignment also defines "soft" versions of alignment.  Soft alignment is used for creating inequality constraints to stay within the bounds of the target.  There is no need to think about whether or not the constraint relation should be a less than or greater than relation.  Soft constraints are assumed to be used for confining within a boundary.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
aView.backgroundColor = .white

aLabel = UILabel()
aLabel.text = "StraitJacket StraitJacket StraitJacket"
aLabel.lineBreakMode = .byTruncatingTail

// The label extends beyond the gray subview's bounds without boundary constraints
aRestraint = Restraint(aView, items: [graySubview, aLabel])
    .alignItems([graySubview], to: [.top, .bottom, Alignment.left.inset(20), Alignment.right.inset(20)], of: aView.layoutMarginsGuide)
    .alignItems([aLabel], to: [.centerX, .centerY], of: graySubview)
aRestraint.activate()
aView

// The label is now confined within the gray subview's bounds
let boundaryRestraint = Restraint(aView, items: [aLabel])
    .alignItems([aLabel], to:[Alignment.softLeft.inset(8), Alignment.softRight.inset(8)], of: graySubview)
boundaryRestraint.activate()
aView

//: [Next](@next)
