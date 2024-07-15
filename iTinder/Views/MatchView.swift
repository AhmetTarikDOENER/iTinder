import UIKit

class MatchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurredView()
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
    
    @objc fileprivate func didTapDismiss() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
                self.visualEffectView.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
            }
    }
}
