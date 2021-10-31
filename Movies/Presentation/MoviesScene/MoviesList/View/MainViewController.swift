// MainViewController.swift
// Copyright © Эдуард Еленский. All rights reserved.

import UIKit

typealias IntStringHandler = (Int, String) -> Void

final class MovieViewController: UIViewController {
    // MARK: - Public Properties

    var toDetailScreen: IntStringHandler?

    // MARK: - Private Properties

    private enum Constants {
        static let backgroundColorName = "buttonBackground"
        static let shadowColorName = "buttonShadow"
        static let borderColorName = "buttonBorder"
        static let popularButtonTitle = "Популярные"
        static let comingSoonButtonTitle = "В прокате"
        static let topRateButtonTitle = "Топ рейтинга"
        static let backBarTitle = "К списку"
        static let fontName = "Marker Felt Thin"
        static let cellID = "MovieCell"
        static let downloadError = "Ошибка загрузки"
    }

    private var tableView: UITableView?
    private var viewModel: MainScreenViewModelProtocol?
    private var activityIndicator: UIActivityIndicatorView?
    private var props: ViewData<MovieRealm> = .loading {
        didSet {
            switch props {
            case .loading:
                activityIndicator?.startAnimating()
                tableView?.isHidden = true
            case .loaded:
                activityIndicator?.stopAnimating()
                tableView?.isHidden = false
                tableView?.reloadData()
            case let .failure(description):
                activityIndicator?.stopAnimating()
                showAlert(title: Constants.downloadError, message: description)
            }
        }
    }

    // MARK: - Initializers

    convenience init(viewModel: MainScreenViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - IBAction

    @objc private func showMovieList(selector: UIButton) {
        buttonTransformAnimate(selector)
        getData(groupID: selector.tag)
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .black
        createFilmButtons()
        createTableView()
        createIndicator()
        props = ViewData.loading
        updateView()
    }

    private func createIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .lightGray
        activityIndicator?.hidesWhenStopped = true
        view.addSubview(activityIndicator ?? UIActivityIndicatorView())
        activityIndicator?.center = view.center
    }

    private func createFilmButtons() {
        let popularButton = configureRequestButton(title: Constants.popularButtonTitle)
        popularButton.tag = 1
        view.addSubview(popularButton)
        popularButton.accessibilityIdentifier = "popularButton"
        popularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popularButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        popularButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        popularButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        popularButton.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)

        let comingSoonButton = configureRequestButton(title: Constants.comingSoonButtonTitle)
        comingSoonButton.tag = 2
        comingSoonButton.accessibilityIdentifier = "comingSoonButton"
        view.addSubview(comingSoonButton)
        comingSoonButton.trailingAnchor.constraint(equalTo: popularButton.leadingAnchor, constant: -30).isActive = true
        comingSoonButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        comingSoonButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        comingSoonButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        comingSoonButton.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)

        let topRateButton = configureRequestButton(title: Constants.topRateButtonTitle)
        topRateButton.tag = 0
        topRateButton.accessibilityIdentifier = "topRateButton"
        view.addSubview(topRateButton)
        topRateButton.leadingAnchor.constraint(equalTo: popularButton.trailingAnchor, constant: 30).isActive = true
        topRateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        topRateButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        topRateButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        topRateButton.addTarget(self, action: #selector(showMovieList), for: .touchUpInside)
    }

    private func createTableView() {
        let displayWidth: CGFloat = view.frame.width
        let displayHeight: CGFloat = view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: 100, width: displayWidth, height: displayHeight))
        tableView?.register(MovieTableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.estimatedRowHeight = 200.0
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.backgroundColor = .black
        tableView?.accessibilityIdentifier = "MovieView"
        view.addSubview(tableView ?? UITableView())
    }

    private func configureRequestButton(title: String) -> UIButton {
        let buttonTopRate: UIButton = {
            let button = UIButton()
            let fontName = Constants.fontName
            button.setTitle(title, for: .normal)
            button.backgroundColor = UIColor(named: Constants.backgroundColorName)
            button.layer.cornerRadius = 10
            button.layer.shadowColor = UIColor(named: Constants.shadowColorName)?.cgColor
            button.layer.shadowOpacity = 0.7
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor(named: Constants.borderColorName)?.cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont(name: fontName, size: 16)
            button.setTitleColor(.black, for: .normal)
            return button
        }()
        return buttonTopRate
    }

    private func buttonTransformAnimate(_ selector: UIButton) {
        UIView.animate(withDuration: 0.2) {
            selector.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                selector.transform = CGAffineTransform.identity
            }
        }
    }

    private func tableViewAnimate(_ cell: UITableViewCell) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }

    private func updateView() {
        viewModel?.updateViewData = { [weak self] viewData in
            DispatchQueue.main.async {
                self?.props = viewData
            }
        }
    }

    private func getData(groupID: Int) {
        viewModel?.getData(groupID: groupID)
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .loaded(data) = props {
            let movieID = data[indexPath.row].id
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: Constants.backBarTitle,
                style: .plain,
                target: nil,
                action: nil
            )
            toDetailScreen?(movieID, data[indexPath.row].title ?? "")
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewAnimate(cell)
    }
}

// MARK: - UITableViewDataSource

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case let .loaded(data) = props {
            return data.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case let .loaded(data) = props {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.cellID,
                for: indexPath
            ) as? MovieTableViewCell {
                cell.configureCell(movie: data[indexPath.row])
                cell.backgroundColor = .black
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
}
