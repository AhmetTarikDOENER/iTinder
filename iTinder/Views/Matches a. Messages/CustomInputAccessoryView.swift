import UIKit

final class CustomInputAccessoryView: UIView {
    
    let textView = UITextView()
    let sendButton = UIButton(title: "SEND", titleColor: .black, font: .boldSystemFont(ofSize: 16))
    let placeHolderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 14), textColor: .lightGray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    fileprivate func configureHierarchy() {
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        stackView.alignment = .center
        addSubview(stackView)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 13, bottom: 0, right: 13)
        stackView.fillSuperview()
        addSubview(placeHolderLabel)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            placeHolderLabel.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 60),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc fileprivate func handleTextChange() {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
}
