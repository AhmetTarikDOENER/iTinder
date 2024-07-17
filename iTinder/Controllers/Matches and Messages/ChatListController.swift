import UIKit
import LBTATools

struct Message {
    let text: String
    let isOwnerCurrentUser: Bool
}

class MessageCell: LBTAListCell<Message> {
    
    fileprivate let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1))
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            if item.isOwnerCurrentUser {
                bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
                bubbleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                textView.textColor = .white
            } else {
                bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = false
                bubbleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
            }
        }
    }
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        configureHierarchy()
    }
    
    fileprivate func configureHierarchy() {
        addSubview(bubbleContainer)
        bubbleContainer.translatesAutoresizingMaskIntoConstraints = false
        bubbleContainer.addSubview(textView)
        bubbleContainer.layer.cornerRadius = 12
        textView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
        bubbleContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
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
