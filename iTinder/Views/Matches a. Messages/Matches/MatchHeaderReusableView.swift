import UIKit
import LBTATools

final class MatchesHeaderReusableView: UICollectionReusableView {
    
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.998854816, green: 0.4232227802, blue: 0.4381603003, alpha: 1))
    let midHorizontalViewController = MatchesHorizontalListController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.998854816, green: 0.4232227802, blue: 0.4381603003, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack(stack(newMatchesLabel).padLeft(20), midHorizontalViewController.view, stack(messagesLabel).padLeft(20), spacing: 16)
            .withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
