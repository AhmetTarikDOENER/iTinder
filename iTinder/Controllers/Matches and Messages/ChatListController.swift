import UIKit
import LBTATools

//  MARK: - ChatListController
final class ChatListController: LBTAListController<MessageCell, Message> {
    
    fileprivate lazy var customNavBarView = CustomMessagesNavigationBarView(match: self.match)
    fileprivate let match: MatchModel
    
    init(match: MatchModel) {
        self.match = match
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var redView: UIView = {
        return CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            redView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        configureHierarchy()
        items = [
            .init(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", isOwnerCurrentUser: true),
            .init(text: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", isOwnerCurrentUser: false),
            .init(text: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. ", isOwnerCurrentUser: false),
            .init(text: "There is nothing to do.", isOwnerCurrentUser: true),
            .init(text: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero,", isOwnerCurrentUser: false)
        ]
        customNavBarView.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    @objc fileprivate func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatListController {
    fileprivate func configureHierarchy() {
        let customNavBarViewHeight: CGFloat = view.frame.size.height * 0.1
        collectionView.contentInset.top = customNavBarViewHeight
        collectionView.verticalScrollIndicatorInsets.top = customNavBarViewHeight
        view.addSubview(customNavBarView)
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        let customNavBarCover = UIView(backgroundColor: .white)
        customNavBarCover.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBarCover)
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            customNavBarCover.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBarCover.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarCover.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension ChatListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}
