//
//  SearchViewModel.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import Foundation

final class SearchViewModel {

    var imageSearched: (([ImageItemViewModel]) -> Void)?

    private let giphyService: GiphyService
    private var imageSearchTask: Cancellable? { willSet { imageSearchTask?.cancel() } }
    private var imageItemViewModel: [ImageItemViewModel] = []

    init(giphyService: GiphyService) {
        self.giphyService = giphyService
    }

    func searchImage(with query: String) {
        let task = self.giphyService.searchGif(query: query) { result in
            switch result {
            case .success(let gifs):
                self.imageSearched?(gifs.map { ImageItemViewModel(image: $0) })
            case .failure(let error):
                print(error)
            }
        }
        self.imageSearchTask = task
    }
}
