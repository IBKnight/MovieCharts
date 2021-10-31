// MovieTableViewCell.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class MovieTableViewCell: UITableViewCell {
    // MARK: - Public Properties

    var id: Int?

    // MARK: - Private Properties

    private let movieImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let movieShortDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 7
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieRateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let movieRatelabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
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

    func configureCell(movie: MovieRealm) {
        movieTitleLabel.accessibilityIdentifier = "Title"
        movieShortDescription.text = movie.overview
        movieTitleLabel.text = movie.title
        movieRatelabel.text = String(movie.voteAverage)

        id = movie.id

        if let id = id {
            accessibilityIdentifier = String(id)
        }
        loadImage(path: movie.posterPath, imageView: movieImageView)
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieShortDescription)
        contentView.addSubview(movieRateView)
        contentView.addSubview(movieRatelabel)

        createConstraints()
        createConstraintslabel()
        createConstraintsTitle()
        createConstraintsRateView()
        createConstraintsRateLabel()
    }

    private func createConstraints() {
        movieImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 3).isActive = true
        movieImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1 / 2).isActive = true
        movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func createConstraintsRateView() {
        movieRateView.rightAnchor.constraint(equalTo: movieImageView.rightAnchor).isActive = true
        movieRateView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        movieRateView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        movieRateView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor).isActive = true
    }

    private func createConstraintsTitle() {
        movieTitleLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10).isActive = true
        movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        movieTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5)
            .isActive = true
    }

    private func createConstraintslabel() {
        movieShortDescription.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10).isActive = true
        movieShortDescription.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor).isActive = true
        movieShortDescription.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5)
            .isActive = true
        movieShortDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            .isActive = true
    }

    private func createConstraintsRateLabel() {
        movieRatelabel.centerYAnchor.constraint(equalTo: movieRateView.centerYAnchor).isActive = true
        movieRatelabel.centerXAnchor.constraint(equalTo: movieRateView.centerXAnchor).isActive = true
        movieRatelabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        movieRatelabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
