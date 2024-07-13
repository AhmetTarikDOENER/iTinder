import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        FirebaseApp.configure()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = SwipingPhotosViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        window.makeKeyAndVisible()
        self.window = window
    }
}

