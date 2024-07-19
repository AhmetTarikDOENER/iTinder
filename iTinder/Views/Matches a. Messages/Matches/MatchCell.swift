import UIKit
import LBTATools

final class MatchCell: LBTAListCell<Match> {
    
    fileprivate lazy var profileImageView = UIImageView(image: #imageLiteral(resourceName: "jane3"), contentMode: .scaleAspectFill)
    fileprivate lazy var usernameLabel = UILabel(
        text: "Username",
        font: .systemFont(ofSize: 14, weight: .semibold),
        textColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),
        textAlignment: .center,
        numberOfLines: 2
    )
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.username
            profileImageView.sd_setImage(with: URL(string: item.profileImageURL))
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

