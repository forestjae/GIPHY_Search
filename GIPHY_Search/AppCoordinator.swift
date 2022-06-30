//
//  AppCoordinator.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let rootViewController = UINavigationController()
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()

        self.searchFlow(navigationController: rootViewController)
    }

    private func searchFlow(navigationController: UINavigationController) {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        self.childCoordinator.append(searchCoordinator)
        searchCoordinator.start()
    }
}
