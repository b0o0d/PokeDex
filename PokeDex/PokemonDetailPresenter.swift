//
//  PokemonDetailPresenter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation

class PokemonDetailPresenter {
    private let coordinator: any Pushable & Finishable
    let pokemon: PokemonDisplay
    private let repository: (any PokemonRepositoryProtocol)?
    
    init(coordinatore: any Pushable & Finishable, pokemon: PokemonDisplay, pokemonRepository: (any PokemonRepositoryProtocol)?) {
        self.coordinator = coordinatore
        self.pokemon = pokemon
        self.repository = pokemonRepository
        self.maxSpeciesID = repository?.displayables.last?.speciesID ?? pokemon.speciesID
    }
    
    var didUpdateFavorite: ((Bool) -> Void)?
    
    func toggleFavorite() {
        pokemon.isFavorite.toggle()
        Task {
            try repository?.updatePokemonDisplay(pokemon)
        }
    }
    
    func evolutionPokemonDisplay(for speciesID: Int) throws -> PokemonDisplay? {
        return try pokemonStoreService?.fetchPokemonDisplay(speciesID: speciesID)
    }
    
    func pushToPokemonDetail(for speciesID: Int) throws {
        guard let evolutionPokemonDisplay = try evolutionPokemonDisplay(for: speciesID) else {
            return
        }
        coordinator.push(model: evolutionPokemonDisplay, pokemonStore: pokemonStoreService)
    }
    
    func finish() {
        coordinator.finish()
    }
}
