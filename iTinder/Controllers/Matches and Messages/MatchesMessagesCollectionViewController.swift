import UIKit
import LBTATools

final class MatchCell: LBTAListCell<UIColor> {
    
    fileprivate lazy var profileImageView = UIImageView(image: #imageLiteral(resourceName: "jane3"), contentMode: .scaleAspectFill)
    fileprivate lazy var usernameLabel = UILabel(
        text: "Username",
        font: .systemFont(ofSize: 12, weight: .semibold),
        textColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),
        textAlignment: .center,
        numberOfLines: 2
    )
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 40
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        stack(stack(profileImageView, alignment: .center), usernameLabel)
    }
}

final class MatchesMessagesCollectionViewController: LBTAListController<MatchCell, UIColor> {
    
    fileprivate lazy var customMatchesNavigationBarView = CustomMatchesNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            .red, .blue, .green, .black, .brown, .magenta
        ]
        customMatchesNavigationBarView.fireIconButton.addTarget(self, action: #selector(didTapFire), for: .touchUpInside)
        configureHierarchy()
    }
    
    fileprivate func configureHierarchy() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = view.frame.size.height * 0.12
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
//  MARK: - UICollectionViewDelegateFlowLayout:
extension MatchesMessagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 100, height: 100)
    }
}
