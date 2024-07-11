import UIKit
import Firebase
import JGProgressHUD
import FirebaseStorage

final class RegistrationViewController: UIViewController {
    
    let registrationViewModel = RegistrationViewModel()
    
    //  MARK: - Components
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var fullNameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.placeholder = "Enter full name"
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 22.5
        button.titleLabel?.textAlignment = .center
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    fileprivate lazy var goToLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go to Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(didTapGoToLogin), for: .touchUpInside)
        
        return button
    }()
    
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //  MARK: - Private
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    fileprivate let registeringHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        registrationViewModel.performRegistration { [weak self] error in
            if let error = error {
                self?.showHUDWithError(error: error)
                return
            }
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.5)
    }
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = UIColor(white: 0, alpha: 0.5)
            } else {
                self.registerButton.backgroundColor = .darkGray
            }
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] image in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] isRegistering in
            guard let isRegistering else { return }
            if isRegistering {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.transform = .identity
            }
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.transform = .identity
            }
    }
    
    @objc fileprivate func didTapGoToLogin() {
        let loginController = LoginViewController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    fileprivate lazy var  overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        } else {
            overallStackView.axis = .vertical
        }
    }

    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        overallStackView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 50, bottom: 0, right: 50)
        )
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(goToLoginButton)
        NSLayoutConstraint.activate([
            goToLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goToLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    let gradientLayer = CAGradientLayer()
    
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
}
//  MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
