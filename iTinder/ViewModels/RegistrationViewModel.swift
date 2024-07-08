import UIKit
import Firebase
import FirebaseStorage

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            
            print("Successfully registered user:", res?.user.uid ?? "") /// OK 1
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) ->()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                print("Error uploading image: \(err.localizedDescription)")
                completion(err)
                return // bail
            }
            
            print("Finished uploading image to storage") /// OK 2
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Error getting download URL")
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                print("Download url of our image is:", url?.absoluteString ?? "") /// OK 3
                
                let imageUrl = url?.absoluteString ?? ""
                
                self.saveInfoToFirestore(imageURL: imageUrl) { error in
                    if let error = error {
                        print("imageUrl is not downloading")
                        completion(error)
                        return
                    }
                    print("ImageURl successfully downlaoded")
                    completion(nil)
                }
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageURL: String, completion: @escaping (Error?) -> Void) {
        let uid = UUID().uuidString
        let docData: [String: String] = [
            "fullname": fullName ?? "",
            "uid": uid,
            "imageURL": imageURL
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            if let error = error {
                print("An error occured while creating firestore path", error.localizedDescription)
                completion(error)
                return
            }
            print("Successfully created firestore path.")
            completion(nil)
        }
    }
}
