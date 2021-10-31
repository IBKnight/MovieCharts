// MovieDetailViewModelTest.swift
// Copyright © Эдуард Еленский. All rights reserved.

@testable import Movies
import XCTest

final class MovieDetailViewModelTest: XCTestCase {
    var movieViewModel: MovieDetailViewModelProtocol!
    var movieAPIService: MovieAPIServiceProtocol!
    var repository = RealmRepository<MovieDetail>()
    var movieDetail: MovieDetail?
    var cast: [Cast] = []

    override func tearDown() {
        movieViewModel = nil
        movieAPIService = nil
    }

    func testGetDetailsMovie() {
        movieDetail = MovieDetail()
        movieDetail?.posterPath = "Baz Baz Baz Baz Baz Baz"
        movieDetail?.id = 777
        movieDetail?.title = "Baz Bar 1111"

        var moviesDetail: [MovieDetail] = []

        moviesDetail.append(movieDetail ?? MovieDetail())

        let movieAPIService = MockNetworkService(movie: moviesDetail)

        let movieViewModel = MovieDetailViewModel(movieAPIService: movieAPIService, repository: repository)

        XCTAssertNotNil(movieViewModel)

        var catchMovieDetail: MovieDetail?

        movieAPIService.fetchDataDetail(filmID: 777) { result in
            switch result {
            case let .success(succeccMovie):
                catchMovieDetail = succeccMovie
            default:
                XCTAssertThrowsError("Ошибка получения данных")
            }
        }

        XCTAssertNotNil(catchMovieDetail)

        XCTAssertEqual(catchMovieDetail?.id, 777)
    }

    func testMovieCast() {
        let firstActor = Cast(
            name: "Baz",
            character: "Bar",
            profilePath: "Baz Bar"
        )

        cast.append(firstActor)

        let secondActor = Cast(
            name: "Bar",
            character: "Baz",
            profilePath: "Bar Baz"
        )

        cast.append(secondActor)

        let movieAPIService = MockNetworkService(cast: cast)

        let movieViewModel = MovieDetailViewModel(movieAPIService: movieAPIService, repository: repository)

        XCTAssertNotNil(movieViewModel)

        var catchCast: [Cast]?

        movieAPIService.fetchCastData(filmID: 999) { result in
            switch result {
            case let .success(casts):
                catchCast = casts
            default:
                XCTAssertThrowsError("Ошибка получения данных")
            }
        }

        XCTAssertNotNil(catchCast)
        XCTAssertEqual(catchCast?.count, 2)
    }
}
