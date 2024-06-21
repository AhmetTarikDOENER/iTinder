import UIKit
import Firebase
import FirebaseStorage

class RegistrationViewModel {
    var fullName: String? { didSet {checkRegistrationValidity()} }
    var email: String? { didSet {checkRegistrationValidity()} }
    var password: String? { didSet {checkRegistrationValidity()} }

    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    fileprivate func checkRegistrationValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> Void) {
        guard let email, let password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] result, error in
            if let error = error {
                completion(error)
                return
            }
            let fileName = UUID().uuidString
            let storageReference = Storage.storage().reference(withPath: "/images/\(fileName)/")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            
            storageReference.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    completion(error)
                    return
                }
                storageReference.downloadURL { url, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    self.bindableIsRegistering.value = false
                }
            }
        }
    }
}
