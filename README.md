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
I will compare various autolayout libraries building the same exact screen.  I will count just layout code including new lines and brackets.  I will omit constraint activation calls, adding of view items, return statements, and function declarations.  I will also count the total character counts excluding spaces using the character count tool.

### Summary of Comparison
The following is the line and character count comparison of various layout libraries normalized to the StraitJacket example layout.

### Layout Code Metrics

#### Line and character metrics for layout code only

|            | StraitJacket | SnapKit | PureLayout | Layout Anchors | Cartography | Stevia |
|------------|--------------|---------|------------|----------------|-------------|--------|
| Lines      |            7 |      49 |         27 |             40 |          40 |     29 |
| Characters |          494 |    1374 |       1522 |           3023 |        1727 |    429 |
| Lines/Char |        70.57 |   28.04 |      56.37 |          75.58 |       43.18 |  14.79 |

#### Line and character metrics normalized to StraitJacket

|                         | StraitJacket | SnapKit | PureLayout | Layout Anchors | Cartography | Stevia |
|-------------------------|--------------|---------|------------|----------------|-------------|--------|
| Lines/StraitJacket      |            1 |       7 |       3.86 |           5.71 |        5.71 |   4.14 |
| Characters/StraitJacket |            1 |    2.78 |       3.08 |           6.12 |        3.50 |   0.87 |

#### Total line and character metrics to add all views and layout all views

|                               | StraitJacket | Stevia |
|-------------------------------|--------------|--------|
| Total Lines                   |            9 |     41 |
| Total Characters              |          676 |    614 |
| Total Lines/StraitJacket      |            1 |   4.56 |
| Total Characters/StraitJacket |            1 |   0.91 |

### StraitJacket
Adding views is trivial with a single method call and that act creates a list of all items involved as well as provides big picture view of what the layout should look like.  It's also very simple to use custom spacing between views when using the convenience chain method.
```swift
// 13 lines of uncondensed layout code
// 494 characters excluding spaces for layout
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
// 494 characters for layout
// 9 lines to add views an layout
// 676 characters to add views and layout
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

### SnapKit 4.0.0

SnapKit works as a more concise version of layout anchors.  Its code is much easier to read through and allows multiple constraint creation at once.

Certain constraints could have been created using loops, but it makes the code kind of awkward to follow.  I also had to think a lot about if I'm connecting the correct anchors to the correct anchors of correct elements.  This was a pretty tedious process but not as much as layout anchors.

```swift
// 49 lines for layout
// 1374 characters for layout
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

### PureLayout 3.0.2
PureLayout was a little weird to work with using Swift, since it's Objective-C.  It doesn't work with layout guides so I had to use container views which I see as a problem.  Its methods aren't really type safe since as it's possible to insert incorrect enum values that result in crashes.  Its distribute array of views require casting to NSArray.  I used a constraint override for custom spacing instead of breaking up loops to emphasize distributing views.

The layout code is pretty hard to follow as its api has array methods which encourages using loops, which results in different logical styles being mixed.  This kind of code is very difficult to skim.  I also had a lot of bugs because I relied on autofill and got the paramter name wrong several times.  Adding the views into the relevant views was also kind of annoying to do.  I was able to avoid nesting some views, but this is more trouble then its worth since containment produces more stable layout then aligning views on top of another.

```swift
// 27 lines for layout
// 1522 characters for
func makeConstraints() {
    [allItemsBoundaryGuide,
     titleLabel, usernameTextField, passwordTextField, confirmButton,
     buttonGuide, secondaryButtonGuide].forEach {
        view.addSubview($0)
    }
    
    [createAccountButton, dividerLabel, forgotPasswordButton].forEach {
        secondaryButtonGuide.addSubview($0)
    }
    
    let allItemsBoundarViews: NSArray = [titleLabel, usernameTextField, passwordTextField, confirmButton, buttonGuide]
    let alignAllItems = ([allItemsBoundaryGuide] + allItemsBoundarViews as NSArray)
    let leftAndRightSides = [ALEdge.left, .right]
    let topAndBottomSides = [ALEdge.top, .bottom]
    
    allItemsBoundaryGuide.autoCenterInSuperview()
    allItemsBoundaryGuide.autoSetDimension(.width, toSize: 260)
    
    titleLabel.autoPinEdge(.top, to: .top, of: allItemsBoundaryGuide)
    leftAndRightSides.forEach { alignAllItems.autoAlignViews(to: $0) }
    allItemsBoundarViews.autoDistributeViews(along: .vertical, alignedTo: .vertical, withFixedSpacing: 8, insetSpacing: false, matchedSizes: false).forEach { $0.priority = .defaultLow }
    buttonGuide.autoPinEdge(.bottom, to: .bottom, of: allItemsBoundaryGuide)
    
    usernameTextField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 60)
    buttonGuide.autoPinEdge(.top, to: .bottom, of: confirmButton, withOffset: 30)
    
    secondaryButtonGuide.autoAlignAxis(.vertical, toSameAxisOf: buttonGuide)
    topAndBottomSides.forEach {
        secondaryButtonGuide.autoPinEdge($0, to: $0, of: buttonGuide)
    }
    
    let secondaryButtonItems: NSArray = [createAccountButton, dividerLabel, forgotPasswordButton]
    let alignItems: NSArray = secondaryButtonItems + [secondaryButtonGuide] as NSArray
    topAndBottomSides.forEach { alignItems.autoAlignViews(to: $0) }
    secondaryButtonItems.autoDistributeViews(along: .horizontal, alignedTo: .horizontal, withFixedSpacing: 8, insetSpacing: false, matchedSizes: false)
    createAccountButton.autoPinEdge(.left, to: .left, of: secondaryButtonGuide)
    forgotPasswordButton.autoPinEdge(.right, to: .right, of: secondaryButtonGuide)
}
```

## Layout Anchors
This is the direct way of setting up constraints.  Problems may include forgetting to set translateAutoresizingMask to false.  This gigantic wall of text is kind of intimidating.

```swift
// 40 lines for layout
// 3023 characters for layout
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

## Cartography 3.0.2
Cartography shares some ideas with StraitJacket such as the `ConstraintGroup` and creating many constraints at once.  I didn't like how the constrain function works though.  I was allowed only 10 items but I needed 11 items for this example.  This forced me to make 2 constrain calls.  Also if I wanted to change what items were to be constrained, I had to edit two lists.  This was kind of weird to have to do.  Copying a constraint also requires creating another constrain call.  Getting autofill to have the right amount of items is a challenge.

The DSL itself was very straigtforward.  It worked how I expected it.  I had the problem with putting invalid values crashing though, which I did intentionally.  Something like ```view.top == otherView.right```.  

It turns out that `distribute(vertically:)` method turns sets `translatesAutoresizingMaskIntoConstraints = true`, so I had to turn it off manually after the constrain function.

I was very curious how Cartography was implemented.  I checked their code and could not understand a single thing...

```swift
// 40 lines for layout
// 1727 characters for layout
constrain(view, allItemsBoundaryGuide, buttonGuide,
          titleLabel, usernameTextField, passwordTextField, confirmButton) { (view, allItemsBoundaryGuide, buttonGuide,
            titleLabel, usernameTextField, passwordTextField, confirmButton) in

            allItemsBoundaryGuide.width == 260
            allItemsBoundaryGuide.center == view.center

            titleLabel.top == allItemsBoundaryGuide.top

            align(left: [allItemsBoundaryGuide, titleLabel, usernameTextField, passwordTextField, confirmButton, buttonGuide])
            align(right: [allItemsBoundaryGuide, titleLabel, usernameTextField, passwordTextField, confirmButton, buttonGuide])
            align(centerX: [allItemsBoundaryGuide, titleLabel, usernameTextField, passwordTextField, confirmButton])

            usernameTextField.top == titleLabel.bottom + 60
             distribute(by: 8, vertically: [usernameTextField, passwordTextField, confirmButton]) // This turns on autoresizing mask constraints!

            buttonGuide.top == confirmButton.bottom + 30
            buttonGuide.bottom == allItemsBoundaryGuide.bottom
}

constrain(confirmButton, buttonGuide, secondaryButtonGuide,
          createAccountButton, dividerLabel,forgotPasswordButton) { (confirmButton, buttonGuide, secondaryButtonGuide,
            createAccountButton, dividerLabel,forgotPasswordButton) in

            secondaryButtonGuide.centerX == buttonGuide.centerX
            secondaryButtonGuide.top == buttonGuide.top
            secondaryButtonGuide.bottom == buttonGuide.bottom

            createAccountButton.left == secondaryButtonGuide.left

            align(top: [secondaryButtonGuide, createAccountButton, dividerLabel, forgotPasswordButton])
            align(bottom: [secondaryButtonGuide, createAccountButton, dividerLabel, forgotPasswordButton])
            distribute(by: 8, leftToRight: [createAccountButton, dividerLabel, forgotPasswordButton])

            forgotPasswordButton.right == secondaryButtonGuide.right
}

[usernameTextField, passwordTextField, confirmButton].forEach {
    $0.translatesAutoresizingMaskIntoConstraints = false
}
```

## Stevia 4.3.0
I am genuinely impressed with Stevia.  Its api is very easy to pick up, easy to use, and very clean.  It has a few drawbacks like it has multiple personality disorder, visual layout doesn't work with layout guides, forces layout priorties to be 750, and doesn't seem to allow a way to get the created constraints.  Setting the layout priorities in visual layout may not work as expected and just brings confusion.  Having a nested view structure may be confusing or lead to nesting hell with the `sv` calls, but this can be avoided with specialized subviews instead.  This has the tradeoff of making yet more views to manage.  If these are not huge issues for layout needs, then Stevia can do the job extremely well.

Stevia has the distinction of having hot reloading, and it's native.  I may have to steal this idea in the future.

```swift
// 29 lines for layout
// 429 characters for layout
// 41 lines to add views and layout
// 614 to add views and layout
sv(allItemsBoundaryGuide
    .sv(titleLabel,
        usernameTextField,
        passwordTextField,
        confirmButton,
        buttonGuide
            .sv(secondaryButtonGuide
                .sv(createAccountButton, dividerLabel, forgotPasswordButton)
            )
    )
)

layout(
    >=0,
    |-(>=0)-allItemsBoundaryGuide-(>=0)-|,
    >=0
)

allItemsBoundaryGuide.width(260)
allItemsBoundaryGuide.centerInContainer()
allItemsBoundaryGuide.layout(
    0,
    |-titleLabel-|,
    30,
    |-usernameTextField-|,
    8,
    |-passwordTextField-|,
    8,
    |-confirmButton-|,
    30,
    |-buttonGuide-|,
    0
)

secondaryButtonGuide.centerInContainer()
secondaryButtonGuide.top(0).bottom(0)
secondaryButtonGuide.layout(
    0,
    |-createAccountButton-dividerLabel-forgotPasswordButton-|,
    0
)
```
