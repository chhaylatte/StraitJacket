#  StraitJacket

## Why
### It will keep devs from hurting themselves
- No xibs or storyboards with their unscalability and unmaintainability
- No confusing amalgamations of stackviews and stackview related bugs
- Much faster to write and less error prone than anchor based code and similar libraries
- Create many constraints per line instead of one per line
- Much higher skimmability and code density
- Built on top of auto layout

## How it works
### It's just swift code

Here's an example:
```swift
let aRestraint = Restraint(self.view)
    .addItems([titleLabel, usernameTextField, passwordTextField, confirmButton])
    .chainVertically([titleLabel, Space(60), usernameTextField, passwordTextField, confirmButton], in: self.view.layoutMarginsGuide)
aRestraint.activate()
```

Constraints are created using the `Restraint` object.  Its methods are capable of creating many constraints at once with a single method call and are all chainable.  All methods are mutating, so repeatedly calling the same constraints creation will create duplicate constraints.  The `Restraint` object is generic and is aware of the type of view it is init'd with.  The root view that `Restraint` is init'd with holds the created constraints.

Items must be added to the `Restraint` for them to be visible to the Restraint's view.  This also serves as a list of all items being laid out by `Restraint` object.

Constraints are not active upon creation.  They must be activated using the `Restraint` object.  Each `Restraint` object maintains a collection of its created constraints.

Specific constraints can be accessed by creating them with an identifier.  Priorities can also be added to individual constraints using their respective `withPriority` functions.
