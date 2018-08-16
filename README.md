#  StraitJacket
StraitJacket is an object oriented autolayout solution designed for efficient development.  It can create many constraints in one method call and creates only a single type of constraint per method, which increases readability and reduces complexity.

## Why use it
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
I will compare various autolayout libraries building the same exact screen.  I will count just layout code including new lines and brackets.  I will omit constraint activation calls and adding of view items.


### StraitJacket
Adding views is trivial with a single method call and that act creates a list of all items involved as well as provides big picture view of what the layout should look like.  It's also very simple to use custom spacing between views when using the convenience chain method.
```swift
// 13 lines of uncondensed layout code
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
// 7 lines condensed layout code
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

I had some trouble getting this to work.  It turns out that if you create views with frame, or call sizeToFit, layout will have issues.  Certain constraints could have been created using loops, but it makes the code kind of awkward to follow.  I also had to think a lot about if I'm connecting the correct anchors to the correct anchors of correct elements.  This was a pretty tedious process.

```swift
// 63 lines of layout code.  Cannot be condensed without introducing loops and complexity.
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
        make.center.equalTo(view)
        make.left.greaterThanOrEqualTo(view)
        make.right.lessThanOrEqualTo(view)
        make.top.greaterThanOrEqualTo(view)
        make.bottom.lessThanOrEqualTo(view)
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

### PureLayout
PureLayout was a little weird to work with using Swift, since it's Objective-C and forced me to create a bridging header.  It doesn't work with layout guides so I had to use container views which I see as a problem.  Its methods aren't really type safe since as it's possible to insert incorrect enum values that result in crashes.  Its distribute array of views require casting to NSArray and it's not flexible enough.  I had to use a constraint override for custom spacing.

Like SnapKit, initializing views with a frame or calling sizeToFit seems to cause layout issues.

The layout code is pretty hard to follow as its api has array methods which encourages using loops, which results in loops and ordinary methods mixed together.  This kind of code is very difficult to skim.  I also had a lot of bugs because I relied on autofill and got the paramter name wrong several times.  Adding the views into the relevant views was also kind of annoying to do.

```swift
// 29 Lines of code
func makeConstraints() {
    
    [allItemsBoundaryGuide, buttonGuide].forEach {
        view.addSubview($0)
    }
    
    [titleLabel, usernameTextField, passwordTextField, confirmButton].forEach {
        allItemsBoundaryGuide.addSubview($0)
    }
    
    buttonGuide.addSubview(secondaryButtonGuide)
    [createAccountButton, dividerLabel, forgotPasswordButton].forEach {
        secondaryButtonGuide.addSubview($0)
    }
    
    allItemsBoundaryGuide.autoCenterInSuperview()
    allItemsBoundaryGuide.autoSetDimension(.width, toSize: 260)
    
    let allItemsBoundarViews = [titleLabel, usernameTextField, passwordTextField, confirmButton]
    
    (allItemsBoundarViews as NSArray).autoDistributeViews(along: .vertical, alignedTo: .vertical, withFixedSpacing: 8)[1].priority = .defaultLow
    
    (allItemsBoundarViews + [buttonGuide]).forEach { view in
        view.autoAlignAxis(toSuperviewMarginAxis: .vertical)
        view.autoPinEdge(toSuperviewEdge: .left)
        view.autoPinEdge(toSuperviewEdge: .right)
    }
    usernameTextField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 60)
    
    buttonGuide.autoPinEdge(.top, to: .bottom, of: confirmButton, withOffset: 30)
    buttonGuide.autoPinEdge(.bottom, to: .bottom, of: allItemsBoundaryGuide)
    buttonGuide.autoSetDimension(.height, toSize: 30)
    
    secondaryButtonGuide.autoCenterInSuperview()
    secondaryButtonGuide.autoPinEdge(toSuperviewEdge: .top)
    secondaryButtonGuide.autoPinEdge(toSuperviewEdge: .bottom)
    
    let buttonGuideItems = [createAccountButton, dividerLabel, forgotPasswordButton]
    (buttonGuideItems as NSArray).autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 8, insetSpacing: false, matchedSizes: false).forEach {
        $0.priority = .defaultLow
    }
    buttonGuideItems.forEach { item in
        item.autoPinEdge(toSuperviewEdge: .top)
        item.autoPinEdge(toSuperviewEdge: .bottom)
    }
}
```
