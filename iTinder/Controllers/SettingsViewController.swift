import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
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
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageURL = user?.imageURL1, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageURL = user?.imageURL2, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageURL = user?.imageURL3, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
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
    
    @objc fileprivate func didTapLogout() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func didTapSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "fullname": user?.name ?? "",
            "imageURL1": user?.imageURL1 ?? "",
            "imageURL2": user?.imageURL2 ?? "",
            "imageURL3": user?.imageURL3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
        ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Profile"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            guard error == nil else { return }
            hud.dismiss(animated: true)   
        }
    }
}

//  MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image"
        hud.show(in: view)
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        reference.putData(uploadData) { _, error in
            hud.dismiss()
            guard error == nil else {
                print("Failed to upload image to storage")
                return
            }
            reference.downloadURL { url, error in
                hud.dismiss()
                guard error == nil else { return }
                print("Downloaded url:", url?.absoluteString ?? "")
                if imageButton == self.image1Button {
                    self.user?.imageURL1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageURL2 = url?.absoluteString
                } else {
                    self.user?.imageURL3 = url?.absoluteString
                }
            }
        }
    }
}

//  MARK: - UITableViewDelegate, UITableViewDatasource
extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeTableViewCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(didTapMinSlider), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(didTapMaxSlider), for: .valueChanged)
            ageRangeCell.minLabel.text = "Min: \(user?.minSeekingAge ?? -1)"
            ageRangeCell.minLabel.text = "Max: \(user?.maxSeekingAge ?? -1)"
            return ageRangeCell
        }
        let cell = SettingsTableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1: 
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(didChangeName), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(didChangeProfession), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(didChangeAge), for: .editingChanged)
        default: cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func didTapMinSlider(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeTableViewCell
        ageRangeCell.minLabel.text = "Min: " + String(format: "%.0f", slider.value)
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func didTapMaxSlider(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeTableViewCell
        ageRangeCell.maxLabel.text = "Max: " + String(format: "%.0f", slider.value)
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func didChangeName(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func didChangeProfession(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func didChangeAge(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
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
        case 4: headerLabel.text = "Bio"
        default: headerLabel.text = "Seeking Age Range"
        }
        headerLabel.font = .boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
}
