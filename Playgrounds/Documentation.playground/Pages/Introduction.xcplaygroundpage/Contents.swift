import UIKit
import StraitJacket

/*:
 # Restraint
 The `Restraint` object is the entry point for working with `StraitJacket.`  To use StraitJacket, start by initializing a `Restraint` object.
 ````
 init(_ view: T, subRestraints: [Restraint] = [], items: [RestraintTargetable] = [])
 ````
 The view that `Restraint` is initiliazed with is the root view of the `Restraint.`  The `subRestraints` are child `Restraint` objects that will be activated and deactivated along with the `Restraint`.  The items array is extra items that should be added to the root view such as subviews.
 */
let aView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

let aSubview = UIView()
aSubview.backgroundColor = .red

let aRestraint = Restraint(aView, items: [aSubview])

/*:
 Use the `Restraint` methods to create constraints.  The constraints are not active on creation.  Call the `activate` method to activate the constraints in the `Restraint`
 */
//:

let aConstraint = aView.widthAnchor.constraint(equalToConstant: 20)
aRestraint.addConstraints([aConstraint])
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

/*:
 # RestraintTargetable
 `RestraintTargetable` is a type in StraitJacket that constraints can reference such as a kind of `UIView` or `UILayoutGuide`.
 */

//: [Next](@next)
