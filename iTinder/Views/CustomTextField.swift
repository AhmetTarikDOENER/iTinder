import UIKit

class CustomTextField: UITextField {
        
    let padding: CGFloat
    let height: CGFloat?
    
    init(padding: CGFloat, height: CGFloat? = nil) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = 22.5
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 45)
    }
    
}
