import UIKit
import LBTATools

final class CustomMessagesNavigationBarView: UIView {
    
    fileprivate lazy var userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "kelly2"))
    fileprivate lazy var usernameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 14, weight: .regular), textAlignment: .center)
    lazy var backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9704898391, green: 0.009552962224, blue: 0.3605019813, alpha: 1))
    fileprivate lazy var flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9704898391, green: 0.009552962224, blue: 0.3605019813, alpha: 1))
    fileprivate let match: MatchModel
    
    init(match: MatchModel) {
        self.match = match
        super.init(frame: .zero)
        usernameLabel.text = match.username
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageURL))
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .black)
        let middleStack = hstack(stack(userProfileImageView, usernameLabel, spacing: 8, alignment: .center), alignment: .center)
        hstack(backButton, middleStack, flagButton).withMargins(.init(top: 0, left: 13, bottom: 0, right: 13))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
