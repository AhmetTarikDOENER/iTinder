import UIKit

class UserDetailsViewController: UIViewController {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
//            guard let firstImageURL = cardViewModel.imageURLs.first,
//                  let URL = URL(string: firstImageURL) else { return }
//            imageView.sd_setImage(with: URL)
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    
//    private lazy var imageView: UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
//        imageView.contentMode = .scaleToFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
    
    private lazy var swipingPhotoController = SwipingPhotosViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), selector: #selector(didTapDislikeButton))
    lazy var superlikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), selector: #selector(didTapDislikeButton))
    lazy var likeButton = createButton(image: #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), selector: #selector(didTapDislikeButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupBlurEffectView()
        setupBottomControls()
    }
    
    //  MARK: - Fileprivate
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    @objc fileprivate func didTapDislikeButton() {
        
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        let imageView = swipingPhotoController.view!
        scrollView.addSubview(imageView)
        scrollView.addSubview(infoLabel)
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            infoLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            infoLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
        ])
        scrollView.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            dismissButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = swipingPhotoController.view!
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }

    fileprivate func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
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
        let imageView = swipingPhotoController.view!
        imageView.frame = CGRect(x: min(0, -deltaY), y: -deltaY, width: width, height: width)
    }
}
