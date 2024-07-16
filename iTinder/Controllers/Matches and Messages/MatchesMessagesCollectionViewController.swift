import UIKit

class MatchesMessagesCollectionViewController: UICollectionViewController {
    
    private lazy var customNavigationBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setupShadow(opacity: 0.25, radius: 8, offset: .init(width: 0, height: 6), color: .black)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var fireIconImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        configureCustomNavBarHierarchy()
    }
    
    fileprivate func configureCustomNavBarHierarchy() {
        view.addSubview(customNavigationBarView)
        customNavigationBarView.addSubview(stackView)
        customNavigationBarView.addSubview(fireIconImageView)
        customNavigationBarView.addSubview(messagesIconImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        NSLayoutConstraint.activate([
            customNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            fireIconImageView.leadingAnchor.constraint(equalTo: customNavigationBarView.leadingAnchor, constant: 15),
            fireIconImageView.topAnchor.constraint(equalTo: customNavigationBarView.topAnchor, constant: 15),
            fireIconImageView.widthAnchor.constraint(equalToConstant: 30),
            fireIconImageView.heightAnchor.constraint(equalToConstant: 30),
            messagesIconImageView.topAnchor.constraint(equalTo: customNavigationBarView.topAnchor, constant: 15),
            messagesIconImageView.leadingAnchor.constraint(equalTo: fireIconImageView.trailingAnchor),
            messagesIconImageView.trailingAnchor.constraint(equalTo: customNavigationBarView.trailingAnchor),
            messagesIconImageView.centerXAnchor.constraint(equalTo: customNavigationBarView.centerXAnchor),
            messagesIconImageView.centerYAnchor.constraint(equalTo: fireIconImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: customNavigationBarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: customNavigationBarView.trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: customNavigationBarView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: customNavigationBarView.bottomAnchor, constant: -15)
        ])
    }
}
