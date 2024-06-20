import UIKit

class RegistrationViewController: UIViewController {
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 18
        
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter full name"
        textField.backgroundColor = .white
        
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        
        return textField
    }()
    
    class CustomTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 45)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton, fullNameTextField, emailTextField, passwordTextField])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 50, bottom: 0, right: -50)
        )
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
