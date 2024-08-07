import UIKit
import SDWebImage

protocol CardViewDelegate: AnyObject {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    weak var delegate: CardViewDelegate?
    
    var nextCardView: CardView?
    
    fileprivate let swipingPhotosController = SwipingPhotosViewController(isCardViewMode: true)
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
            swipingPhotosController.cardViewModel = cardViewModel
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageURLs.count).forEach { _ in
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
            self?.barsStackView.arrangedSubviews.forEach { view in
                view.backgroundColor = self?.barDeselectedColor
            }
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate func setupLayout() {
        clipsToBounds = true
        layer.cornerRadius = 10
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperView()
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
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            informationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.translatesAutoresizingMaskIntoConstraints = false
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        NSLayoutConstraint.activate([
            barsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            barsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            barsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            barsStackView.heightAnchor.constraint(equalToConstant: 4)
        ])
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
        if shouldDismissCard {
            guard let homeViewController = self.delegate as? HomeViewController else { return }
            if translationDirection == 1 {
                homeViewController.didTapLike()
            } else {
                homeViewController.didTapDislike()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
                self.transform = .identity
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
