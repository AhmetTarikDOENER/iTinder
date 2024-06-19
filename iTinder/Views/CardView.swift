import UIKit

class CardView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "lady5c"))
    let informationLabel = UILabel()
    
    fileprivate let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperView()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        informationLabel.text = "Test Name Test Age"
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        informationLabel.font = UIFont.systemFont(ofSize: 29, weight: .heavy)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    fileprivate func handleChangedState(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 15
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
                } else {
                    self.transform = .identity
                }
            } completion: {  _ in
                self.transform = .identity
                if shouldDismissCard {
                    self.removeFromSuperview()
                }
//                self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
            }
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChangedState(gesture)
        case .ended:
            handleEndedState(gesture)
        default:
            ()
        }
    }
}
