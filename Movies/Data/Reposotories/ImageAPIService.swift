// ImageAPIService.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

typealias HandlerImage = (Result<UIImage, ImageLoadingError>) -> ()

// Ошибки при получении картинки из даты
enum ImageLoadingError: Error {
    case networkFailure(Error)
    case invalidData
}

final class ImageAPIService: ImageAPIServiceProtocol {
    // MARK: - Private Properties

    private var session = URLSession.shared

    // MARK: - Public methods

    func loadImage(url: URL, handler: @escaping HandlerImage) {
        session.dataTask(with: url) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    if let image = UIImage(data: data) {
                        handler(.success(image))
                    } else {
                        handler(.failure(.invalidData))
                    }
                case let .failure(error):
                    handler(.failure(.networkFailure(error)))
                }
            }
        }.resume()
    }
}
