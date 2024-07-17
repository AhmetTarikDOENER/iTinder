import UIKit
import LBTATools
import FirebaseFirestore
import FirebaseAuth

struct MatchModel {
    let username, profileImageURL: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

final class MatchCell: LBTAListCell<MatchModel> {
    
    fileprivate lazy var profileImageView = UIImageView(image: #imageLiteral(resourceName: "jane3"), contentMode: .scaleAspectFill)
    fileprivate lazy var usernameLabel = UILabel(
        text: "Username",
        font: .systemFont(ofSize: 14, weight: .semibold),
        textColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),
        textAlignment: .center,
        numberOfLines: 2
    )
    
    override var item: MatchModel! {
        didSet {
            usernameLabel.text = item.username
            profileImageView.sd_setImage(with: URL(string: item.profileImageURL))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 40
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        stack(stack(profileImageView, alignment: .center), usernameLabel)
    }
}

final class MatchesMessagesCollectionViewController: LBTAListController<MatchCell, MatchModel> {
    
    fileprivate lazy var customMatchesNavigationBarView = CustomMatchesNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMatches()
        customMatchesNavigationBarView.fireIconButton.addTarget(self, action: #selector(didTapFire), for: .touchUpInside)
        configureHierarchy()
    }
    
    fileprivate func fetchMatches() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserID).collection("matches").getDocuments { 
            snapshot, error in
            guard error == nil else { return }
            var matches = [MatchModel]()
            snapshot?.documents.forEach { docSnapshot in
                let dictionary = docSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            }
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func configureHierarchy() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = view.frame.size.height * 0.12
        view.addSubview(customMatchesNavigationBarView)
        customMatchesNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customMatchesNavigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            customMatchesNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customMatchesNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customMatchesNavigationBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
        ])
    }
    
    @objc fileprivate func didTapFire() {
        navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        let chatController = ChatListController(match: match)
        navigationController?.pushViewController(chatController, animated: true)
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension MatchesMessagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}
