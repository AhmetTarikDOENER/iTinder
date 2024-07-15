import UIKit

class MatchView: UIView {
    
    fileprivate lazy var itsAMatchImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and MR.Person have liked \neach other."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
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
    
    fileprivate lazy var sendMessageButton: SendMessageButton = {
        let button = SendMessageButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yellow
        return button
    }()
    
    fileprivate lazy var keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurredView()
        configureHierarchy()
        setupAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupAnimations() {
        let angle = 40 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        /// keyframe animations for segmented animation
        UIView.animateKeyframes(
            withDuration: 1.3,
            delay: 0,
            options: .calculationModeCubic
        ) {
            /// Animation 1 -> Translation back to the original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            /// Animation 2 -> Rotation
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            }
        } completion: { _ in
            
        }
        UIView.animate(
            withDuration: 0.75,
            delay: 0.6 * 1.3,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.1,
            options: .curveEaseOut) {
                self.sendMessageButton.transform = .identity
                self.keepSwipingButton.transform = .identity
            } completion: { _ in
                
            }

    }
    
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
        addSubview(itsAMatchImageView)
        addSubview(descriptionLabel)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        let size: CGFloat = 140
        NSLayoutConstraint.activate([
            itsAMatchImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -24),
            itsAMatchImageView.widthAnchor.constraint(equalToConstant: 300),
            itsAMatchImageView.heightAnchor.constraint(equalToConstant: 80),
            itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: currentUserImageView.topAnchor, constant: -32),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            currentUserImageView.widthAnchor.constraint(equalToConstant: size),
            currentUserImageView.heightAnchor.constraint(equalToConstant: size),
            currentUserImageView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -16),
            currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardUserImageView.widthAnchor.constraint(equalToConstant: size),
            cardUserImageView.heightAnchor.constraint(equalToConstant: size),
            cardUserImageView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendMessageButton.topAnchor.constraint(equalTo: currentUserImageView.bottomAnchor, constant: 32),
            sendMessageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 50),
            keepSwipingButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 16),
            keepSwipingButton.leadingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor),
            keepSwipingButton.trailingAnchor.constraint(equalTo: sendMessageButton.trailingAnchor),
            keepSwipingButton.heightAnchor.constraint(equalToConstant: 50)
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
