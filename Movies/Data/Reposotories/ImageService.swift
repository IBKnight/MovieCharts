// ImageService.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class ImageService: ImageServiceProtocol {
    // MARK: - Public methods

    func getImage(url: URL, compleation: @escaping (Result<UIImage, Error>) -> Void) {
        let imageAPIService = ImageAPIService()
        let fileManagerService = FileManagerService()
        let proxy = Proxy(imageAPIService: imageAPIService, fileManagerService: fileManagerService)

        proxy.loadImage(url: url) { result in
            switch result {
            case let .success(image):
                compleation(.success(image))
            case let .failure(error):
                compleation(.failure(error))
            }
        }
    }
}
