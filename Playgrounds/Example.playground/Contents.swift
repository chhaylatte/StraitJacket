//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import StraitJacket

class MyViewController : UIViewController {
    
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
    
    lazy var secondaryButtonGuide = UILayoutGuide()
    lazy var secondaryButtonFlexibleGuide = UILayoutGuide()
    lazy var allItemsBoundaryGuide = UILayoutGuide()
    
    lazy var defaultRestraint: Restraint = {
        
        let aRestraint = Restraint(self.view)
            .addItems([allItemsBoundaryGuide,
                           usernameTextField,
                           passwordTextField,
                           confirmButton,
                           
                           secondaryButtonGuide,
                               secondaryButtonFlexibleGuide,
                                   createAccountButton, dividerLabel, forgotPasswordButton,
                       ])
            .alignItems([allItemsBoundaryGuide], to: [.centerX, .centerY, .softLeft, .softRight, .softTop, .softBottom])
            .alignItems([secondaryButtonFlexibleGuide], to: [.centerX, .top, .bottom, .softLeft, .softRight], of: secondaryButtonGuide)
            .chainVertically([usernameTextField,
                              passwordTextField,
                              confirmButton,
                              secondaryButtonGuide],
                             in: allItemsBoundaryGuide, pinningOnAxis: .normal)
            .chainHorizontally([createAccountButton, dividerLabel, forgotPasswordButton],
                               in: secondaryButtonFlexibleGuide)
        
        return aRestraint
    }()
    
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = .white
        
        self.view = view
        
        defaultRestraint.activate()
        
        view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
