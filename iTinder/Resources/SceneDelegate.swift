//
//  SceneDelegate.swift
//  iTinder
//
//  Created by Ahmet Tarik DÖNER on 13.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = RegistrationViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

