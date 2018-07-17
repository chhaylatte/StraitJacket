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
        aButton.setTitleColor(.black, for: .normal)
        aButton.sizeToFit()
        
        return aButton
    }()
    
    lazy var dividerLabel: UILabel = {
        let aLabel = UILabel(frame: .zero)
        aLabel.text = "|"
        aLabel.textColor = .black
        aLabel.sizeToFit()
        
        return aLabel
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let aButton = UIButton(type: .custom)
        aButton.setTitle("Forgot Password", for: .normal)
        aButton.setTitleColor(.black, for: .normal)
        aButton.sizeToFit()
        
        return aButton
    }()
    
    lazy var createForgotButtonGuide = UILayoutGuide()
    lazy var createForgotButtonSubGuide = UILayoutGuide()
    lazy var allItemsBoundaryGuide = UILayoutGuide()
    
    lazy var defaultRestraint: Restraint = {
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
        
        return aRestraint
    }()
    
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 676))
        view.backgroundColor = .white

        self.view = view
        
        defaultRestraint.isActive = true
        
        view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
