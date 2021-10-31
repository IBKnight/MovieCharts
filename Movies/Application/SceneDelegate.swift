// SceneDelegate.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit
/// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        self.window = window

        let assembly = Assembly()

        let coordinator = ApplicationCoordinator(assembly: assembly)
        coordinator.start()
    }
}
