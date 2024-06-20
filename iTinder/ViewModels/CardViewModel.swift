import UIKit

protocol CardViewModelProduceable {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}

