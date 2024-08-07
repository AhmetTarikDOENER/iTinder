import UIKit
import LBTATools
import FirebaseFirestore

final class RecentMessagesCell: LBTAListCell<RecentMessages> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 16))
    let messageLabel = UILabel(
        text: "aSDAJBKDJHABD JBdk jahsdajhbdajbsd JKHBAJKSDHbkJNASBD jknab khsbdk jhaBK",
        font: .systemFont(ofSize: 16),
        textColor: .systemGray,
        numberOfLines: 3
    )
    
    override var item: RecentMessages! {
        didSet {
            usernameLabel.text = item.username
            messageLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageURL))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        userProfileImageView.layer.cornerRadius = 40
        userProfileImageView.clipsToBounds = true
        hstack(userProfileImageView.withWidth(80).withHeight(80), stack(usernameLabel, messageLabel, spacing: 4), spacing: 16, alignment: .center)
            .withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
}


