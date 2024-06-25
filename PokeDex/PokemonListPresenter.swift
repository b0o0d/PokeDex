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
}

class PokemonListPresenter: PokemonListProtocol, PokemonPresenterInput {
    private let coordinator: any Pushable
    private let repository: PokemonRepositoryProtocol

    weak var output: PokemonRepositoryDelegate?
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
    
    init(coordinator: any Pushable, repository: PokemonRepositoryProtocol) {
        self.coordinator = coordinator
        self.repository = repository
        if displayables.isEmpty {
            Task {
                try await load()
            }
        }
    }
}

extension PokemonListPresenter {
    func load() async throws {
        try await repository.loadPokemonDisplayList()
    }
    
    func update(_ pokemonDisplay: PokemonDisplay) throws {
        guard let dataSource = displayables.first(where: { $0.speciesID == pokemonDisplay.speciesID }) as? PokemonDisplay else {
            return
        }
        
        try repository.updatePokemonDisplay(pokemonDisplay)
    }
    
    func filterFavorites() {
        isFocusFavorites.toggle()
    }
    
    func presentDetail(_ pokemonDisplay: PokemonDisplay) {
        coordinator.push(model: pokemonDisplay, pokemonStore: repository.storeService)
    }
}
