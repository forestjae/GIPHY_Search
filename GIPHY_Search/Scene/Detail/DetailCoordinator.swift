//
//  DetailCoordinator.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import UIKit

final class DetailCoordinator: Coordinator {
    weak var finishDelegate: CoordinationFinishDelegate?
    let identifer = UUID()
    var childCoordinator: [Coordinator] = []

    private weak var navigationController: UINavigationController?
    private let image: Gif

    init(
        navigationController: UINavigationController?,
        image: Gif,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.navigationController = navigationController
        self.image = image
        self.finishDelegate = finishDelegate
    }

    func start() {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel(image: self.image)
        detailViewModel.coordinator = self
        detailViewController.viewModel = detailViewModel
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
