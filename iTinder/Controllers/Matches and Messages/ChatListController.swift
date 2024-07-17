import UIKit
import LBTATools

struct Message {
    let text: String
}

class MessageCell: LBTAListCell<Message> {
    override var item: Message! {
        didSet {
            backgroundColor = .red
        }
    }
}

final class ChatListController: LBTAListController<MessageCell, Message> {
    
    fileprivate lazy var customNavBarView = CustomMessagesNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        items = [
            .init(text: "jasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka"),
            .init(text: "jasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka"),
            .init(text: "jasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka"),
            .init(text: "jasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka")
        ]
    }
    
    fileprivate func configureHierarchy() {
        collectionView.contentInset.top = view.frame.size.height * 0.1
        view.addSubview(customNavBarView)
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10)
        ])
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension ChatListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}
