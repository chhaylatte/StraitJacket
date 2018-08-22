//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        aLabel.text = "StraitJacket"
        aLabel.font = UIFont.systemFont(ofSize: 30)
        aLabel.textAlignment = .center
        aLabel.textColor = .black
        aLabel.sizeToFit()
        
        return aLabel
    }()
    
    lazy var usernameTextField: UITextField = {
        let aTextField = UITextField()
        aTextField.placeholder = "username"
        aTextField.borderStyle = .roundedRect
        aTextField.sizeToFit()
        
        return aTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        let aTextField = UITextField()
        aTextField.placeholder = "password"
        aTextField.borderStyle = .roundedRect
        aTextField.isSecureTextEntry = true
        aTextField.sizeToFit()
        
        return aTextField
    }()
    
    lazy var confirmButton: UIButton = {
        let aButton = UIButton(type: .custom)
        aButton.setTitle("Confirm", for: .normal)
        aButton.backgroundColor = .gray
        aButton.sizeToFit()
        
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
        let aLabel = UILabel()
        aLabel.text = "|"
        aLabel.textColor = .black
        aLabel.sizeToFit()
        aLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        aLabel.sizeToFit()
        
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
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = .white
        
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
        
        view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
