import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsViewController: UITableViewController {
    
    lazy var image1Button = createButton(selector: #selector(didTapSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(didTapSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(didTapSelectPhoto))
    
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        setupNavigationItems()
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        ]
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        header.addSubview(image1Button)
        
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: 0, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        image1Button.heightAnchor.constraint(equalTo: header.heightAnchor, constant: -2*padding).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        header.addSubview(stackView)
        stackView.anchor(
            top: header.topAnchor,
            leading: image1Button.trailingAnchor,
            bottom: header.bottomAnchor,
            trailing: header.trailingAnchor,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16)
        )
        stackView.heightAnchor.constraint(equalTo: header.heightAnchor, multiplier: 1, constant: -2*padding).isActive = true
        return header
    }()
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard error == nil else { return }
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.tableView.reloadData()
        }
    }
    
    @objc fileprivate func didTapSelectPhoto(button: UIButton) {
        let pickerController = CustomImagePickerController()
        pickerController.imageButton = button
        pickerController.delegate = self
        present(pickerController, animated: true)
    }

    @objc fileprivate func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func didTapSave() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func didTapLogout() {
        dismiss(animated: true)
    }
}

//  MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}

//  MARK: - UITableViewDelegate, UITableViewDatasource
extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1: 
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default: cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 18, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1: headerLabel.text = "Name"
        case 2: headerLabel.text = "Profession"
        case 3: headerLabel.text = "Age"
        default: headerLabel.text = "Bio"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
}
