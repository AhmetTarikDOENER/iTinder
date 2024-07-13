import UIKit

class SwipingPhotosViewController: UIPageViewController {
    
    let controllers = [
        PhotoViewController(image: #imageLiteral(resourceName: "lady4c")),
        PhotoViewController(image: #imageLiteral(resourceName: "jane3")),
        PhotoViewController(image: #imageLiteral(resourceName: "kelly2")),
        PhotoViewController(image: #imageLiteral(resourceName: "jane2"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        setViewControllers([controllers.first!], direction:.forward, animated: false)
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
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.fillSuperView()
    }
}
