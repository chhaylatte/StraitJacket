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
// 48 lines of layout code.  Cannot be condensed without introducing loops and complexity.
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
        make.left.top.greaterThanOrEqualTo(view)
        make.right.bottom.lessThanOrEqualTo(view)
    }
    
    titleLabel.snp.makeConstraints { (make) in
        make.top.left.right.equalTo(allItemsBoundaryGuide)
    }
    
    usernameTextField.snp.makeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(60)
        make.left.right.equalTo(allItemsBoundaryGuide)
    }
    
    passwordTextField.snp.makeConstraints { (make) in
        make.top.equalTo(usernameTextField.snp.bottom).offset(8)
        make.left.right.equalTo(allItemsBoundaryGuide)
    }
    
    confirmButton.snp.makeConstraints { (make) in
        make.top.equalTo(passwordTextField.snp.bottom).offset(8)
        make.left.right.equalTo(allItemsBoundaryGuide)
    }
    
    buttonGuide.snp.makeConstraints { (make) in
        make.top.equalTo(confirmButton.snp.bottom).offset(30)
        make.bottom.left.right.equalTo(allItemsBoundaryGuide)
    }
    
    secondaryButtonGuide.snp.makeConstraints { (make) in
        make.top.bottom.equalTo(buttonGuide)
        make.center.equalTo(buttonGuide)
    }
    
    createAccountButton.snp.makeConstraints { (make) in
        make.top.bottom.left.equalTo(secondaryButtonGuide)
    }
    
    dividerLabel.snp.makeConstraints { (make) in
        make.top.bottom.equalTo(secondaryButtonGuide)
        make.left.equalTo(createAccountButton.snp.right).offset(8)
    }
    
    forgotPasswordButton.snp.makeConstraints { (make) in
        make.top.bottom.right.equalTo(secondaryButtonGuide)
        make.left.equalTo(dividerLabel.snp.right).offset(8)
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

## Layout Anchors
This is the direct way of setting up constraints.  Problems may include forgetting to set translateAutoresizingMask to false.  There's enough text here to build a gigantic wall.

```swift
// 40 lines of layout code
override func updateViewConstraints() {
    if !didSetupConstraints {
        didSetupConstraints = true
        NSLayoutConstraint.activate([
            allItemsBoundaryGuide.widthAnchor.constraint(equalToConstant: 260),
            allItemsBoundaryGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            allItemsBoundaryGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            allItemsBoundaryGuide.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            allItemsBoundaryGuide.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            allItemsBoundaryGuide.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor),
            allItemsBoundaryGuide.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
                titleLabel.topAnchor.constraint(equalTo: allItemsBoundaryGuide.topAnchor),
                titleLabel.leftAnchor.constraint(equalTo: allItemsBoundaryGuide.leftAnchor),
                titleLabel.rightAnchor.constraint(equalTo: allItemsBoundaryGuide.rightAnchor),
                usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
                usernameTextField.leftAnchor.constraint(equalTo: allItemsBoundaryGuide.leftAnchor),
                usernameTextField.rightAnchor.constraint(equalTo: allItemsBoundaryGuide.rightAnchor),
                passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 8),
                passwordTextField.leftAnchor.constraint(equalTo: allItemsBoundaryGuide.leftAnchor),
                passwordTextField.rightAnchor.constraint(equalTo: allItemsBoundaryGuide.rightAnchor),
                confirmButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
                confirmButton.leftAnchor.constraint(equalTo: allItemsBoundaryGuide.leftAnchor),
                confirmButton.rightAnchor.constraint(equalTo: allItemsBoundaryGuide.rightAnchor),
                
                buttonGuide.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 30),
                buttonGuide.bottomAnchor.constraint(equalTo: allItemsBoundaryGuide.bottomAnchor),
                buttonGuide.leftAnchor.constraint(equalTo: allItemsBoundaryGuide.leftAnchor),
                buttonGuide.rightAnchor.constraint(equalTo: allItemsBoundaryGuide.rightAnchor),
                    secondaryButtonGuide.centerYAnchor.constraint(equalTo: buttonGuide.centerYAnchor),
                    secondaryButtonGuide.centerXAnchor.constraint(equalTo: buttonGuide.centerXAnchor),
                    secondaryButtonGuide.topAnchor.constraint(equalTo: buttonGuide.topAnchor),
                    secondaryButtonGuide.bottomAnchor.constraint(equalTo: buttonGuide.bottomAnchor),
                        createAccountButton.topAnchor.constraint(equalTo: secondaryButtonGuide.topAnchor),
                        createAccountButton.bottomAnchor.constraint(equalTo: secondaryButtonGuide.bottomAnchor),
                        createAccountButton.leftAnchor.constraint(equalTo: secondaryButtonGuide.leftAnchor),
                        dividerLabel.topAnchor.constraint(equalTo: secondaryButtonGuide.topAnchor),
                        dividerLabel.bottomAnchor.constraint(equalTo: secondaryButtonGuide.bottomAnchor),
                        dividerLabel.leftAnchor.constraint(equalTo: createAccountButton.rightAnchor, constant: 8),
                        forgotPasswordButton.leftAnchor.constraint(equalTo: dividerLabel.rightAnchor, constant: 8),
                        forgotPasswordButton.topAnchor.constraint(equalTo: secondaryButtonGuide.topAnchor),
                        forgotPasswordButton.bottomAnchor.constraint(equalTo: secondaryButtonGuide.bottomAnchor),
                        forgotPasswordButton.rightAnchor.constraint(equalTo: secondaryButtonGuide.rightAnchor)
            ])
    }
    super.updateViewConstraints()
}
```

## Cartography
Cartography shares some ideas with StraitJacket such as the `ConstraintGroup` and creating many constraints at once.  I didn't like how the constrain function works though.  I was allowed only 10 items but I needed 11 items for this example.  This forced me to make 2 constrain calls.  Also if I wanted to change what items were to be constrained, I had to edit two lists.  This was kind of weird to have to do.  

The DSL itself was very straigtforward.  I didn't have to figure out how something works.  It worked how I expected it.  I had the problem with putting invalid values crashing though, which I did intentionally.  Something like ```view.top == otherView.right```.  No matter what I did I could never get the `distribute(vertically:)` function to work.  It just messes up my layout.  

I didn't like how the DSL is so drastically different.  It mixes operators with things that look like function calls.  It's nitpicky, but that bothered me.

I was very curious how Cartography was implemented.  I checked their code and could not understand a single thing...

```swift
// 42 lines of layout code
constrain(view, allItemsBoundaryGuide, buttonGuide,
          titleLabel, usernameTextField, passwordTextField, confirmButton) { (view, allItemsBoundaryGuide, buttonGuide,
            titleLabel, usernameTextField, passwordTextField, confirmButton) in
            
            allItemsBoundaryGuide.width == 260
            allItemsBoundaryGuide.center == view.center
            
            titleLabel.top == allItemsBoundaryGuide.top
            titleLabel.left == allItemsBoundaryGuide.left
            titleLabel.right == allItemsBoundaryGuide.right
            align(left: [titleLabel, usernameTextField, passwordTextField, confirmButton])
            align(right: [titleLabel, usernameTextField, passwordTextField, confirmButton])
            align(centerX: [titleLabel, usernameTextField, passwordTextField, confirmButton])
            
            usernameTextField.top == titleLabel.bottom + 60
            // distribute(by: 8, vertically: [usernameTextField, passwordTextField, confirmButton]) // this doesn't work?
            passwordTextField.top == usernameTextField.bottom + 8
            confirmButton.top == passwordTextField.bottom + 8
            
            buttonGuide.top == confirmButton.bottom + 30
            buttonGuide.left == allItemsBoundaryGuide.left
            buttonGuide.right == allItemsBoundaryGuide.right
            buttonGuide.bottom == allItemsBoundaryGuide.bottom
}

constrain(view, allItemsBoundaryGuide, confirmButton, buttonGuide, secondaryButtonGuide,
          createAccountButton, dividerLabel,forgotPasswordButton) { (view, allItemsBoundaryGuide, confirmButton, buttonGuide, secondaryButtonGuide,
            createAccountButton, dividerLabel,forgotPasswordButton) in
            
            secondaryButtonGuide.centerX == buttonGuide.centerX
            secondaryButtonGuide.top == buttonGuide.top
            secondaryButtonGuide.bottom == buttonGuide.bottom
            
            createAccountButton.top == secondaryButtonGuide.top
            createAccountButton.bottom == secondaryButtonGuide.bottom
            createAccountButton.left == secondaryButtonGuide.left
            
            align(top: [createAccountButton, dividerLabel, forgotPasswordButton])
            align(bottom: [createAccountButton, dividerLabel, forgotPasswordButton])
            forgotPasswordButton.right == secondaryButtonGuide.right
            
            distribute(by: 8, leftToRight: [createAccountButton, dividerLabel, forgotPasswordButton])
}
```
