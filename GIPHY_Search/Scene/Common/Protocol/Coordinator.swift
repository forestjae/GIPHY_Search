//
//  Coordinator.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }

    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        self.childCoordinator.removeAll()
    }
}
