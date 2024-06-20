import UIKit

protocol CardViewModelProduceable {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}

