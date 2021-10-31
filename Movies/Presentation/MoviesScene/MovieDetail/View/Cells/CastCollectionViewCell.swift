// CastCollectionViewCell.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
    // MARK: - Private Properties

    private let actorImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    // MARK: - Initializers

    override func layoutSubviews() {
        super.layoutSubviews()
        actorImageView.frame = contentView.bounds
        contentView.addSubview(actorImageView)
    }

    // MARK: - Public Methods

    func configureCell(cast: Cast) {
        loadImage(path: cast.profilePath, imageView: actorImageView)
    }
}
