import UIKit

struct Advertiser: CardViewModelProduceable {
    let title: String
    let brandName: String
    let photoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 29, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)]))
        
        return CardViewModel(imageNames: [photoName], attributedString: attributedString, textAlignment: .center)
    }
}
