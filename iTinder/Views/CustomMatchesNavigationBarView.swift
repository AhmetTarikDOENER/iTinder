import UIKit

final class CustomMatchesNavigationBarView: UIView {
    
    private lazy var customNavigationBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setupShadow(opacity: 0.25, radius: 8, offset: .init(width: 0, height: 6), color: .black)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var fireIconButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "app_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var messagesIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "top_messages_icon")?.withTintColor(#colorLiteral(red: 1, green: 0.4235294118, blue: 0.4392156863, alpha: 1))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    
    private lazy var messagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 1, green: 0.4235294118, blue: 0.4392156863, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var feedLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [messagesLabel, feedLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCustomNavBarHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate func configureCustomNavBarHierarchy() {
        addSubview(customNavigationBarView)
        customNavigationBarView.addSubview(stackView)
        customNavigationBarView.addSubview(fireIconButton)
        customNavigationBarView.addSubview(messagesIconImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        NSLayoutConstraint.activate([
            customNavigationBarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            customNavigationBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customNavigationBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            customNavigationBarView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
            fireIconButton.leadingAnchor.constraint(equalTo: customNavigationBarView.leadingAnchor, constant: 15),
            fireIconButton.topAnchor.constraint(equalTo: customNavigationBarView.topAnchor, constant: 15),
            fireIconButton.widthAnchor.constraint(equalToConstant: 30),
            fireIconButton.heightAnchor.constraint(equalToConstant: 30),
            messagesIconImageView.topAnchor.constraint(equalTo: customNavigationBarView.topAnchor, constant: 15),
            messagesIconImageView.leadingAnchor.constraint(equalTo: fireIconButton.trailingAnchor),
            messagesIconImageView.trailingAnchor.constraint(equalTo: customNavigationBarView.trailingAnchor),
            messagesIconImageView.centerXAnchor.constraint(equalTo: customNavigationBarView.centerXAnchor),
            messagesIconImageView.centerYAnchor.constraint(equalTo: fireIconButton.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: customNavigationBarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: customNavigationBarView.trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: customNavigationBarView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: customNavigationBarView.bottomAnchor, constant: -15)
        ])
    }
    
}

