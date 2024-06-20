import UIKit

struct Advertiser {
    let title: String
    let brandName: String
    let photoName: String
    
    func tocardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .semibold)]))
        
        return CardViewModel(imageName: photoName, attributedString: attributedString, textAlignment: .center)
    }
}
