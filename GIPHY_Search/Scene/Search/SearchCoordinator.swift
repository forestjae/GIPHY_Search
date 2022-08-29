//
//  SearchCoordinator.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit

final class SearchCoordinator: Coordinator {
    weak var finishDelegate: CoordinationFinishDelegate?
    let identifer: UUID = UUID()
    var childCoordinator: [Coordinator] = []

    private weak var navigationController: UINavigationController?

    init(
        navigationController: UINavigationController,
        finishDelegate: CoordinationFinishDelegate
    ) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }

    func start() {
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel(
            giphyService: DefaultGiphyService(
                apiProvider: DefaultAPIProvider()
            )
        )
        searchViewModel.coordinator = self
        searchViewController.viewModel = searchViewModel
        self.navigationController?.viewControllers = [searchViewController]
    }

    func detailFlow(with image: Gif) {
        let detailCoordinator = DetailCoordinator(
            navigationController: self.navigationController,
            image: image,
            finishDelegate: self
        )
        self.childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
    }
}

extension SearchCoordinator: CoordinationFinishDelegate { }
