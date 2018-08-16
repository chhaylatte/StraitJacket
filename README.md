#  StraitJacket
StraitJacket is an object oriented autolayout solution designed to do more with less.

## Why
### It will keep devs from hurting themselves
- No xibs or storyboards
- No confusing amalgamations of stackviews and stackview related bugs
- Much faster to write and less error prone than anchor based code and similar libraries
- Much higher skimmability and code density
- Built on top of auto layout

## How it works
### It's just swift code

Constraints are created using the `Restraint` object.  Its methods are capable of creating many constraints at once and are all chainable.  The root view that `Restraint` is init'd with holds the created constraints. Items must be added to the root view for constraints to be built.  The `addItems:` method can be used to add multiple items for convenience.

```swift
let aRestraint = Restraint(self.view)
    .addItems([titleLabel, usernameTextField, passwordTextField, confirmButton])
    .chainVertically([titleLabel, Space(60).withId("space"), usernameTextField, passwordTextField, confirmButton],
                     in: self.view.layoutMarginsGuide)
```

Constraints are not active upon creation. Don't forget to activate the `Restraint`.  

```swift
aRestraint.activate()
```

Constraints can be created with their respective `withId:` methods and priorities can also be added to individual constraints using the respective `withPriority:` methods.  Constraints can be referred to by id.

```swift
let spaceConstraint = aRestraint.constraintWithId("space")
// do something with the constraint
```

### Restraints are composable
```swift
let restraint1A = Restraint(someView)
// make some constraints
let restraint1B = Restraint(someView)
// make some other constraints
let restraint1 = Restraint(someView, subRestraints: [restraint1A, restraint1B])
restraint1.activate()
// activating restraint1 also activates restraint1A and restraint1B
```
### It can use any NSLayoutConstraint
```swift
let aConstraint: NSLayoutConstraint = // some constraint
aRestraint.addConstraints([aConstraint])
```


## Example
See the [Playground](https://github.com/chhaylatte/StraitJacket/blob/master/Playgrounds/Example.playground/Contents.swift)

## Comparison
I will compare various autolayout libraries building the same exact screen.  I will count just layout code including new lines and brackets.  I will omit constraint activiation calls and adding of view items.


### StraitJacket

```swift
// 16 lines of uncondensed layout code
lazy var defaultRestraint: Restraint = {
    let aRestraint = Restraint(self.view)
        .addItems([allItemsBoundaryGuide,
                       titleLabel,
                       usernameTextField,
                       passwordTextField,
                       confirmButton,
                       
                       buttonGuide,
                           secondaryButtonGuide,
                               createAccountButton, dividerLabel, forgotPasswordButton,
                   ])
        .setWidths([allItemsBoundaryGuide.width(260)])
        .alignItems([allItemsBoundaryGuide], to: [.centerX, .centerY, .softLeft, .softRight, .softTop, .softBottom])
        .chainVertically([titleLabel,
                          Space(60),
                          usernameTextField,
                          passwordTextField,
                          confirmButton,
                          Space(30),
                          buttonGuide],
                         in: allItemsBoundaryGuide)
        .alignItems([secondaryButtonGuide], to: [.centerX, .top, .bottom], of: buttonGuide)
        .chainHorizontally([createAccountButton, dividerLabel, forgotPasswordButton],
                           in: secondaryButtonGuide)
    
    return aRestraint
}()
```
```swift
// 10 lines condensed layout code
lazy var defaultRestraint: Restraint = {
    let aRestraint = Restraint(self.view)
        .addItems([allItemsBoundaryGuide, titleLabel, usernameTextField, passwordTextField, confirmButton, buttonGuide, secondaryButtonGuide, createAccountButton, dividerLabel, forgotPasswordButton])
        .setWidths([allItemsBoundaryGuide.width(260)])
        .alignItems([allItemsBoundaryGuide], to: [.centerX, .centerY, .softLeft, .softRight, .softTop, .softBottom])
        .chainVertically([titleLabel, Space(60), usernameTextField, passwordTextField, confirmButton, Space(30), buttonGuide],
                         in: allItemsBoundaryGuide)
        .alignItems([secondaryButtonGuide], to: [.centerX, .top, .bottom], of: buttonGuide)
        .chainHorizontally([createAccountButton, dividerLabel, forgotPasswordButton],
                           in: secondaryButtonGuide)
    
    return aRestraint
}()
```

### SnapKit

I had a great deal of trouble getting this to work.  It turns out that if you create views with frame, or call sizeToFit, SnapKit's constraints don't work correctly.  Certain constraints could have been created using loops, but it makes the code kind of awkward to follow.

```swift
// 60 lines of code.  Cannot be condensed without introducing loops and complexity.
func makeConstraints() {
    
    [allItemsBoundaryGuide, buttonGuide, secondaryButtonGuide].forEach {
        view.addLayoutGuide($0)
    }
    
    [titleLabel, usernameTextField, passwordTextField, confirmButton,
     createAccountButton, dividerLabel, forgotPasswordButton].forEach {
        view.addSubview($0)
    }
    
    allItemsBoundaryGuide.snp.makeConstraints { (make) -> Void in
        make.width.equalTo(260)
        make.center.equalTo(self.view)
    }
    
    titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(allItemsBoundaryGuide)
        make.left.equalTo(allItemsBoundaryGuide)
        make.right.equalTo(allItemsBoundaryGuide)
    }

    usernameTextField.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(60)
        make.left.equalTo(allItemsBoundaryGuide)
        make.right.equalTo(allItemsBoundaryGuide)
    }

    passwordTextField.snp.makeConstraints { (make) in
        make.top.equalTo(usernameTextField.snp.bottom).offset(8)
        make.left.equalTo(allItemsBoundaryGuide)
        make.right.equalTo(allItemsBoundaryGuide)
    }

    confirmButton.snp.makeConstraints { (make) in
        make.top.equalTo(passwordTextField.snp.bottom).offset(8)
        make.left.equalTo(allItemsBoundaryGuide)
        make.right.equalTo(allItemsBoundaryGuide)
    }
    
    buttonGuide.snp.makeConstraints { (make) in
        make.top.equalTo(confirmButton.snp.bottom).offset(30)
        make.bottom.equalTo(allItemsBoundaryGuide)
        make.left.equalTo(allItemsBoundaryGuide)
        make.right.equalTo(allItemsBoundaryGuide)
    }

    secondaryButtonGuide.snp.makeConstraints { (make) in
        make.top.equalTo(buttonGuide)
        make.bottom.equalTo(buttonGuide)
        make.center.equalTo(buttonGuide)
    }
    
    createAccountButton.snp.makeConstraints { (make) in
        make.top.equalTo(secondaryButtonGuide)
        make.bottom.equalTo(secondaryButtonGuide)
        make.left.equalTo(secondaryButtonGuide)
    }

    dividerLabel.snp.makeConstraints { (make) in
        make.top.equalTo(secondaryButtonGuide)
        make.bottom.equalTo(secondaryButtonGuide)
        make.left.equalTo(createAccountButton.snp.right).offset(8)
    }

    forgotPasswordButton.snp.makeConstraints { (make) in
        make.top.equalTo(secondaryButtonGuide)
        make.bottom.equalTo(secondaryButtonGuide)
        make.left.equalTo(dividerLabel.snp.right).offset(8)
        make.right.equalTo(secondaryButtonGuide)
    }
}
```
