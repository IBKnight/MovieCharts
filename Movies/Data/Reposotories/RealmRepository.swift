// RealmRepository.swift
// Copyright © Эдуард Еленский. All rights reserved.

import Foundation
import RealmSwift

final class RealmRepository<RealmEntity: Object>: Repository<RealmEntity> {
    typealias Entity = RealmEntity

    // MARK: - RealmRepository

    override func save(object: [Entity]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)

            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print(error)
        }
    }

    override func get(format: String, filter: CVarArg) -> [Entity] {
        let predicate = getPredicate(format: format, filter: filter)

        do {
            let realm = try Realm()
            let realmObjects = realm.objects(Entity.self).filter(predicate)
            var entityArray: [Entity] = []
            realmObjects.forEach {
                entityArray.append($0)
            }
            return entityArray
        } catch {
            return []
        }
    }

    private func getPredicate(format: String, filter: CVarArg) -> NSPredicate {
        NSPredicate(format: format, filter)
    }
}
