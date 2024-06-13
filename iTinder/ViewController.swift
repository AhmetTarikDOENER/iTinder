import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subviews = [UIColor.gray, UIColor.darkGray, UIColor.black].map { (color) -> UIView in
            let view = UIView()
            view.backgroundColor = color
            
            return view
        }
        
        let topStackView = UIStackView(arrangedSubviews: subviews)
        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
//        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        view.addSubview(stackView)
        
        stackView.fillSuperView()
    }
}

