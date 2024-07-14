import UIKit

protocol CardViewModelProduceable {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageURLs: [String?]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    let uid: String
    
    init(imageURLs: [String?], attributedString: NSAttributedString, textAlignment: NSTextAlignment, uid: String) {
        self.imageURLs = imageURLs
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        self.uid = uid
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageURL = imageURLs[imageIndex]
            imageIndexObserver?(imageIndex, imageURL)
        }
    }
    
    var imageIndexObserver: ((Int, String?) -> Void)?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageURLs.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

