import UIKit
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD

protocol CurrentUserFetchable: AnyObject {
    func fetchCurrentUser(completion: @escaping (User) -> Void)
}

extension CurrentUserFetchable {
    func fetchCurrentUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard error == nil else { return }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}

class HomeViewController: UIViewController, CurrentUserFetchable {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginController = LoginViewController()
            loginController.delegate = self
            let navVC = UINavigationController(rootViewController: loginController)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        }
    }
    
    func setupFirestoreUserCards() {
        cardViewModels.forEach { cardViewModel in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
    
    //  MARK: - Fileprivate
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        fetchCurrentUser { user in
            self.user = user
            self.fetchUserFromFirestore()
        }
    }
 
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsViewController()
        settingsController.delegate = self
        let navVC = UINavigationController(rootViewController: settingsController)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    @objc fileprivate func didTapRefresh() {
        fetchUserFromFirestore()
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        cardsDeckView.heightAnchor.constraint(equalToConstant: 580).isActive = true
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor
        )
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUserFromFirestore() {
        let minAge = user?.minSeekingAge ?? SettingsViewController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsViewController.defaultMaxSeekingAge
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Finding Users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { snapshot, error in
            hud.dismiss()
            if let _ = error { return }
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    @objc fileprivate func didTapLike() {
        print("Remove")
        topCardView?.removeFromSuperview()
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperView()
        return cardView
    }
}

//  MARK: - CardViewDelegate
extension HomeViewController: CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsViewController = UserDetailsViewController()
        userDetailsViewController.cardViewModel = cardViewModel
        userDetailsViewController.modalPresentationStyle = .fullScreen
        present(userDetailsViewController, animated: true)
    }
}

//  MARK: - SettingsControllerDelegate
extension HomeViewController: SettingsControllerDelegate {
    func didTapSave() {
        fetchCurrentUser()
    }
}

//  MARK: - LoginControllerDelegate
extension HomeViewController: LoginControllerDelegate {
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
}
