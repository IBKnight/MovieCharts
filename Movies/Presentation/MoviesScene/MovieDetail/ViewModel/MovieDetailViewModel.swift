// MovieDetailViewModel.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation

typealias VoidHandler = (() -> ())

protocol MovieDetailViewModelProtocol {
    var movieDetail: MovieDetail? { get set }
    var updateViewData: VoidHandler? { get set }
    var showError: VoidHandler? { get set }
    var error: String? { get set }
    func getData(filmID: Int)
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Public Properties

    var updateViewData: VoidHandler?
    var showError: VoidHandler?
    var movieDetail: MovieDetail?
    var error: String?

    // MARK: - Private Properties

    private var repository: Repository<MovieDetail>?
    private var movieAPIService: MovieAPIServiceProtocol?

    private enum Constants {
        static let baseSaveError = "Не удалось сохранить в БД"
    }

    // MARK: - Initializers

    init(movieAPIService: MovieAPIServiceProtocol, repository: Repository<MovieDetail>?) {
        self.movieAPIService = movieAPIService
        self.repository = repository
    }

    // MARK: - Public methods

    func getData(filmID: Int) {
        fetchDetailData(filmID: filmID)
    }

    // MARK: - Private methods

    private func fetchDetailData(filmID: Int) {
        let detailSearchFormat = "id == %d"
        let savedMovies = repository?.get(format: detailSearchFormat, filter: filmID)

        if !(savedMovies?.isEmpty ?? true) {
            guard let savedMovies = savedMovies else { return }
            movieDetail = savedMovies.first
            return
        }

        movieAPIService?.fetchDataDetail(filmID: filmID) { [weak self] result in
            switch result {
            case let .success(movieDetail):
                DispatchQueue.main.async {
                    movieDetail.id = filmID
                    self?.repository?.save(object: [movieDetail])
                    guard let savedMovies = self?.repository?.get(format: detailSearchFormat, filter: filmID) else {
                        self?.showError?()
                        self?.error = Constants.baseSaveError
                        return
                    }
                    self?.movieDetail = savedMovies.first
                    self?.updateViewData?()
                }
            case let .failure(.jsonSerializationError(error)):
                self?.showError?()
                self?.error = error.localizedDescription
            }
        }
    }
}
