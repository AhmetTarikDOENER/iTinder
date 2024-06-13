import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    fileprivate let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(imageView)
        imageView.fillSuperView()
        
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
        let shouldDismissCard = gesture.translation(in: nil).x > threshold
        UIView.animate(
            withDuration: 0.75,
            delay: 0,
            usingSpringWithDamping: 1.3,
            initialSpringVelocity: 0.1,
            options: .curveEaseInOut) {
                if shouldDismissCard {
                    self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
                } else {
                    self.transform = .identity
                }
            } completion: {  _ in
                self.transform = .identity
                self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
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
