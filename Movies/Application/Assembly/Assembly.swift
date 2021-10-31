// Assembly.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

protocol AssemblyProtocol {
    func createMovieModule() -> UIViewController
    func createMovieDetailModule(movieID: Int) -> UIViewController
}

final class Assembly: AssemblyProtocol {
    // MARK: - Private methods

    func createMovieModule() -> UIViewController {
        let movieAPIService = MovieAPIService()
        let repository = RealmRepository<MovieRealm>()
        let viewModel = MainScreenViewModel(
            movieAPIService: movieAPIService,
            repository: repository
        )
        let view = MovieViewController(viewModel: viewModel)
        return view
    }

    func createMovieDetailModule(movieID: Int) -> UIViewController {
        let movieAPIService = MovieAPIService()
        let repository = RealmRepository<MovieDetail>()
        let viewModel = MovieDetailViewModel(
            movieAPIService: movieAPIService,
            repository: repository
        )
        let view = MovieDetailViewController(viewModel: viewModel, id: movieID)
        return view
    }
}
