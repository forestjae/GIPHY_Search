//
//  CoordinatorFinishDelegate.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/08/29.
//

import Foundation

protocol CoordinationFinishDelegate: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    func coordinationDidFinish(child: Coordinator)
}

extension CoordinationFinishDelegate {
    func coordinationDidFinish(child: Coordinator) {
        self.childCoordinator = self.childCoordinator.filter { $0.identifer != child.identifer}
    }
}
