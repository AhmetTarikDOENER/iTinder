import UIKit
import LBTATools

class MatchesMessagesCollectionViewController: UICollectionViewController {
    
    fileprivate lazy var customMatchesNavigationBarView = CustomMatchesNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        customMatchesNavigationBarView.fireIconButton.addTarget(self, action: #selector(didTapFire), for: .touchUpInside)
        configureHierarchy()
    }
    
    fileprivate func configureHierarchy() {
        view.addSubview(customMatchesNavigationBarView)
        customMatchesNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customMatchesNavigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            customMatchesNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customMatchesNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customMatchesNavigationBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
        ])
    }
    
    @objc fileprivate func didTapFire() {
        navigationController?.popViewController(animated: true)
    }
}
