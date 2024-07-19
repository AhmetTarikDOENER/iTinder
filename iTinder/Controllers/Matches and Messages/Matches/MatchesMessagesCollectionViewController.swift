import UIKit
import LBTATools
import FirebaseFirestore
import FirebaseAuth

final class MatchesMessagesCollectionViewController: LBTAListHeaderController<RecentMessagesCell, RecentMessages, MatchesHeaderReusableView> {
    
    fileprivate lazy var customMatchesNavigationBarView = CustomMatchesNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecentMessages()
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header_reuse_identifier"
        )
        customMatchesNavigationBarView.fireIconButton.addTarget(self, action: #selector(didTapFire), for: .touchUpInside)
        configureHierarchy()
    }
    
    //  MARK: - Fileprivate:
    fileprivate func configureHierarchy() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = view.frame.size.height * 0.12
        let customBarViewCover = UIView(backgroundColor: .white)
        view.addSubview(customBarViewCover)
        customBarViewCover.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customMatchesNavigationBarView)
        customMatchesNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customMatchesNavigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            customMatchesNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customMatchesNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customMatchesNavigationBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            customBarViewCover.topAnchor.constraint(equalTo: view.topAnchor),
            customBarViewCover.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customBarViewCover.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customBarViewCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    fileprivate var recentMessagesDictionary = [String: RecentMessages]()
    
    fileprivate var snapshotListener: ListenerRegistration?
    
    fileprivate func fetchRecentMessages() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        snapshotListener =  Firestore.firestore().collection("matches_messages").document(currentUserID).collection("recent_messages").addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            querySnapshot?.documentChanges.forEach { documentChanged in
                if documentChanged.type == .added || documentChanged.type == .modified {
                    let dictionary = documentChanged.document.data()
                    let recentMessage = RecentMessages(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessage.uid] = recentMessage
                }
            }
            self.resetItems()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            snapshotListener?.remove()
        }
    }
    
    fileprivate func resetItems() {
        var values = Array(recentMessagesDictionary.values)
        items = values.sorted { $0.timestamp.compare($1.timestamp) == .orderedDescending }
        collectionView.reloadData()
    }
    
    @objc fileprivate func didTapFire() {
        navigationController?.popViewController(animated: true)
    }
    
    override func setupHeader(_ header: MatchesHeaderReusableView) {
        header.midHorizontalViewController.rootController = self
    }
    
    func didSelectMatchFromHeader(match: Match) {
        let chatViewController = ChatListController(match: match)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension MatchesMessagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentMessage = self.items[indexPath.item]
        let dictionary = [
            "username": recentMessage.username,
            "profileImageURL": recentMessage.profileImageURL,
            "uid": recentMessage.uid
        ]
        let match = Match(dictionary: dictionary)
        let controller = ChatListController(match: match)
        navigationController?.pushViewController(controller, animated: true)
    }
}
//  MARK: - MatchesHeaderReusableView:
extension MatchesMessagesCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: view.frame.width, height: 250)
    }
}
