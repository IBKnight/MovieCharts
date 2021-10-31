// Host.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation
/// Подключение к сайту
struct Host {
    static let shared = Host()
    let api = "?api_key=cec56b23f60c04615b98c9f37fd386e3"
    let host = "https://api.themoviedb.org/3/movie/"
    private init() {}
}
