import UIKit

class SwipingPhotosViewController: UIPageViewController {
    
    var controllers = [UIViewController]()
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageURLs.map { imageURL -> UIViewController in
                let photoViewController = PhotoViewController(imageURL: imageURL)
                return photoViewController
            }
            setViewControllers([controllers.first!], direction:.forward, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
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
//  MARK: - PhotoViewController
class PhotoViewController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
    
    init(imageURL: String) {
        if let url = URL(string: imageURL) {
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
    }
}
