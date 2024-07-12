import UIKit

struct User: CardViewModelProduceable {
    var name: String?
    var age: Int?
    var profession: String?
    var imageURL1: String?
    var imageURL2: String?
    var imageURL3: String?
    var uid: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageURL1 = dictionary["imageURL1"] as? String
        self.imageURL2 = dictionary["imageURL2"] as? String
        self.imageURL3 = dictionary["imageURL3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }

    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: "\(name ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)": "N\\A"
        let professionString = profession != nil ? profession! : "Not Available"
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageURLs = [String]()
        if let url = imageURL1 { imageURLs.append(url) }
        if let url = imageURL2 { imageURLs.append(url) }
        if let url = imageURL3 { imageURLs.append(url) }
        
        return CardViewModel(imageURLs: imageURLs, attributedString: attributedText, textAlignment: .left)
    }
}

