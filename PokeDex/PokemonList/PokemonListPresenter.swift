//
//  PokemonListPresenter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation

protocol PokemonListProtocol {
    var output: PokemonRepositoryDelegate? { get set }
    var displayables: [any PokemonDisplayable] { get }
    var isFocusFavorites: Bool { get }
}

protocol PokemonPresenterInput {
    func load() async throws
    func update(_ pokemonDisplay: PokemonDisplay) throws
    func filterFavorites()
    func presentDetail(_ pokemonDisplay: PokemonDisplay)
    func sync() throws
}

class PokemonListPresenter: PokemonListProtocol, PokemonPresenterInput {
    private let coordinator: ListCoordinator
    private var repository: PokemonRepositoryProtocol

    weak var output: PokemonRepositoryDelegate? {
        didSet {
            repository.delegate = output
        }
    }
    var displayables: [any PokemonDisplayable] {
        if isFocusFavorites {
            return repository.displayables.filter { ($0 as? PokemonDisplay)?.isFavorite == true }
        } else {
            return repository.displayables
        }
    }
    var isFocusFavorites: Bool = false {
        didSet {
            output?.didUpdateList()
        }
    }
    
    init(coordinator: ListCoordinator, repository: PokemonRepositoryProtocol) {
        self.coordinator = coordinator
        self.repository = repository
        if displayables.isEmpty {
            Task {
                try await load()
            }
        }
    }
    
    func deleteAll() throws {
        try (repository.storeService as? PokemonCoreDataStoreService)?.deleteAll()
    }
}

extension PokemonListPresenter {
    func load() async throws {
        try await repository.loadPokemonDisplayList(limit: 0)
    }
    
    func update(_ pokemonDisplay: PokemonDisplay) throws {
        guard let source = displayables.first(where: { $0.speciesID == pokemonDisplay.speciesID }) as? PokemonDisplay else {
            return
        }
        
        try repository.updatePokemonDisplay(source)
    }
    
    func filterFavorites() {
        isFocusFavorites.toggle()
    }
    
    func presentDetail(_ pokemonDisplay: PokemonDisplay) {
        coordinator.goToDetail(model: pokemonDisplay, pokemonRepository: repository)
    }
    
    func sync() throws {
        try repository.sync()
    }
}
