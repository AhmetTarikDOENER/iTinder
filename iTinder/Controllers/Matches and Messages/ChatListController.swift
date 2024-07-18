import UIKit
import LBTATools
import FirebaseFirestore
import FirebaseAuth

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
    
    fileprivate lazy var customizedInputAccessoryView: CustomInputAccessoryView = {
        let customInputView = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        customInputView.sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return customInputView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            customizedInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        configureHierarchy()
        fetchMessages()
        customNavBarView.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    fileprivate func fetchMessages() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserID).collection(match.uid).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            querySnapshot?.documentChanges.forEach { docChange in
                if docChange.type == .added {
                    let dictionary = docChange.document.data()
                    self.items.append(.init(dictionary: dictionary))
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc fileprivate func handleKeyboardShow() {
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    @objc fileprivate func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func didTapSend() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "text": customizedInputAccessoryView.textView.text ?? "",
            "senderID": currentUserID,
            "receiverID": match.uid,
            "timestamp": Timestamp(date: Date())
        ]
        Firestore.firestore().collection("matches_messages").document(currentUserID).collection(match.uid).addDocument(data: docData) { error in
            guard error == nil else { return }
            self.customizedInputAccessoryView.textView.text = nil
            self.customizedInputAccessoryView.placeHolderLabel.isHidden = false
        }
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
