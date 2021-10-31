// MovieDetailViewController.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

final class MovieDetailViewController: UIViewController {
    // MARK: - Private Properties

    private enum Constants {
        static let detailCellIdentifier = "DetailCell"
        static let castCellIdentifier = "CastCell"
        static let downloadError = "Ошибка загрузки"
    }

    private var tableview: UITableView!
    private var viewModel: MovieDetailViewModelProtocol?
    private let movieImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var id = Int()

    // MARK: - Initializers

    convenience init(
        viewModel: MovieDetailViewModelProtocol,
        id: Int
    ) {
        self.init()
        self.viewModel = viewModel
        self.id = id
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        let nav = navigationController?.navigationBar
        nav?.barStyle = .black
        nav?.tintColor = .white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - IBAction

    @objc private func showWebView() {
        let vc = WebViewController()
        vc.imdbID = viewModel?.movieDetail?.imdbID
        present(vc, animated: true)
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .black
        createTableView()
        updateView()
        getData(filmID: id)
    }

    private func createTableView() {
        let tableViewWigth: CGFloat = view.frame.width
        let tableViewHeight: CGFloat = view.frame.height

        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWigth, height: tableViewHeight))
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(DetailMovieTableViewCell.self, forCellReuseIdentifier: Constants.detailCellIdentifier)
        tableview.register(CastTableViewCell.self, forCellReuseIdentifier: Constants.castCellIdentifier)
        tableview.estimatedRowHeight = 200.0
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorColor = .clear
        tableview.backgroundColor = .black
        tableview.accessibilityIdentifier = "DetailTableView"
        view.addSubview(tableview)
    }

    private func addGesture() {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(showWebView))
        view.addGestureRecognizer(gesture)
    }

    private func updateView() {
        getDownloadError()
        viewModel?.updateViewData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableview.reloadData()
            }
        }
    }

    private func getDownloadError() {
        viewModel?.showError = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(
                    title: Constants.downloadError,
                    message: self?.viewModel?.error
                )
            }
        }
    }

    private func getData(filmID: Int) {
        viewModel?.getData(filmID: filmID)
    }
}

// MARK: - UITableViewDelegate

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableview.dequeueReusableCell(
                withIdentifier: Constants.detailCellIdentifier,
                for: indexPath
            ) as? DetailMovieTableViewCell {
                guard let movieDetail = viewModel?.movieDetail else { return UITableViewCell() }
                cell.configureCell(movie: movieDetail)
                cell.selectionStyle = .none
                cell.backgroundColor = .black
                addGesture()
                return cell
            }
        default:
            if let cell = tableview.dequeueReusableCell(
                withIdentifier: Constants.castCellIdentifier,
                for: indexPath
            ) as? CastTableViewCell {
                cell.setupCell(filmID: id)
                cell.selectionStyle = .none
                cell.backgroundColor = .black
                return cell
            }
        }
        return UITableViewCell()
    }
}
