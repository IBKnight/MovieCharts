// MovieViewModelTest.swift
// Copyright © Эдуард Еленский. All rights reserved.

@testable import Movies
import XCTest

final class MockNetworkService: MovieAPIServiceProtocol {
    var filterDict = [0: "Baz", 1: "Bar"]

    var movies: [MovieRealm]?
    var movieDetail: [MovieDetail]?
    var movieCast: [Cast]?

    init() {}

    convenience init(movie: [MovieDetail]) {
        self.init()
        movieDetail = movie
    }

    convenience init(movies: [MovieRealm]) {
        self.init()
        self.movies = movies
    }

    convenience init(cast: [Cast]) {
        self.init()
        movieCast = cast
    }

    func fetchData(groupID: Int, compleation: @escaping ((Result<[MovieRealm], DownLoaderError>) -> ())) {
        let filterValue = filterDict[groupID]

        if let movies = movies {
            let filteredMovie = movies.filter { $0.category == filterValue }
            compleation(.success(filteredMovie))
            return
        }
    }

    func fetchDataDetail(filmID: Int, compleation: @escaping (Result<MovieDetail, DownLoaderError>) -> ()) {
        if let movieDetail = movieDetail {
            let filteredDetailMovies = movieDetail.filter { $0.id == filmID }
            guard let filteredDetailMovie = filteredDetailMovies.first else {
                return
            }
            compleation(.success(filteredDetailMovie))
            return
        }
    }

    func fetchCastData(filmID: Int, compleation: @escaping (Result<[Cast], DownLoaderError>) -> ()) {
        guard let movieCast = movieCast,
              filmID == 999 else { return }
        compleation(.success(movieCast))
    }
}

final class MovieViewModelTest: XCTestCase {
    var movieViewModel: MovieDetailViewModelProtocol!
    var movieAPIService: MovieAPIServiceProtocol!
    var repository = RealmRepository<MovieRealm>()
    var movies: [MovieRealm] = []

    override func tearDown() {
        movieViewModel = nil
        movieAPIService = nil
    }

    func testGetMovies() {
        let movieOne = MovieRealm()
        movieOne.category = "Baz"
        movieOne.id = 1111
        movieOne.title = "Baz Bar 1111"
        movies.append(movieOne)

        let movieTwo = MovieRealm()
        movieTwo.category = "Bar"
        movieTwo.id = 2222
        movieTwo.title = "Bar Baz 2222"
        movies.append(movieTwo)

        let movieAPIService = MockNetworkService(movies: movies)

        let movieViewModel = MainScreenViewModel(movieAPIService: movieAPIService, repository: repository)

        XCTAssertNotNil(movieViewModel)

        var catchMovies: [MovieRealm]?

        movieAPIService.fetchData(groupID: 0) { result in
            switch result {
            case let .success(fetchMovies):
                catchMovies = fetchMovies
            default:
                XCTAssertThrowsError("Ошибка получения данных")
            }
        }

        XCTAssertNotNil(catchMovies)
        XCTAssertEqual(catchMovies?.count, 1)

        let value = catchMovies?.first
        XCTAssertEqual(value?.id, 1111)
    }
}
