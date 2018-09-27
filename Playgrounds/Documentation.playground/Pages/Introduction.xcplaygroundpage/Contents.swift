import UIKit
import StraitJacket

/*:
 # Restraint
 The `Restraint` object is the entry point for working with `StraitJacket.`  To use StraitJacket, start by initializing a `Restraint` object.  The view that `Restraint` is initiliazed with is the root view of the `Restraint.`  The items array is extra items that should be added to the root view such as subviews.
 */
let aView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

let aSubview = UIView()
aSubview.backgroundColor = .red

let aRestraint = Restraint(aView, items: [aSubview])

aView
print("No constraints created yet")
dump(["View Constraints": aView.constraints, "Restraint Constraints": aRestraint.totalConstraints()])

/*:
 Use the `Restraint` methods to create constraints.  The constraints are not active on creation.  Call the `activate` method to activate the constraints in the `Restraint`
 */
//:

aRestraint.alignItems([aSubview], to: [.top, .bottom, .right, .left])
aView
print("\nConstraints created but not activated")
dump(["View Constraints": aView.constraints,
      "Restraint Constraints": aRestraint.totalConstraints()])

aRestraint.activate()
aView
print("\nConstraints activated")
dump(["View Constraints": aView.constraints,
      "Restraint Constraints": aRestraint.totalConstraints()])

//:  Call the `deactivate` method to deactivate the constraints in the `Restraint`
aRestraint.deactivate()
aView
print("\nConstraints deactivated")
dump(["View Constraints": aView.constraints,
      "Restraint Constraints": aRestraint.totalConstraints()])
