// BaseCoordinator.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

// Базовый координатор
class BaseCoordinator {
    // MARK: - Public Properties

    var childCoordinators: [BaseCoordinator] = []

    // MARK: - Initializers

    required init(assembly: AssemblyProtocol, navController: UINavigationController? = nil) {}

    // MARK: - Public methods

    func start() {}

    func addDependency(_ coordinator: BaseCoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard !childCoordinators.isEmpty,
              let coordinator = coordinator
        else { return }
        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    func setAsRoot(_ controller: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
}
