#  StraitJacket

## Why
### It will keep you from hurting yourself
- Not xibs or storyboards (because these are not very scalable or maintainable)
- Not stackviews (views tend to disappear or you need to use container views)
- Much faster to write and less error prone than anchor based code and similar libraries
- Create many constraints per line instead of one per line
- Much higher skimmability and code density (Spend less time reading text and more time understanding layout)

## How it works
### It's all swift code.  There is no DSL to learn.

Here's a working example:
```swift
let aRestraint = Restraint(self.view)
            .addItems([usernameTextField,
                       passwordTextField,
                       confirmButton,
                       createAccountButton, dividerLabel, forgotPasswordButton,
                       createForgotButtonGuide, createForgotButtonSubGuide,
                       allItemsBoundaryGuide])
            .alignItems([allItemsBoundaryGuide], to: [.centerX, .centerY])
            .alignItems([createForgotButtonSubGuide], to: [.centerX, .top, .bottom, .softLeft, .softRight], of: createForgotButtonGuide)
            .chainVertically([usernameTextField,
                              passwordTextField,
                              confirmButton,
                              createForgotButtonGuide], in: allItemsBoundaryGuide)
            .chainHorizontally([createAccountButton, dividerLabel, forgotPasswordButton],
                               in: createForgotButtonSubGuide)
aRestraint.isActive = true
```

Constraints are created using the `Restraint` object.  Its methods are capable of creating many constraints at once with a single method call and are all chainable.  All methods are mutating, so repeatedly calling the same constraints creation will create duplicate constraints.  The `Restraint` object is generic and is aware of the type of view it is init'd with.  The root view that `Restraint` is init'd with holds the created constraints.

Items must be added to the `Restraint` for them to be visible to the Restraint's view.  This also serves as a list of all items being laid out by `Restraint` object.

Constraints are not active upon creation.  They must be activated using the `Restraint` object.  Each `Restraint` object maintains a collection of its created constraints.

Specific constraints can be accessed by creating them with an identifier.  Priorities can also be added to individual constraints using their respective `withPriority` functions.
