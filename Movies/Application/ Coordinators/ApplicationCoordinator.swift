// ApplicationCoordinator.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    // MARK: - Public Properties

    var assembly: AssemblyProtocol?
    var navController: UINavigationController?

    // MARK: - Initializers

    required init(assembly: AssemblyProtocol, navController: UINavigationController? = nil) {
        self.assembly = assembly
        self.navController = navController
        super.init(assembly: assembly, navController: navController)
    }

    // MARK: - ApplicationCoordinator

    override func start() {
        toMain()
    }

    // MARK: - Private methods

    private func toMain() {
        guard let assembly = assembly else { fatalError() }

        let coordinator = MainCoordinator(assembly: assembly, navController: navController)

        coordinator.onFinishFlow = { [weak self] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
