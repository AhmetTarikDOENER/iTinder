import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: UIImage(named: "lady5c"))
    
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

//        transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEndedState() {
        UIView.animate(
            withDuration: 0.75,
            delay: 0,
            usingSpringWithDamping: 1.3,
            initialSpringVelocity: 0.1,
            options: .curveEaseInOut) {
                self.transform = .identity
            }
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChangedState(gesture)
        case .ended:
            handleEndedState()
        default:
            ()
        }
    }
}
