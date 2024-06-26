//
//  PokemonListViewController.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit
import SnapKit

class PokemonListViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(PokemonListCell.self, forCellReuseIdentifier: PokemonListCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var tableViewDataSource:
        UITableViewDiffableDataSource<Int, PokemonDisplay> = {
        let dataSource =
            UITableViewDiffableDataSource<Int, PokemonDisplay>(tableView: tableView) { [weak self] (tableView, indexPath, display) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: PokemonListCell.reuseIdentifier, for: indexPath) as? PokemonListCell
                cell?.configure(with: display)
                cell?.imageDownloaded = { [weak self] url, image in
                    guard let self = self, let image = image, let imageURL = url else {
                        return
                    }
                    Task { [weak self] in
                        guard let self = self else {
                            return
                        }
                        guard let pokemonDisplay = self.presenter.displayables.first(where: { $0.imageURL == imageURL.absoluteString }) as? PokemonDisplay else {
                            return
                        }
                        pokemonDisplay.image = image.pngData()
                        try self.presenter.update(pokemonDisplay)
                    }
                }
                cell?.favoriteTapped = { [weak self] speciesID in
                    Task {
                        guard let pokemonDisplay = self?.presenter.displayables.first(where: { $0.speciesID == speciesID }) as? PokemonDisplay else {
                            return
                        }
                        pokemonDisplay.isFavorite.toggle()
                        try self?.presenter.update(pokemonDisplay)
                    }
                }
                return cell
            }
        return dataSource
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete All", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func deleteAllButtonTapped() {
        Task {
            try (presenter as? PokemonListPresenter)?.deleteAll()
        }
    }
    
    var presenter: PokemonPresenterInput & PokemonListProtocol
    
    init(presenter: PokemonPresenterInput & PokemonListProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? presenter.sync()
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            guard let cell = tableView.cellForRow(at: indexPath) as? PokemonListCell else {
                continue
            }
            cell.favoriteButton.isSelected = (presenter.displayables[indexPath.row] as? PokemonDisplay)?.isFavorite ?? false
        }
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(favoriteButton)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-16)
            make.width.height.equalTo(44)
        }
        
        view.addSubview(deleteAllButton)
        deleteAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(favoriteButton.snp.top).offset(-16)
        }
    }
    
    func updateSnapshot() {
        guard let displayables = presenter.displayables as? [PokemonDisplay] else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, PokemonDisplay>()
        snapshot.appendSections([0])
        snapshot.appendItems(displayables)
        tableViewDataSource.apply(snapshot)
    }
    
    @objc func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        presenter.filterFavorites()
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.displayables.count - 20 {
            Task {
                try await presenter.load()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pokemonDisplay = presenter.displayables[indexPath.row] as? PokemonDisplay else {
            return
        }
        presenter.presentDetail(pokemonDisplay)
    }
}

extension PokemonListViewController: PokemonRepositoryDelegate {
    func didUpdateList() {
        DispatchQueue.main.async {
            self.updateSnapshot()
        }
    }
}
