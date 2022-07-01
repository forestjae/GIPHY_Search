//
//  DetailCoordinator.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []

    private weak var navigationController: UINavigationController?
    private let image: Gif

    init(navigationController: UINavigationController?, image: Gif) {
        self.navigationController = navigationController
        self.image = image
    }

    func start() {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel(image: self.image)
        detailViewModel.coordinator = self
        detailViewController.viewModel = detailViewModel
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
