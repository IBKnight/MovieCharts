// DetailMovieTableViewCell.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class DetailMovieTableViewCell: UITableViewCell {
    // MARK: - Public Properties

    var imdbID: String?

    // MARK: - Private Properties

    private let movieImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let movieBackGroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.75
        return view
    }()

    private let backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleToFill
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()

    private let movieParametrsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 14
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieRateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Public Methods

    func configureCell(movie: MovieDetail) {
        loadImage(path: movie.backdropPath, imageView: movieBackGroundImageView)

        var moviedescription = "*"
        if let movieDate = movie.releaseDate {
            moviedescription += " \(movieDate.prefix(4)) *"
        }

        moviedescription += " \(movie.runtime) мин. *"
        movieParametrsLabel.text = moviedescription

        if let detaildescription = movie.overview {
            movieDescriptionLabel.text = detaildescription
        }

        if let imdbIDpath = movie.imdbID {
            imdbID = imdbIDpath
        }
    }

    // MARK: - Private Methods

    private func setupCell() {
        accessibilityIdentifier = "DetailTableViewCell"
        contentView.addSubview(movieBackGroundImageView)
        contentView.addSubview(movieParametrsLabel)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(backGroundView)

        createMovieBackGroundImageViewConstraints()
        createMovieParametrsLabelConstraints()
        createMovieDescriptionLabelConstraints()
        createbackgroundViewConstraints()
    }

    private func createMovieBackGroundImageViewConstraints() {
        movieBackGroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        movieBackGroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieBackGroundImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 2)
            .isActive = true
        movieBackGroundImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        movieBackGroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -350)
            .isActive = true
    }

    private func createbackgroundViewConstraints() {
        backGroundView.leftAnchor.constraint(equalTo: movieBackGroundImageView.leftAnchor).isActive = true
        backGroundView.rightAnchor.constraint(equalTo: movieBackGroundImageView.leftAnchor, constant: -50)
            .isActive = true
        backGroundView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        backGroundView.bottomAnchor.constraint(equalTo: movieBackGroundImageView.bottomAnchor).isActive = true
    }

    private func createMovieParametrsLabelConstraints() {
        movieParametrsLabel.topAnchor.constraint(equalTo: movieBackGroundImageView.bottomAnchor).isActive = true
        movieParametrsLabel.centerXAnchor.constraint(equalTo: movieBackGroundImageView.centerXAnchor).isActive = true
        movieParametrsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        movieParametrsLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    private func createMovieDescriptionLabelConstraints() {
        movieDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
            .isActive = true
        movieDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
            .isActive = true
        movieDescriptionLabel.topAnchor.constraint(equalTo: movieParametrsLabel.bottomAnchor, constant: 1)
            .isActive = true
    }
}
