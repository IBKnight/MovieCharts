// DetailMovie.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation
import RealmSwift

@objc final class MovieDetail: Object, Codable {
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case homepage
        case imdbID = "imdb_id"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case status, title, id
        case voteAverage = "vote_average"
    }

    // MARK: - Public Properties

    @objc dynamic var backdropPath: String?
    /// Домашняя страница фильма
    @objc dynamic var homepage: String?
    /// Оригинальное название фильма
    @objc dynamic var originalTitle: String?
    /// Краткое описание фильма
    @objc dynamic var overview: String?
    /// Путь к основному постеру фильма
    @objc dynamic var posterPath: String?
    /// Дата выхода на экран
    @objc dynamic var releaseDate: String?
    /// Время фильма в минутах
    @objc dynamic var runtime = Int()
    /// Текущий статус (в прокате, выпущен, ожидается и т.д.)
    @objc dynamic var status: String?
    /// Название фильма
    @objc dynamic var title: String?
    /// Средний балл фильма
    @objc dynamic var voteAverage = Float()
    /// id  фильма на сайте imdb.com
    @objc dynamic var imdbID: String?
    /// id  фильма - primaryKey
    @objc dynamic var id: Int

    // MARK: - MovieDetail

    override class func primaryKey() -> String {
        "id"
    }
}
