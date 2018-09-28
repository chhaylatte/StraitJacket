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
var aRestraint = Restraint(aView, items: [blackSubview, graySubview])
    .alignItems([blackSubview, graySubview], to: [.centerX, .centerY])
aRestraint.activate()

// Create size constraints with anchors since we're learning about Alignment only right now.
let sizeConstraints = [
    blackSubview.widthAnchor.constraint(equalToConstant: 200),
    blackSubview.heightAnchor.constraint(equalToConstant: 200),
    graySubview.widthAnchor.constraint(equalToConstant: 100),
    graySubview.heightAnchor.constraint(equalToConstant: 100),
]

NSLayoutConstraint.activate(sizeConstraints)

// This will be used later
var grayWidthConstraint = sizeConstraints[2]
grayWidthConstraint.priority = .defaultHigh

aView

/*:
 ## Aligning to a Target
 
 To align many views to the same target:
 
 `func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>, of target: RestraintTargetable)`
 
 `RestraintTargettable` can be either a kind of UIView or a UILayoutGuide.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

aRestraint = Restraint(aView, items: [blackSubview, graySubview])
    .alignItems([blackSubview], to: [.centerX, .centerY], of: aView.layoutMarginsGuide)
    .alignItems([graySubview], to: [.left], of: blackSubview)
    .alignItems([graySubview], to: [.centerY], of: blackSubview)
aRestraint.activate()

aView

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

aRestraint = Restraint(aView, items: [blackSubview, graySubview])
    .alignItems([blackSubview], to: [.centerX, .centerY])
    .alignItems([graySubview], to: [.centerX, .centerY], of: blackSubview)
aRestraint.activate()

/*:
 ## Soft Aligning
 
 Alignment also define "soft" versions of alignment.  Soft alignment is used for creating inequality constraints to stay within the bounds of the target.
 */

aView

// The gray view's width is set to be larger than the black view to simulate large content.
grayWidthConstraint.constant = 300
aView

/*
 The soft left and right alignment constraints are activated to confine the gray subview within the bounds of the black view.
 */
let graySubviewBoundaryRestraint = Restraint(aView)
    .alignItems([graySubview], to: [.softLeft, .softRight], of: blackSubview)
graySubviewBoundaryRestraint.activate()
aView

// Undo the previous constant change
grayWidthConstraint.constant = 100

/*:
 ## Alignment Offsets and Insets
 
 Alignment can be offset or inset using the `offset` and `inset` methods respectively.
 
 Swift gets confused when calling a method on an enum inline within a collection, so it may be required to also denote the Alignment enum.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

blackSubview = UIView()
blackSubview.backgroundColor = .black

aRestraint = Restraint(aView, items: [blackSubview, graySubview])
    .alignItems([blackSubview], to: [Alignment.top.offset(40),
                                     Alignment.left.inset(10),
                                     Alignment.right.inset(10),
                                     Alignment.bottom.inset(20)])
    .alignItems([graySubview], to: [Alignment.centerX, Alignment.centerY.offset(-20)])
aRestraint.activate()
aView
