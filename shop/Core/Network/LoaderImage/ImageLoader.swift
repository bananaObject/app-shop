//
//  ImageLoader.swift
//  shop
//
//  Created by Ke4a on 22.02.2023.
//

import UIKit

// MARK: - Error

enum ImageLoaderError: Error {
    case invalidURL
    case requestError(Error?)
}

protocol ImageLoaderProtocol {
    /// Loading an  image data from the Internet, caching mode is enabled, it will check if the image data  is in the cache.
    /// - Parameters:
    ///   - url: Image URL
    ///   - completion: Will return the result: either the image data, or an error.
    func fetch(url: String, completion: @escaping (Result<Data, ImageLoaderError>) -> Void)
}

final class ImageLoader: ImageLoaderProtocol {
    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private var fileCache: ImageFileCacheProtocol?

    // MARK: - Initialization

    /// Creates an image loader with the ability to cache the image.
    /// - Parameter cached: Cache all received images, disabled by default.
    init(cached: Bool = false) {
        if cached {
            fileCache = ImageCache()
        }
    }

    // MARK: - Public Methods

    /// Get an image data from the web.
    /// - Parameters:
    ///   - url: Image address.
    ///   - completion: Will return the result: either the image data, or an error.
    ///
    /// If caching is enabled, it will first check it in the cache. If not, it will store it in the cache for later use.
    func fetch(url: String, completion: @escaping (Result<Data, ImageLoaderError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        if let cache = fileCache, let data = cache.getImageData(for: url) {
            completion(.success(data))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        urlSession.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else {
                completion(.failure(.requestError(error)))
                return
            }

            if let cache = self.fileCache {
                cache.saveImage(url: url, data: data)
            }

            completion(.success(data))
        }.resume()
    }
}

// MARK: - Cache Class

extension ImageLoader {
    private final class ImageCache: ImageFileCacheProtocol {
        /// Accumulates images  datas while the object lives.
        private var imagesData: [String: Data] = [:]

        func saveImage(url: URL, data: Data) {
            DispatchQueue.global().async {
                guard let fileName = self.getFilePath(url: url.absoluteString) else { return }
                FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
            }
        }

        func getImageData(for url: URL) -> Data? {
            if let data = imagesData[url.absoluteString] {
                return data
            }

            guard let fileName = getFilePath(url: url.absoluteString),
                  let info = try? FileManager.default.attributesOfItem(atPath: fileName),
                  let modificationDate = info[.modificationDate] as? Date else { return nil }

            let lifeTime = Date().timeIntervalSince(modificationDate)

            guard lifeTime <= cacheLifeTime,
                  let data = FileManager.default.contents(atPath: fileName) else {
                DispatchQueue.global().async {
                    do {
                        try FileManager.default.removeItem(atPath: fileName)
                    } catch {
                        print(error)
                    }
                }
                return nil
            }

            DispatchQueue.global().async {
                if self.imagesData.count > 200 {
                    self.imagesData.removeAll()
                }

                self.imagesData[url.absoluteString] = data
            }

            return data
        }
    }
}
