// UICollectionViewCell + Extension.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

extension UICollectionViewCell {
    func loadImage(path: String?, imageView: UIImageView?) {
        let staticPath = "https://image.tmdb.org/t/p/w500/"
        guard let path = path,
              let url = URL(string: staticPath + path) else { return }

        let imageService = ImageService()

        imageService.getImage(url: url) { [weak imageView] result in
            switch result {
            case let .success(image):
                imageView?.image = image
            case let .failure(imageError):
                print(imageError.localizedDescription)
            }
        }
    }
}
