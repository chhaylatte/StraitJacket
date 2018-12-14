//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import StraitJacket

class MyViewController : UIViewController {
    
    lazy var titleLabel: UILabel = {
        let aLabel = UILabel(frame: .zero)
        aLabel.text = "StraitJacket"
        aLabel.font = UIFont.systemFont(ofSize: 30)
        aLabel.textAlignment = .center
        aLabel.textColor = .black
        aLabel.sizeToFit()
        aLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return aLabel
    }()
    
    lazy var usernameTextField: UITextField = {
        let aTextField = UITextField(frame: .zero)
        aTextField.placeholder = "username"
        aTextField.borderStyle = .roundedRect
        
        return aTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        let aTextField = UITextField(frame: .zero)
        aTextField.placeholder = "password"
        aTextField.borderStyle = .roundedRect
        aTextField.isSecureTextEntry = true
        
        return aTextField
    }()
    
    lazy var confirmButton: UIButton = {
        let aButton = UIButton(type: .custom)
        aButton.setTitle("Confirm", for: .normal)
        aButton.backgroundColor = .gray
        
        return aButton
    }()
    
    lazy var createAccountButton: UIButton = {
        let aButton = UIButton(type: .custom)
        aButton.setTitle("Create Account", for: .normal)
        aButton.setTitleColor(.blue, for: .normal)
        aButton.sizeToFit()
        
        return aButton
    }()
    
    lazy var dividerLabel: UILabel = {
        let aLabel = UILabel(frame: .zero)
        aLabel.text = "|"
        aLabel.textColor = .black
        aLabel.sizeToFit()
        aLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return aLabel
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let aButton = UIButton(type: .custom)
        aButton.setTitle("Forgot Password", for: .normal)
        aButton.setTitleColor(.blue, for: .normal)
        aButton.sizeToFit()
        
        return aButton
    }()
    
    lazy var buttonGuide = UILayoutGuide()
    lazy var secondaryButtonGuide = UILayoutGuide()
    lazy var allItemsBoundaryGuide = UILayoutGuide()
    
    lazy var defaultRestraint: Restraint = {
        
        // The `Restraint` object handles constraint creation and activation.
        // It must be created with a root view which holds created constraints
        // The root view serves as the default value for many constraint building methods
        let aRestraint = Restraint(self.view,
            // Views must be added to the root view before they can take part in constraint creation.
            // This also serves as a list of every item laid out within the root view.
            // Using spacing can help with getting an overall idea of the entire layout.
            items: [allItemsBoundaryGuide,
                    titleLabel,
                    usernameTextField,
                    passwordTextField,
                    confirmButton,
                    
                    buttonGuide,
                    secondaryButtonGuide,
                    createAccountButton, dividerLabel, forgotPasswordButton])
            .setSizes(widths: [allItemsBoundaryGuide.equal(size: 260)])
            .alignItems([allItemsBoundaryGuide], to: [.centerX, .centerY, .softLeft, .softRight, .softTop, .softBottom])
            .chainVertically([titleLabel,
                              Space.equal(60),
                              usernameTextField,
                              passwordTextField,
                              confirmButton,
                              Space.equal(30),
                              buttonGuide],
                             in: allItemsBoundaryGuide)
            .alignItems([secondaryButtonGuide], to: [.centerX, .top, .bottom], of: buttonGuide)
            .chainHorizontally([createAccountButton, dividerLabel, forgotPasswordButton],
                               in: secondaryButtonGuide)
        
        return aRestraint
    }()
    
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = .white
        
        self.view = view
        
        // Don't forget to activate the constraints.
        defaultRestraint.activate()
        
        view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
