import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(imageLiteralResourceName: "app_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        fireImageView.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(imageLiteralResourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(imageLiteralResourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        [settingsButton, UIView(), fireImageView, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
