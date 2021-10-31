// FileManagerService.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class FileManagerService: FileManagerServiceProtocol {
    // MARK: - Private Properties

    private var images = [String: UIImage]()
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    private static let pathname: String = {
        let pathName = "images"
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
        else { return pathName }

        let url = cacheDirectory.appendingPathComponent(pathName, isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()

    // MARK: - Public methods

    func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }

        let lifeTime = Date().timeIntervalSince(modificationDate)

        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }
        DispatchQueue.main.async {
            self.images[url] = image
        }
        return image
    }

    func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }

    // MARK: - Private methods

    private func getFilePath(url: String) -> String? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }

        let hashName = url.split(separator: "/").last ?? "default"

        return cacheDirectory.appendingPathComponent(FileManagerService.pathname + "/" + hashName).path
    }
}
