import UIKit
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD

//  MARK: - CurrentUserFetchable
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

class HomeViewController: UIViewController, CurrentUserFetchable, UIGestureRecognizerDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        topStackView.settingsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(didTapMessages), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(didTapDislike), for: .touchUpInside)
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
            self.fetchSwipes()
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, error in
            guard error == nil else { return }
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
            self.fetchUserFromFirestore()
        }
    }
    
    @objc fileprivate func didTapMessages() {
        let vc = MatchesMessagesCollectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
 
    @objc fileprivate func didTapSettings() {
        let settingsController = SettingsViewController()
        settingsController.delegate = self
        let navVC = UINavigationController(rootViewController: settingsController)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    @objc fileprivate func didTapRefresh() {
        cardsDeckView.subviews.forEach { $0.removeFromSuperview() }
        fetchUserFromFirestore()
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        cardsDeckView.heightAnchor.constraint(equalToConstant: 580).isActive = true
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overallStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overallStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    var lastFetchedUser: User?
    var users = [String: User]()
    
    fileprivate func fetchUserFromFirestore() {
        let minAge = user?.minSeekingAge ?? SettingsViewController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsViewController.defaultMaxSeekingAge
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Finding Users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { snapshot, error in
            hud.dismiss()
            if let _ = error { return }
            /// Linked List
            var previousCardView: CardView?
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.users[user.uid ?? ""] = user
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.49
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.duration = duration
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    @objc func didTapLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        let docData = [cardUID: didLike]
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, error in
            guard error == nil else { return }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(docData) { error in
                    guard error == nil else { return }
                    if didLike == 1 {
                        self.checkIfMatchExist(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(docData) { error in
                    guard error == nil else { return }
                    if didLike == 1 {
                        self.checkIfMatchExist(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExist(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { snapshot, error in
            guard error == nil else { return }
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
                guard let cardUser = self.users[cardUID] else { return }
                let docData = ["username": cardUser.name ?? "", "profileImageURL": cardUser.imageURL1 ?? "", "uid": cardUID]
                Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUID).setData(docData) {
                    error in
                    guard error == nil else { return }
                }
                guard let currentUser = self.user else { return }
                let currentUsersDocData = ["username": currentUser.name ?? "", "profileImageURL": currentUser.imageURL1 ?? "", "uid": cardUID]
                Firestore.firestore().collection("matches_messages").document(cardUID).collection("matches").document(uid).setData(currentUsersDocData) {
                    error in
                    guard error == nil else { return }
                }
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperView()
    }
    
    @objc func didTapDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
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
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
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
