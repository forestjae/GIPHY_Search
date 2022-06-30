//
//  SearchViewModel.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

final class SearchViewModel {
    weak var coordinator: SearchCoordinator?
    var imageSearched: (([ImageItemViewModel]) -> Void)?
    var beginNewSearchSession: (() -> Void)?

    private let giphyService: GiphyService
    private var imageSearchTask: Cancellable? { willSet { imageSearchTask?.cancel() } }
    private var images: [Gif] = []
    private var hasNextPage: Bool?
    private var currentOffset: Int?
    private var searchType: ImageType = .gif
    private var searchQuery: String?
    
    init(giphyService: GiphyService) {
        self.giphyService = giphyService
    }

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

    func searchImageBegin() {
        guard let searchQuery = self.searchQuery else {
            return
        }
        self.beginNewSearchSession?()
        self.reset()
        self.searchImage(for: self.searchType, with: searchQuery)
    }

    func loadNextPage() {
        guard let hasNextPage = self.hasNextPage,
              let offset = self.currentOffset,
              hasNextPage, self.imageSearchTask == nil else {
            return
        }
        self.searchImage(for: .gif, with: "apple", offset: offset)
    }

    func didSelectImage(at indexPath: IndexPath) {
        self.coordinator?.detailFlow(with: self.images[indexPath.row])
    }

    private func searchImage(for type: ImageType, with query: String, offset: Int = 0) {
        let task = self.giphyService.searchGif(
            type: type,
            query: query,
            offset: offset
        ) { result in
            switch result {
            case .success(let gifPage):
                self.images = gifPage.gifs
                self.hasNextPage = gifPage.hasNextPage
                self.currentOffset = gifPage.offset + 10
                self.imageSearched?(gifPage.gifs.map { ImageItemViewModel(image: $0) })
                self.imageSearchTask = nil
            case .failure(let error):
                print(error)
            }
        }
        self.imageSearchTask = task
    }

    private func reset() {
        self.hasNextPage = nil
        self.currentOffset = nil
    }
}
