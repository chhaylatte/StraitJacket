import UIKit
import StraitJacket

/*:
 # Alignment
 
 Use `func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>, of target: RestraintTargetable)` on `Restraint` to align many views to the same target.
 
 Use `func alignItems(_ views: [RestraintTargetable], to alignment: Set<Alignment>)` to align to the root view.
 */

let blackSubview = UIView()
blackSubview.backgroundColor = .black

let graySubview = UIView()
graySubview.backgroundColor = .gray

let sizeConstraints = [
    blackSubview.widthAnchor.constraint(equalToConstant: 200),
    blackSubview.heightAnchor.constraint(equalToConstant: 200),
    graySubview.widthAnchor.constraint(equalToConstant: 100),
    graySubview.heightAnchor.constraint(equalToConstant: 100),
]
let grayWidthConstraint = sizeConstraints[2]
grayWidthConstraint.priority = .defaultHigh
NSLayoutConstraint.activate(sizeConstraints)

var aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

//: Align many items to the same target with the same alignment.

var aRestraint = Restraint(aView, items: [blackSubview, graySubview])
    .alignItems([blackSubview, graySubview], to: [.centerX, .centerY])
aRestraint.activate()

aView

/*:
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

/*:
 The `Alignment` enum describes various possible ways to align items including the sides and centers.
 
 The soft enums: .softTop, .softBottom, .softLeft, .softRight are used for creating inequality constraints to staty within the bounds of the target.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white

aRestraint = Restraint(aView, items: [blackSubview, graySubview])
    .alignItems([blackSubview], to: [.centerX, .centerY])
    .alignItems([graySubview], to: [.centerX, .centerY], of: blackSubview)
aRestraint.activate()

let graySubviewBoundaryRestraint = Restraint(aView)
    .alignItems([graySubview], to: [.softLeft, .softRight], of: blackSubview)
aView

grayWidthConstraint.constant = 300
aView

graySubviewBoundaryRestraint.activate()
aView

/*:
 Alignment can be offset using the offset method on the enums.
 */

aView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
aView.backgroundColor = .white
grayWidthConstraint.isActive = false

aRestraint = Restraint(aView, items: [blackSubview])
    .alignItems([blackSubview], to: [Alignment.top.offset(40), .left, Alignment.right.offset(-80), Alignment.bottom.offset(-40)])
aRestraint.activate()
aView
