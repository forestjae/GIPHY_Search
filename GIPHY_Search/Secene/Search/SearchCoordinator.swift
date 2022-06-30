//
//  SearchCoordinator.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel(
            giphyService: GiphyService(
                apiService: DefaultAPIService()
            )
        )
        searchViewModel.coordinator = self
        searchViewController.viewModel = searchViewModel
        self.navigationController?.viewControllers = [searchViewController]
    }

    func detailFlow(with image: Gif) {
        let detailCoordinator = DetailCoordinator(
            navigationController: self.navigationController,
            image: image
        )
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}
