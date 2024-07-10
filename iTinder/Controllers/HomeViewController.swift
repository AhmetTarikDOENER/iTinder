import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsBottomStackView = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUserFromFirestore()
    }
    
    func setupFirestoreUserCards() {
        cardViewModels.forEach { cardViewModel in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
 
    @objc fileprivate func handleSettings() {
        let registrationController = RegistrationViewController()
        registrationController.modalPresentationStyle = .fullScreen
        present(registrationController, animated: true)
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        cardsDeckView.heightAnchor.constraint(equalToConstant: 580).isActive = true
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsBottomStackView])
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
    
    fileprivate func fetchUserFromFirestore() {
        let query = Firestore.firestore().collection("users")
//        let query = Firestore.firestore().collection("users").whereField("friends", arrayContains: "David")
        query.getDocuments { snapshot, error in
            if let _ = error { return }
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupFirestoreUserCards()
        }
    }
}

