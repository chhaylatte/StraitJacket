//: Playground - noun: a place where people can play

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
    
    lazy var allItemsBoundaryGuide = UILayoutGuide()
    lazy var mainItemsStackView = UIStackView()
    lazy var buttonsStackView = UIStackView()
    lazy var secondaryButtonGuide = UILayoutGuide()
    
    
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = .white
        
        self.view = view
        
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
        
        view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
