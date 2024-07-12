import UIKit

class UserDetailsViewController: UIViewController {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username \n30Doctor\nsome bio"
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        scrollView.addSubview(imageView)
        scrollView.addSubview(infoLabel)
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            infoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            infoLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
        ])
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismiss)))
    }
    
    @objc fileprivate func didTapDismiss() {
        self.dismiss(animated: true)
    }
}

//  MARK: - UIScrollViewDelegate
extension UserDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let deltaY = -scrollView.contentOffset.y
        var width = view.frame.width + deltaY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(x: min(0, -deltaY), y: -deltaY, width: width, height: width)
    }
}
