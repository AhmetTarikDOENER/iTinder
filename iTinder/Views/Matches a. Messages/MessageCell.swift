import UIKit
import LBTATools

final class MessageCell: LBTAListCell<Message> {
    
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
                bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                textView.textColor = .white
            } else {
                bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = false
                bubbleContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
                textView.textColor = .label
                bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
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
        bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
