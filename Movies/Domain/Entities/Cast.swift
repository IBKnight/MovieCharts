// Cast.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation

// MARK: - Welcome

/// Массив актеров
struct CastList: Decodable {
    /// список актеров сыгравших в фильме
    let cast: [Cast]
}

// MARK: - Cast

// Актеры
struct Cast: Decodable {
    /// Имя Актера сыгравшего роль
    let name: String
    /// Имя персонажа в фильме
    let character: String?
    /// Путь к фотографии актера
    let profilePath: String?
}
