// MoviesTests.swift
// Copyright © Эдуард Еленский. All rights reserved.

@testable import Movies
import UIKit
import XCTest

final class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

final class MoviesTests: XCTestCase {
    var coordinator: ApplicationCoordinator!
    var navController: MockNavigationController!
    var assembly: AssemblyProtocol!

    override func setUpWithError() throws {
        navController = MockNavigationController()
        assembly = Assembly()
        coordinator = ApplicationCoordinator(assembly: assembly, navController: navController)
    }

    override func tearDownWithError() throws {
        navController = nil
        assembly = nil
        assembly = nil
    }

    func testMainViewControllerScreen() throws {
        coordinator.start()
        let movieViewController = navController.presentedVC
        XCTAssertTrue(movieViewController is MovieViewController)
    }

    func testDetailiewControllerScreen() {
        coordinator.start()
        guard let movieViewController = navController.presentedVC as? MovieViewController else { return }
        movieViewController.toDetailScreen?(0, "")
        let movieDetailViewController = navController.presentedVC
        XCTAssertTrue(movieDetailViewController is MovieDetailViewController)
    }
}
