// DataStorageTests.swift
// Copyright © Эдуард Еленский. All rights reserved.

@testable import Movies
import RealmSwift
import XCTest

final class MockRealmRepository<RealmEntity: Object>: Repository<RealmEntity> {
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

@objc final class MockMovieRealmTest: Object, Codable {
    // MARK: - Public Properties

    /// Id фильма
    @objc dynamic var id: String?
    /// Название фильма
    @objc dynamic var title = String()
    /// Категория фильма  0/1/2
    @objc dynamic var category: String?

    override class func primaryKey() -> String? {
        "id"
    }
}

final class MockRealmTest: XCTestCase {
    var movies: [MockMovieRealmTest] = []

    let queryFile = "category"

    let categorySearchFormat = "category == %@"

    func testSaveMovie() {
        let movieOne = MockMovieRealmTest()
        movieOne.category = "Baz"
        movieOne.id = "111222333"
        movieOne.title = "Baz Bar"

        let movietwo = MockMovieRealmTest()
        movietwo.category = "Baz"
        movietwo.id = "333222111"
        movietwo.title = "Bar Baz"

        movies.append(movieOne)
        movies.append(movietwo)

        let repository = MockRealmRepository<MockMovieRealmTest>()

        repository.save(object: movies)

        let categorBaz = repository.get(format: categorySearchFormat, filter: "Baz")

        XCTAssertNotNil(categorBaz)

        let categorBazBar = repository.get(format: categorySearchFormat, filter: "BazBar")

        XCTAssertEqual(categorBazBar.count, 0)
    }
}
