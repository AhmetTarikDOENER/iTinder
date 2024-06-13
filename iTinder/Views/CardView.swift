import UIKit

class CardView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "lady5c"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(imageView)
        imageView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
