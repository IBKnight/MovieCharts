// MainScreenViewModel.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation

protocol MainScreenViewModelProtocol {
    var updateViewData: ((ViewData<MovieRealm>) -> ())? { get set }
    func getData(groupID: Int)
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    // MARK: - Public Properties

    var updateViewData: ((ViewData<MovieRealm>) -> ())?

    // MARK: - Private Properties

    private enum Constants {
        static let queryFile = "category"
        static let baseSaveError = "Не удалось сохранить в БД"
    }

    private var repository: Repository<MovieRealm>?
    private var movieAPIService: MovieAPIServiceProtocol?

    // MARK: - Initializers

    init(
        movieAPIService: MovieAPIServiceProtocol,
        repository: Repository<MovieRealm>?
    ) {
        self.movieAPIService = movieAPIService
        self.repository = repository
        updateViewData?(.loading)
    }

    // MARK: - Public methods

    func getData(groupID: Int) {
        let categorySearchFormat = "\(Constants.queryFile) == %@"
        let savedMovies = repository?.get(format: categorySearchFormat, filter: String(groupID))

        if !(savedMovies?.isEmpty ?? true) {
            guard let savedMovies = savedMovies else { return }
            updateViewData?(.loaded(savedMovies))
            return
        }

        movieAPIService?.fetchData(groupID: groupID) { [weak self] result in
            switch result {
            case let .success(movies):
                DispatchQueue.main.async {
                    movies.forEach {
                        $0.category = String(groupID)
                        $0.keyField = "Category:\(groupID) id: \($0.id)"
                    }
                    self?.repository?.save(object: movies)
                    guard let savedMovies = self?.repository?
                        .get(format: categorySearchFormat, filter: String(groupID))
                    else {
                        self?.updateViewData?(.failure(description: Constants.baseSaveError))
                        return
                    }
                    self?.updateViewData?(.loaded(savedMovies))
                }
            case let .failure(.jsonSerializationError(error)):
                self?.updateViewData?(.failure(description: error.localizedDescription))
            }
        }
    }
}
