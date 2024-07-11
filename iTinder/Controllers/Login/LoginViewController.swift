import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {

    fileprivate lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24, height: 50)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return textField
    }()
    
    fileprivate lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24, height: 50)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return textField
    }()
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 22.5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.clipsToBounds = true
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var backRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back to Register", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapBackRegister), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var overallStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        prepareOverallStackView()
        setupLoginViewModelObserver()
        view.addSubview(backRegisterButton)
        NSLayoutConstraint.activate([
            backRegisterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backRegisterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backRegisterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backRegisterButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9891560674, green: 0.1765951514, blue: 0.4769871831, alpha: 1)
        let bottomColor = #colorLiteral(red: 1, green: 0.3912853599, blue: 0.3719379306, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func prepareOverallStackView() {
        view.addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.axis = .vertical
        overallStackView.distribution = .fillEqually
        overallStackView.spacing = 10
        
        NSLayoutConstraint.activate([
            overallStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    fileprivate func setupLoginViewModelObserver() {
        loginViewModel.isFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            if isFormValid {
                self.loginButton.backgroundColor = UIColor(white: 0, alpha: 1)
            } else {
                self.loginButton.backgroundColor = UIColor(white: 0, alpha: 0.5)
            }
        }
        loginViewModel.isLoggingIn.bind { [unowned self] isRegistering in
            guard let isRegistering else { return }
            if isRegistering {
                self.loginHUD.textLabel.text = "Register"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    @objc fileprivate func didTapBackRegister() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func showHUDWithError(error: Error) {
        loginHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.5)
    }
    
    fileprivate let loginViewModel = LoginViewModel()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    let loginHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func didTapLogin() {
        loginViewModel.performLogin { error in
            self.loginHUD.dismiss()
            if let error = error {
                self.showHUDWithError(error: error)
                return
            }
            print("Successfully Logged in.")
        }
    }
}
