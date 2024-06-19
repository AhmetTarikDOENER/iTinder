import UIKit

class HomeViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsBottomStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    func setupDummyCards() {
        (0..<10).forEach { _ in
            let cardView = CardView(frame: .zero)
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
    
    //  MARK: - Fileprivate
    fileprivate func setupLayout() {
        cardsDeckView.heightAnchor.constraint(equalToConstant: 580).isActive = true
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsBottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor
        )
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}

