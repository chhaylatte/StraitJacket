### StraitJacket
StraitJackets puts all responsibility of creating and managing constraints into a single object.  The code is pretty stylistically simple and has low variation.  This Makes the code very skimmable.  

Adding views is trivial with one method call to add many views which also serves as a list of all relevant views.  Using spacing as needed can provide the big picture view of what the intended layout should look like.  

It's also very simple to specify custom spacing between views using the chain method.

All work is done through the Restraint object.  
```swift
// Layout: 24 lines, 678 characters uncondensed
lazy var defaultRestraint: Restraint = {
    let aRestraint = Restraint(self.view,
        items: [allItemsBoundaryGuide,
                titleLabel,
                usernameTextField,
                passwordTextField,
                confirmButton,
                
                buttonGuide,
                secondaryButtonGuide,
                createAccountButton, dividerLabel, forgotPasswordButton])
        .setSizes(widths: [allItemsBoundaryGuide.equal(260)])
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
// Layout: 6 lines, 678 characters
lazy var defaultRestraint: Restraint = {
    let aRestraint = Restraint(self.view, items: [allItemsBoundaryGuide, titleLabel, usernameTextField, passwordTextField, confirmButton, buttonGuide, secondaryButtonGuide, createAccountButton, dividerLabel, forgotPasswordButton])
        .setSizes(widths: [allItemsBoundaryGuide.equal(260)])
        .alignItems([allItemsBoundaryGuide], to: [.centerX, .centerY, .softLeft, .softRight, .softTop, .softBottom])
        .chainVertically([titleLabel, Space(60), usernameTextField, passwordTextField, confirmButton, Space(30), buttonGuide], in: allItemsBoundaryGuide)
        .alignItems([secondaryButtonGuide], to: [.centerX, .top, .bottom], of: buttonGuide)
        .chainHorizontally([createAccountButton, dividerLabel, forgotPasswordButton], in: secondaryButtonGuide)
    return aRestraint
}()
```

### SnapKit 4.0.0

[SnapKit](https://github.com/SnapKit/SnapKit) works as a more concise version of layout anchors.  Its code is much easier to read through and allows multiple constraint creation at once.

Certain constraints could have been created using loops, but it makes the code kind of awkward to follow.  Like using layout anchors, the developer must be cautious when connecting anchors or lots of grief would result.  This was a pretty tedious process but nowhere nearly as much as layout anchors.  SnapKit tries to hide constraints from the developer but they can be referenced by calling `.constraint.layoutConstraints` after each make constraint call.

```swift
// Layout: 58 lines: 1608 characters
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
[PureLayout](https://github.com/PureLayout/PureLayout) was a little weird to work with using Swift, since it's written in Objective-C.  It doesn't work with layout guides so I had to use container views which I see as a problem.  Its methods aren't really type safe since as it's possible to insert incorrect enum values that result in crashes.  Its distribute array of views require casting to NSArray.  I used a constraint override for custom spacing instead of breaking up loops to emphasize the intent of distributing views.

The layout code is pretty hard to follow as its api has array methods which encourages using loops, which results in different logical styles being mixed.  This kind of code is very difficult to skim through.  I also had a lot of bugs because I relied on autofill and got the parameter name wrong several times.

```swift
// layout: 37 lines, 1768 characters
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
This is the direct way of setting up constraints.  Problems may include forgetting to set translateAutoresizingMask to false.  This gigantic wall of text is kind of intimidating and mind numbing to read through.  Comments may help a lot with this style.  Since these methods return constraints directly, referencing them is pretty natural.

```swift
// layout: 50 lines, 3307 characters
[allItemsBoundaryGuide, buttonGuide, secondaryButtonGuide].forEach {
    view.addLayoutGuide($0)
}

[titleLabel, usernameTextField, passwordTextField, confirmButton,
 createAccountButton, dividerLabel, forgotPasswordButton].forEach {
    $0.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview($0)
}

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
```

## UIStackView
Stackviews can assist with layout views out in succession, but they bring their own problems too.  They require a bit of configuration to get working properly and require extra work when weirder layouts are needed.  They force the use of container views if various centering is needed.  Views may disappear and make development difficult, and may lead to unexpected bugs at runtime.  Sometimes this makes developers create unneeded size constraints in the stack view's content views because layout isn't working as expected.

Stack views do not save us from the need to use constraints.  We still need way to layout the stack views.  Custom spacing is achievable in stackviews but it necessarily separates it from the main constraint building code.

```swift
// layout: 44 lines, 1972 characters
[mainItemsStackView, buttonsStackView].forEach {
    view.addSubview($0)
    $0.translatesAutoresizingMaskIntoConstraints = false
}

view.addLayoutGuide(allItemsBoundaryGuide)

mainItemsStackView.spacing = 8
mainItemsStackView.alignment = .fill
mainItemsStackView.distribution = .fill
mainItemsStackView.axis = .vertical
mainItemsStackView.setCustomSpacing(60, after: titleLabel)
[titleLabel, usernameTextField, passwordTextField, confirmButton].forEach {
    mainItemsStackView.addArrangedSubview($0)
}

buttonsStackView.spacing = 8
buttonsStackView.alignment = .fill
buttonsStackView.distribution = .fill
buttonsStackView.axis = .horizontal
[createAccountButton, dividerLabel, forgotPasswordButton].forEach {
    buttonsStackView.addArrangedSubview($0)
}
buttonsStackView.sizeToFit()    // doesn't layout without this

NSLayoutConstraint.activate([
    allItemsBoundaryGuide.widthAnchor.constraint(equalToConstant: 260),
    allItemsBoundaryGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
    allItemsBoundaryGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    allItemsBoundaryGuide.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
    allItemsBoundaryGuide.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor),
    allItemsBoundaryGuide.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
    allItemsBoundaryGuide.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
    
    mainItemsStackView.topAnchor.constraint(equalTo: allItemsBoundaryGuide.topAnchor),
    mainItemsStackView.leftAnchor.constraint(equalTo: allItemsBoundaryGuide.leftAnchor),
    mainItemsStackView.rightAnchor.constraint(equalTo: allItemsBoundaryGuide.rightAnchor),
    
    buttonsStackView.topAnchor.constraint(equalTo: mainItemsStackView.bottomAnchor, constant: 30),
    buttonsStackView.centerXAnchor.constraint(equalTo: allItemsBoundaryGuide.centerXAnchor),
    buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
    buttonsStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
    buttonsStackView.bottomAnchor.constraint(equalTo: allItemsBoundaryGuide.bottomAnchor),
    ])
```

## Cartography 3.0.2
[Cartography](https://github.com/robb/Cartography) shares some ideas with StraitJacket such as the `ConstraintGroup` and creating many constraints at once.  I didn't like how the constrain function works.  I was allowed only 10 items but I needed 11 items for this example.  This forced me to make 2 constrain calls.  Also if I wanted to change what items were to be constrained, I had to edit two lists.  Copying a constraint also requires creating another constrain call.  Getting autofill to have the right amount of items is a challenge.

The DSL itself was very straigtforward.  It worked how I expected it.  I had the problem with putting invalid values crashing though, which I did intentionally.  Something like ```view.top == otherView.right```.  

It turns out that `distribute(vertically:)` method turns sets `translatesAutoresizingMaskIntoConstraints = true`, so I had to turn it off manually after the constrain function.

I was very curious how Cartography was implemented.  I checked their code and could not understand a single thing...

```swift
// layout: 49 lines, 1961 characters
[allItemsBoundaryGuide, buttonGuide, secondaryButtonGuide].forEach {
    view.addLayoutGuide($0)
}

[titleLabel, usernameTextField, passwordTextField, confirmButton,
 createAccountButton, dividerLabel, forgotPasswordButton].forEach {
    view.addSubview($0)
}

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
I am genuinely impressed with [Stevia](https://github.com/freshOS/Stevia).  Its api is very easy to pick up, easy to use, and very clean.  It has a few drawbacks like it has multiple personality disorder, visual layout doesn't work with layout guides, forces layout priorties to be 750, and doesn't seem to allow a way to get the created constraints.  Setting the layout priorities in visual layout may not work as expected and just brings confusion.  Having a nested view structure may lead to nesting hell with the `sv` calls, but this can be avoided by simply not nesting them.  If these are not issues for layout needs, then Stevia can do the job pretty well.  Personally I don't like the non uniform look of the code.

```swift
// layout: 41 lines, 614 characters
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
