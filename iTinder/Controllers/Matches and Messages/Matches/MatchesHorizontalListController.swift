import UIKit
import LBTATools
import FirebaseAuth
import FirebaseFirestore

final class MatchesHorizontalListController: LBTAListController<MatchCell, MatchModel> {
    
    weak var rootController: MatchesMessagesCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        fetchMatches()
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
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension MatchesHorizontalListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 100, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 4, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = self.items[indexPath.item]
        rootController?.didSelectMatchFromHeader(match: match)
    }
}
