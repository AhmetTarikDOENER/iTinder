import UIKit

class RegistrationViewModel {
    var fullName: String? { didSet {checkRegistrationValidity()} }
    var email: String? { didSet {checkRegistrationValidity()} }
    var password: String? { didSet {checkRegistrationValidity()} }

    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    fileprivate func checkRegistrationValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
