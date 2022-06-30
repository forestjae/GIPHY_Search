//
//  SearchResultContianerViewController.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit

protocol SearchResultContainerViewControllerDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
    func didEndScroll()
}

class SearchResultContainerViewController: UIViewController {

    // MARK: - Variable(s)

    weak var delegate: SearchResultContainerViewControllerDelegate?

    private var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>?
    private var snapShot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
    private var searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupHierarchy()
        self.setupConstraint()
    }

    // MARK: - Method(s)

    func appendSearchResultSnapshot(items: [SearchItem], for section: SearchSection) {
        self.snapShot.appendItems(items, toSection: section)
        self.dataSource?.apply(self.snapShot)
    }

    func resetSnapshot() {
        let currentItems = self.snapShot.itemIdentifiers
        self.snapShot.deleteItems(self.snapShot.itemIdentifiers)
        self.dataSource?.apply(self.snapShot)
    }

    // MARK: - Private Method(s)

    private func setupSubviews() {
        self.setupSearchResultCollectionView()
    }

    private func setupHierarchy() {
        self.view.addSubview(self.searchResultCollectionView)
    }

    private func setupConstraint() {
        self.searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchResultCollectionView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            self.searchResultCollectionView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            ),
            self.searchResultCollectionView.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
            ),
            self.searchResultCollectionView.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }

    private func setupSearchResultCollectionView() {
        let layout = createSearchResultCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        self.searchResultCollectionView = collectionView
        self.searchResultCollectionView.delegate = self
        self.dataSource = self.createSearchResultDataSource()
        self.searchResultCollectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: "image"
        )
        self.snapShot.appendSections([SearchSection.searchResult])
    }

    private func createSearchResultCollectionViewLayout() -> UICollectionViewLayout {
        let items = snapShot.itemIdentifiers
        let imageItems = items.map { item -> ImageItemViewModel in
            switch item {
            case .image(let imageItemViewModel):
                return imageItemViewModel
            }
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, _ in
                guard let sectionLayoutKind = SearchSection(rawValue: sectionIndex) else {
                    return nil
                }
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                let spacing = CGFloat(10)
                group.interItemSpacing = .fixed(spacing)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

                return section
            },
            configuration: configuration
        )

        return layout
    }

    private func createSearchResultDataSource() -> UICollectionViewDiffableDataSource<SearchSection, SearchItem> {
        return UICollectionViewDiffableDataSource<SearchSection, SearchItem>(
            collectionView: self.searchResultCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "image",
                for: indexPath
            ) as? ImageCollectionViewCell else {
                return nil
            }
            DispatchQueue.main.async {
                if indexPath == self.searchResultCollectionView.indexPath(for: cell) {
                    switch itemIdentifier {
                    case .image(let imageItemViewModel):
                        cell.configureContent(imageItemViewModel)
                    }
                }
            }
            return cell
        }
    }
}

enum SearchSection: Int {
    case searchResult = 0
}

enum SearchItem: Hashable {
    case image(ImageItemViewModel)
}

extension SearchResultContainerViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        cell.playVideo()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        cell.stopVideo()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItem(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let targetOffset = scrollView.contentOffset.y + self.view.frame.height
        let scrollViewHeight = scrollView.contentSize.height

        if targetOffset > scrollViewHeight - (self.view.frame.height * 0.4) {
            self.delegate?.didEndScroll()
        }
    }
}
