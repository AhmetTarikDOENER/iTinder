import UIKit

class SwipingPhotosViewController: UIPageViewController {
    
    var controllers = [UIViewController]()
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageURLs.map { imageURL -> UIViewController in
                let photoViewController = PhotoViewController(imageURL: imageURL ?? "")
                return photoViewController
            }
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            setupBarViews()
        }
    }
    
    fileprivate let isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        if isCardViewMode {
            disableSwipingAbility()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { view in
            if let view = view as? UIScrollView {
                view.isScrollEnabled = false
            }
        }
    }
    
    fileprivate lazy var barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupBarViews() {
        cardViewModel.imageURLs.forEach { _ in
            let barView = UIView()
            barView.backgroundColor = deselectedColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        view.addSubview(barsStackView)
        barsStackView.translatesAutoresizingMaskIntoConstraints = false
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 5
        barsStackView.axis = .horizontal
        func getStatusBarHeight() -> CGFloat {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let statusBarManager = windowScene.statusBarManager {
                return statusBarManager.statusBarFrame.height
            } else { return 0 }
        }
        var paddingTop: CGFloat =  8
        if !isCardViewMode {
            paddingTop += getStatusBarHeight()
        }
        NSLayoutConstraint.activate([
            barsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            barsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            barsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: paddingTop),
            barsStackView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}

//  MARK: - UIPageViewControllerDataSource
extension SwipingPhotosViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { $0 == viewController } ?? -1
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex { $0 == viewController } ?? -1
        if index == 0 { return nil }
        return controllers[index - 1]
    }
}
//  MARK: - UIPageViewControllerDelegate
extension SwipingPhotosViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoViewController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == currentPhotoViewController }) {
            barsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedColor }
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}

//  MARK: - PhotoViewController
class PhotoViewController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
    
    init(imageURL: String?) {
        if let url = URL(string: imageURL ?? "") {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperView()
        imageView.clipsToBounds = true
    }
}
