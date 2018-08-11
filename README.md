#  StraitJacket

## Why
### It will keep devs from hurting themselves
- No xibs or storyboards
- No confusing amalgamations of stackviews and stackview related bugs
- Much faster to write and less error prone than anchor based code and similar libraries
- Much higher skimmability and code density
- Built on top of auto layout

## How it works
### It's just swift code

Constraints are created using the `Restraint` object.  Its methods are capable of creating many constraints at once with a single method call and are all chainable.  The root view of `Restraint` is init'd with holds the created constraints. Items must be added to the `Restraint` for them to be visible to the Restraint's view.  This also serves as a list of all items being laid out by `Restraint` object.

```swift
let aRestraint = Restraint(self.view)
    .addItems([titleLabel, usernameTextField, passwordTextField, confirmButton])
    .chainVertically([titleLabel, Space(60).withId("space"), usernameTextField, passwordTextField, confirmButton],
                     in: self.view.layoutMarginsGuide)
```

Each `Restraint` object maintains a collection of its created constraints.  Constraints are not active upon creation. Don't forget to activate the `Restraint`.  

```swift
aRestraint.activate()
```

Constraints can be created with their respective `withId:` methods and priorities can also be added to individual constraints using their respective `withPriority:` methods.  Constraints can be referred to by id.

```swift
aRestraint.constraintWithId("space")
// do something with the constraint
```
