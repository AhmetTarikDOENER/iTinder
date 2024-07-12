import UIKit
import SDWebImage

protocol CardViewDelegate: AnyObject {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    weak var delegate: CardViewDelegate?
    
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    fileprivate let informationLabel = UILabel()
    fileprivate let threshold: CGFloat = 100
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let barsStackView = UIStackView()
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate lazy var moreInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
        
        return button
    }()
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barView.layer.borderColor = UIColor.systemBackground.cgColor
                barView.layer.borderWidth = 0.5
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageIndexObserver()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() { /// in here we know what CardView frame will be
        super.layoutSubviews()
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func didTapMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] index, imageURL in
            if let url = URL(string: imageURL ?? "") {
                self?.imageView.sd_setImage(with: url)
            }
            self?.barsStackView.arrangedSubviews.forEach { view in
                view.backgroundColor = self?.barDeselectedColor
            }
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate func setupLayout() {
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperView()
        setupBarsStackView()
        setupGradientLayer()
        setupInformationLabel()
        setupMoreInfoButton()
    }
    
    
    fileprivate func setupMoreInfoButton() {
        addSubview(moreInfoButton)
        NSLayoutConstraint.activate([
            moreInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moreInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            moreInfoButton.widthAnchor.constraint(equalToConstant: 44),
            moreInfoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    fileprivate func setupInformationLabel() {
        addSubview(informationLabel)
        informationLabel.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: -16)
        )
        informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: -8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.2]
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func handleChangedState(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEndedState(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            options: .curveEaseInOut) {
                if shouldDismissCard {
                    self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                    self.removeFromSuperview()
                } else {
                    self.transform = .identity
                }
            } completion: {  _ in
                self.transform = .identity
                if shouldDismissCard {
                    self.removeFromSuperview()
                }
            }
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        shouldAdvanceNextPhoto ? cardViewModel.advanceToNextPhoto() : cardViewModel.goToPreviousPhoto()
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subview in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChangedState(gesture)
        case .ended:
            handleEndedState(gesture)
        default:
            ()
        }
    }
}
