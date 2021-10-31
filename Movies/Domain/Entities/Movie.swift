// Movie.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation
import RealmSwift

/// UI Data Driven
enum ViewData<Model> {
    case loading
    case loaded([Model])
    case failure(description: String?)
}

/// Модель  списка  фильмов
struct IncomingJson: Decodable {
    /// Массив фильмов с кратким описанием
    var results: [MovieRealm]
    /// Количество страниц с фильмами
    let totalPages, totalResults: Int
}

@objc final class MovieRealm: Object, Codable {
    // MARK: - Public Properties

    @objc dynamic var backdropPath = String()
    /// Id фильма
    @objc dynamic var id = Int()
    /// Название фильма
    @objc dynamic var title = String()
    /// Путь к основному постеру фильма
    @objc dynamic var posterPath = String()
    /// Краткое описание
    @objc dynamic var overview = String()
    /// Рейтинг фильма
    @objc dynamic var voteAverage = Float()
    /// Категория фильма  0/1/2
    @objc dynamic var category: String?
    ///  Поле первичного ключа: category + id
    @objc dynamic var keyField: String?

    // MARK: - MovieRealm

    override class func primaryKey() -> String? {
        "keyField"
    }
}
