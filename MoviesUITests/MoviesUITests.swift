// MoviesUITests.swift
// Copyright © Эдуард Еленский. All rights reserved.

import XCTest

/// Элементы для второго экрана
struct MovieDetailPage {
    private let application = XCUIApplication()

    var view: XCUIElement {
        let id = "DetailTableView"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .table)
            .matching(predicate).element
    }

    var collectionView: XCUIElement {
        let id = "DetailCollectionViewID"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .collectionView)
            .matching(predicate).element
    }

    func itemViewTitle() -> XCUIElement {
        let id = "DetailView"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .staticText)
            .matching(predicate).element
    }

    func item(id: String) -> XCUIElement {
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return view.descendants(matching: .cell)
            .matching(predicate).element
    }
}

/// WebPage
struct WebPage {}

extension MovieDetailPage {
    func openDetailPage(byItemID itemID: String) -> WebPage {
        let itemElement = item(id: itemID)
        itemElement.tap()
        return WebPage()
    }
}

extension MoviePage {
    func openDetailPage(byItemID itemID: String) -> MovieDetailPage {
        let itemElement = item(id: itemID)
        itemElement.tap()
        return MovieDetailPage()
    }
}

/// Элементы для первого экрана
struct MoviePage {
    private let application = XCUIApplication()

    func item(id: String) -> XCUIElement {
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return view.descendants(matching: .cell)
            .matching(predicate).element
    }

    var view: XCUIElement {
        let id = "MovieView"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .table)
            .matching(predicate).element
    }

    var comingSoonButton: XCUIElement {
        let id = "comingSoonButton"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .button)
            .matching(predicate).element
    }

    var topRateButton: XCUIElement {
        let id = "topRateButton"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .button)
            .matching(predicate).element
    }

    var popularButton: XCUIElement {
        let id = "popularButton"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return XCUIApplication().descendants(matching: .button)
            .matching(predicate).element
    }

    func itemTitle(itemID: String) -> XCUIElement {
        let id = "Title"
        let predicate = NSPredicate(format: "identifier == '\(id)'")
        return item(id: itemID).descendants(matching: .staticText)
            .matching(predicate).element
    }
}

final class MovieTests: XCTestCase {
    var application: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        application = XCUIApplication()
        application.launch()
    }

    func testSimple() throws {
        let moviePage = MoviePage()

        let button1 = moviePage.comingSoonButton

        XCTAssert(button1.exists)
        button1.tap()

        let button2 = moviePage.topRateButton
        XCTAssert(button2.exists)
        button2.tap()

        let button3 = moviePage.popularButton
        XCTAssert(button3.exists)
        button3.tap()

        sleep(1)
        let itemCell = moviePage.itemTitle(itemID: String(580_489))
        XCTAssert(itemCell.exists)
        XCTAssertNotNil(itemCell.label)

        let movieTableView = moviePage.view
        XCTAssert(movieTableView.exists)
        movieTableView.swipeUp()
        movieTableView.swipeDown()

        let detailPage = moviePage.openDetailPage(byItemID: String(580_489))

        let detailPageTableview = detailPage.view
        XCTAssert(detailPageTableview.exists)
        detailPageTableview.swipeUp()
        detailPageTableview.swipeDown()

        let detailCollectionView = detailPage.collectionView
        XCTAssert(detailCollectionView.exists)
        sleep(2)
        detailCollectionView.swipeLeft()
        detailCollectionView.swipeRight()

        let detailTableCell = detailPage.item(id: "DetailTableViewCell")
        XCTAssert(detailTableCell.exists)
        detailTableCell.tap()

        sleep(5)
    }
}
