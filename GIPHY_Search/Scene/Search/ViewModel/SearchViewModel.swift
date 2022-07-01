//
//  SearchViewModel.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

final class SearchViewModel {

    // MARK: - Variable(s)

    weak var coordinator: SearchCoordinator?
    var searchQueriesHistoryFetched: (([String]) -> Void)?
    var imageSearched: (([ImageItemViewModel]) -> Void)?
    var beginNewSearchSession: (() -> Void)?

    private let giphyService: GiphyService
    private let searchQueryStorage: SearchQueryStorage
    private var imageSearchTask: Cancellable? { willSet { imageSearchTask?.cancel() } }
    private var hasNextPage: Bool?
    private var currentOffset: Int?
    private var searchType: ImageType = .gif
    private var searchQuery: String?

    // MARK: - Initializer(s)
    
    init(giphyService: GiphyService) {
        self.giphyService = giphyService
        self.searchQueryStorage = SearchQueryStorage()
    }

    // MARK: - Method(s)

    func searchQueryText(_ text: String) {
        self.searchQuery = text
    }

    func changeSearchScope(for index: Int) {
        guard let searchType = ImageType(index: index) else {
            return
        }
        self.searchType = searchType
        self.searchImageBegin()
    }

    func searchImageBegin(with newQuery: String? = nil) {
        if let query = newQuery {
            self.searchQuery = query
        }

        guard let searchQuery = self.searchQuery else {
            return
        }

        self.beginNewSearchSession?()
        self.reset()
        self.searchImage(for: self.searchType, with: searchQuery)
        self.saveQuery(searchQuery)
        self.fetchQueryHistory()
    }

    func loadNextPage() {
        guard let hasNextPage = self.hasNextPage,
              let offset = self.currentOffset,
              hasNextPage, self.imageSearchTask == nil else {
            return
        }
        self.searchImage(for: .gif, with: "apple", offset: offset)
    }

    func didSelectItem(_ item: ImageItemViewModel) {
        self.coordinator?.detailFlow(with: item.image)
    }

    func fetchQueryHistory() {
        self.searchQueryStorage.fetchQuery { [weak self] result in
            switch result {
            case .success(let queries):
                self?.searchQueriesHistoryFetched?(queries)
            case .failure:
                return
            }
        }
    }

    // MARK: - Private Method(s)

    private func saveQuery(_ query: String) {
        guard query != "" else {
            return
        }
        try? self.searchQueryStorage.saveQuery(of: query)
    }

    private func searchImage(for type: ImageType, with query: String, offset: Int = 0) {
        let task = self.giphyService.searchGif(
            type: type,
            query: query,
            offset: offset
        ) { [weak self] result in
            switch result {
            case .success(let gifPage):
                self?.hasNextPage = gifPage.hasNextPage
                self?.currentOffset = gifPage.offset + 10
                self?.imageSearched?(gifPage.gifs.map { ImageItemViewModel(image: $0) })
                self?.imageSearchTask = nil
            case .failure:
                return
            }
        }
        self.imageSearchTask = task
    }

    private func reset() {
        self.hasNextPage = nil
        self.currentOffset = nil
    }
}

// MARK: - Search Section/Item

enum SearchSection: Int {
    case searchResult = 0

    var title: String {
        switch self {
        case .searchResult:
            return "All The GIFs"
        }
    }
}

enum SearchItem: Hashable {
    case image(ImageItemViewModel)
}

// MARK: - SearchGuide Section/Item

enum SearchGuideSection: Int {
    case searchHistory = 0

    var title: String {
        switch self {
        case .searchHistory:
            return "Recent Searches"
        }
    }
}

enum SearchGuideItem: Hashable {
    case searchQueryHistory(String)
}
