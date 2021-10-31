// WebViewController.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Visual Component

    private var webView = WKWebView()

    // MARK: - Public Properties

    var imdbID: String?

    // MARK: - UIViewController

    override func loadView() {
        let webconfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webconfiguration)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showURL()
    }

    // MARK: - Private Methods

    private func showURL() {
        if let imdbID = imdbID {
            let imdbURL = "https://www.imdb.com/title/\(imdbID)"
            guard let url = URL(string: imdbURL) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
