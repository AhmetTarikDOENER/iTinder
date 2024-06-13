import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let subviews = [
            UIImage(imageLiteralResourceName: "refresh_circle"),
            UIImage(imageLiteralResourceName: "dismiss_circle"),
            UIImage(imageLiteralResourceName: "super_like_circle"),
            UIImage(imageLiteralResourceName: "like_circle"),
            UIImage(imageLiteralResourceName: "boost_circle"),
        ].map { image -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            
            return button
        }
        
        subviews.forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
}
