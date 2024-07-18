import UIKit

class SettingsTableViewCell: UITableViewCell {

    class SettingsTextField: UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 42)
        }
    }
    
    let textField: SettingsTextField = {
        let field = SettingsTextField()
        field.placeholder = "Enter Name"
        
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.fillSuperView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
