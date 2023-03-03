//
//  ImageFileCacheProtocol.swift
//  shop
//
//  Created by Ke4a on 22.02.2023.
//

import UIKit

protocol ImageFileCacheProtocol {
    /// Saves the image data in a file directory.
    /// - Parameters:
    ///   - url: The address will be used as an identifier.
    ///   - data: Image data.
    func saveImage(url: URL, data: Data)
    /// Get image data from file by url.
    /// - Parameter url: The address will be used as an identifier.
    /// - Returns: If the  image data is in the file cache, it will return the data.
    func getImageData(for url: URL) -> Data?
}

extension ImageFileCacheProtocol {
    /// Storage directory.
    var dirName: String {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask).first else { return pathName }

        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }

    /// Maximum cache lifetime. After which you need to update the cache.
    var cacheLifeTime: TimeInterval {
        30 * 24 * 60 * 60
    }

    /// The path to the image data.
    /// - Parameter url: The address will be used as an identifier.
    /// - Returns: If the file is in the cache, it will return the path string.
    func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask).first else { return nil }

        let hashName = url.split(separator: "?").first?.split(separator: "/").last ?? "default"

        return cachesDirectory.appendingPathComponent(self.dirName + "/" + hashName).path
    }
}
