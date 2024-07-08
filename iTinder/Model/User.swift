import UIKit

struct User: CardViewModelProduceable {
    let name: String
    let age: Int
    let profession: String
    let imageNames: [String]
    
    init(dictionary: [String: Any]) {
        let name = dictionary["fullname"] as? String ?? ""
        let age = 0
        self.age = age
        self.profession = "Cooker"
        self.name = name
        let imageURL1 = dictionary["imageURL"] as? String ?? ""
        self.imageNames = [imageURL1]
    }

    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: imageNames, attributedString: attributedText, textAlignment: .left)
    }
}

