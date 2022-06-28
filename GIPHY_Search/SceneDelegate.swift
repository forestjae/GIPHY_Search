//
//  SceneDelegate.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        self.window = UIWindow(windowScene: windowScene)

        let rootViewController = ViewController()

        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
}
