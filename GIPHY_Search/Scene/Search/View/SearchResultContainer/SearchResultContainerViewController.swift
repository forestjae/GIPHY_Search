//
//  SearchResultContianerViewController.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit

protocol SearchResultContainerViewControllerDelegate: AnyObject {
    func didSelectItem(_ item: SearchItem)
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

    private func createSearchResultCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSizeProvider: (IndexPath) -> CGSize = { indexPath in
            guard let searchSection = SearchSection(rawValue: indexPath.section) else {
                return CGSize(width: 100, height: 100)
            }
            let item = self.snapShot.itemIdentifiers(inSection: searchSection)[indexPath.row]
            switch item {
            case .image(let imageItemViewModel):
                return CGSize(width: 250, height: 250 * imageItemViewModel.aspectRatio)
            }
        }

        var numberOfItems: (Int) -> Int = { _ in 0 }
        let layout = UICollectionViewCompositionalLayout { section, environment in
            var columnHeights = [CGFloat](repeating: 0, count: 2)
            let groupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(environment.container.effectiveContentSize.height)
            )

            let group = NSCollectionLayoutGroup.custom(layoutSize: groupLayoutSize) { environment in
                var groupLayoutItems = [NSCollectionLayoutGroupCustomItem]()
                for item in 0..<numberOfItems(section) {
                    let indexPath = IndexPath(item: item, section: section)
                    let contentSize = environment.container.effectiveContentSize
                    let spacing: CGFloat = 8
                    let columnIndex = columnHeights
                        .enumerated()
                        .min(by: { $0.element < $1.element })?
                        .offset ?? 0
                    let width = (contentSize.width - spacing) / 2
                    let itemSize = itemSizeProvider(indexPath)
                    let aspectRatio = itemSize.height / itemSize.width
                    let height = (width * aspectRatio)
                    let adjustedItemSize = CGSize(width: width, height: height)
                    let yPoint = columnHeights[columnIndex]
                    let xPoint = (width + spacing) * CGFloat(columnIndex)
                    let origin = CGPoint(x: xPoint, y: yPoint)
                    let frame = CGRect(origin: origin, size: adjustedItemSize)
                    columnHeights[columnIndex] = frame.maxY + spacing
                    groupLayoutItems.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                }
                return groupLayoutItems
            }

            let section = NSCollectionLayoutSection(group: group)
            return section
        }

        numberOfItems = { [weak layout] in
            layout?.collectionView?.numberOfItems(inSection: $0) ?? 0
        }

        return layout
    }

    private func setupSearchResultCollectionView() {
        let layout = self.createSearchResultCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        self.searchResultCollectionView = collectionView
        self.searchResultCollectionView.delegate = self
        self.dataSource = self.createSearchResultDataSource()
        self.provideSupplementaryViewForCollectionView()
        self.searchResultCollectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: "image"
        )
        self.searchResultCollectionView.register(
            TitleHeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "header"
        )
        self.snapShot.appendSections([SearchSection.searchResult])
    }

    private func provideSupplementaryViewForCollectionView() {
        self.dataSource?.supplementaryViewProvider = { (_, _, indexPath) in
            guard let header = self.searchResultCollectionView.dequeueReusableSupplementaryView(
                ofKind: "header",
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TitleHeaderView else { return nil }
            header.configure(for: self.snapShot.sectionIdentifiers[indexPath.section].title)
            return header
        }
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

// MARK: - UICollectionView Delegate

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
        guard let section = SearchSection(rawValue: indexPath.section) else {
            return
        }
        let item = self.snapShot.itemIdentifiers(inSection: section)[indexPath.row]
        self.delegate?.didSelectItem(item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let targetOffset = scrollView.contentOffset.y + self.view.frame.height
        let scrollViewHeight = scrollView.contentSize.height

        if targetOffset > scrollViewHeight - (self.view.frame.height * 0.4) {
            self.delegate?.didEndScroll()
        }
    }
}
