import UIKit
import LBTATools

struct Message {
    let text: String
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
        }
    }
    
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
        bubbleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = false
        bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
//
//        NSLayoutConstraint.activate([
//            bubbleContainer.topAnchor.constraint(equalTo: topAnchor),
//            bubbleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
//            bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
//            bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260)
//        ])
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
        configureHierarchy()
        items = [
            .init(text: "jasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka"),
            .init(text: "ajsdlaknsdlkjansdlka"),
            .init(text: "jasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka"),
            .init(text: "asdasdmnasdjvuwefpweiw weoiuhniazsdauzsdfabjasdaklsjdalkjsdnlkajsdlaknsdlkjansdlka")
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
