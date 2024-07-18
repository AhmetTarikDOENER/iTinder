import UIKit
import LBTATools
import FirebaseFirestore
import FirebaseAuth

final class MatchesMessagesCollectionViewController: LBTAListHeaderController<MatchCell, MatchModel, MatchesHeaderReusableView> {
    
    fileprivate lazy var customMatchesNavigationBarView = CustomMatchesNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header_reuse_identifier"
        )
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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
    
    override func setupHeader(_ header: MatchesHeaderReusableView) {
        header.midHorizontalViewController.rootController = self
    }
    
    func didSelectMatchFromHeader(match: MatchModel) {
        let chatViewController = ChatListController(match: match)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension MatchesMessagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 120, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        let chatController = ChatListController(match: match)
        navigationController?.pushViewController(chatController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}
//  MARK: - MatchesHeaderReusableView:
extension MatchesMessagesCollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: view.frame.width, height: 250)
    }

}
