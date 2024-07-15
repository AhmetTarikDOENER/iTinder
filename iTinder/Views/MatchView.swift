import UIKit

class MatchView: UIView {
    
    fileprivate lazy var currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "jane2"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    fileprivate lazy var cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurredView()
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurredView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperView()
        visualEffectView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.visualEffectView.alpha = 1
            } completion: { _ in
                
            }

    }
    
    fileprivate func configureHierarchy() {
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        let size: CGFloat = 140
        NSLayoutConstraint.activate([
            currentUserImageView.widthAnchor.constraint(equalToConstant: size),
            currentUserImageView.heightAnchor.constraint(equalToConstant: size),
            currentUserImageView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -16),
            currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardUserImageView.widthAnchor.constraint(equalToConstant: size),
            cardUserImageView.heightAnchor.constraint(equalToConstant: size),
            cardUserImageView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc fileprivate func didTapDismiss() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
            }
    }
}
