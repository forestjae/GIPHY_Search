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
//        let searchResultController = SearchResultContainerViewController()

        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

    private let contianerView = UIView()
    private let searchResultController = SearchResultContainerViewController()

    // MARK: - Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.contianerView)
        self.setupController()
        self.setupSubviews()
        self.setupHierarchy()
        self.setupConstraint()
        self.binding()
    }

    // MARK: - Method(s)

    private func setupController() {
        self.view.backgroundColor = .mainBackground
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupSubviews() {
        self.setupNavigationBar()
        self.setupSearchController()
        self.setupSearchResultController()
    }

    private func setupHierarchy() {
        self.view.addSubview(self.contianerView)
        self.contianerView.addSubview(self.searchResultController.view)
    }

    private func setupNavigationBar() {
        self.navigationItem.searchController = self.searchController
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    private func setupSearchResultController() {
        self.searchResultController.delegate = self
        self.addChild(self.searchResultController)
        self.searchResultController.didMove(toParent: self)
    }

    private func setupConstraint() {
        guard let searchResultView = self.searchResultController.view else {
            return
        }

        self.contianerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contianerView.topAnchor.constraint(
                equalTo: self.view.topAnchor
            ),
            self.contianerView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            ),
            self.contianerView.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
            ),
            self.contianerView.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
            )
        ])

        self.searchResultController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchResultView.topAnchor.constraint(
                equalTo: self.contianerView.topAnchor
            ),
            searchResultView.bottomAnchor.constraint(
                equalTo: self.contianerView.safeAreaLayoutGuide.bottomAnchor
            ),
            searchResultView.leadingAnchor.constraint(
                equalTo: self.contianerView.safeAreaLayoutGuide.leadingAnchor
            ),
            searchResultView.trailingAnchor.constraint(
                equalTo: self.contianerView.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }

    private func setupSearchController() {
        self.searchController.searchBar.placeholder = "Search GIPHY"
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.scopeButtonTitles = ImageType.allCases
            .map { $0.description + "s"}
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.setImage(UIImage(), for: .search, state: .normal)
        self.searchController.searchBar.showsScopeBar = true
        self.searchController.automaticallyShowsScopeBar = false
        self.searchController.searchBar.setScopeBarButtonTitleTextAttributes(
            [.font : UIFont.preferredFont(forTextStyle: .headline)],
            for: .normal
        )
    }

    private func binding() {
        self.viewModel?.imageSearched = { [weak self] items in
            DispatchQueue.main.async {
                guard let controller = self?.searchResultController else {
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

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchResultController.view.isHidden = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchResultController.view.isHidden = false
    }
}

extension SearchViewController: SearchResultContainerViewControllerDelegate {
    func didSelectItem(_ item: SearchItem) {
        switch item {
        case .image(let item):
            self.viewModel?.didSelectItem(item)
        }
    }

    func didEndScroll() {
        self.viewModel?.loadNextPage()
    }
}
