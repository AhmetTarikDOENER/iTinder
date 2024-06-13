import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let button = UIButton(type: .system)
        
        let bottomSubviews = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.purple].map { color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            
            return view
        }
        
        bottomSubviews.forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
}
