//
//  CacheManager.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit
import AVFoundation

class CacheManager {
    static let imageCache = URLCache(memoryCapacity: 300 * 1024 * 1024,
                                     diskCapacity: 1000 * 1024 * 1024,
                                     directory: cacheDirectory)

    static let videoCache = NSCache<NSString, AVURLAsset>()

    private static let cacheDirectory: URL? = {
        let url = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .allDomainsMask,
            appropriateFor: nil,
            create: false)
        return url
    }()

    static func fetchImage(imageURL: URL, completionHandler: @escaping (UIImage) -> Void) {
        let request = URLRequest(url: imageURL)

        self.loadImageFromCache(request: request) { result in
            switch result {
            case .success(let image):
                completionHandler(image)
            case .failure:
                self.downloadImage(request: request) { image in
                    completionHandler(image)
                }
            }
        }
    }

    private static func downloadImage(
        request: URLRequest,
        completionHandler: @escaping (UIImage) -> Void
    ) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data else {
                return
            }
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                return
            }
            let cachedResponse = CachedURLResponse(response: response, data: data)
            self.imageCache.storeCachedResponse(cachedResponse, for: request)
            guard let image = UIImage(data: data) else {
                return
            }
            completionHandler(image)

        }
        dataTask.resume()
    }

    private static func loadImageFromCache(
        request: URLRequest,
        completionHandler: @escaping (Result<UIImage, CacheError>) -> Void
    ) {
        if let data = self.imageCache.cachedResponse(for: request)?.data {
            guard let image = UIImage(data: data) else {
                completionHandler(.failure(.inValidCashedImageData))
                return
            }
            completionHandler(.success(image))
        } else {
            completionHandler(.failure(.absentCashedImage))
        }
    }

    static func fetchVideo(videoURL: URL, completionHandler: @escaping (AVURLAsset) -> Void) {
        if let cachedVideo = self.videoCache.object(forKey: videoURL.absoluteString as NSString) {
            completionHandler(cachedVideo)
        } else {
            DispatchQueue.global().async {
                let asset = AVURLAsset(url: videoURL)
                self.videoCache.setObject(asset, forKey: videoURL.absoluteString as NSString)
                completionHandler(asset)
            }
        }
    }
}

enum CacheError: Error {
    case absentCashedImage
    case inValidCashedImageData
}
