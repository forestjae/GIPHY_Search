//
//  SearchViewController.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/28.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Variable(s)

    var viewModel: SearchViewModel?

    private lazy var searchController: UISearchController = {
        let searchResultController = SearchResultContainerViewController()
        searchResultController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultController)
        return searchController
    }()

    // MARK: - Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mainBackground
        self.setupController()
        self.setupSubviews()
        self.setupConstraint()
        self.binding()
    }

    // MARK: - Method(s)

    private func setupController() {

    }

    private func setupSubviews() {
        self.setupNavigationBar()
        self.setupSearchController()
    }

    private func setupNavigationBar() {
        self.navigationItem.searchController = self.searchController
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    private func setupConstraint() {
        self.searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupSearchController() {
        self.searchController.searchBar.placeholder = "Search GIPHY"
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.setImage(UIImage(), for: .search, state: .normal)
    }

    private func binding() {
        self.viewModel?.imageSearched = { [weak self] items in
            DispatchQueue.main.async {
                guard let controller = self?.searchController.searchResultsController as? SearchResultContainerViewController else {
                    return
                }
                let searchItems = items.map { SearchItem.image($0) }
                controller.appendSearchResultSnapshot(items: searchItems, for: .searchResult)
            }
        }
        self.viewModel?.beginNewSearchSession = { [weak self] in
            guard let controller = self?.searchResultController else {
                return
            }
            controller.resetSnapshot()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.searchImageBegin()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchQueryText(searchText)
    }

    func searchBar(
        _ searchBar: UISearchBar,
        selectedScopeButtonIndexDidChange selectedScope: Int
    ) {
        self.viewModel?.changeSearchScope(for: selectedScope)
    }
}

extension SearchViewController: SearchResultContainerViewControllerDelegate {
    func didSelectItem(at indexPath: IndexPath) {
        self.viewModel?.didSelectImage(at: indexPath)
    }
    func didEndScroll() {
        self.viewModel?.loadNextPage()
    }
}
