// Repository.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation

protocol RepositoryProtocol: AnyObject {
    associatedtype Entity
    func get(format: String, filter: CVarArg) -> [Entity]
    func save(object: [Entity])
    func removeAll()
}

/// Repository
class Repository<DataBaseEntity>: RepositoryProtocol {
    typealias Entity = DataBaseEntity

    // MARK: - Public methods

    func get(format: String, filter: CVarArg) -> [Entity] {
        fatalError("")
    }

    func save(object: [Entity]) {
        fatalError("")
    }

    func removeAll() {}
}
