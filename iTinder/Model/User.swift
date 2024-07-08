import UIKit

struct User: CardViewModelProduceable {
    var name: String?
    var age: Int?
    var profession: String?
    var imageURL1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageURL1 = dictionary["imageURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }

    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: "\(name ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)": "N\\A"
        let professionString = profession != nil ? profession! : "Not Available"
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageURL1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}

