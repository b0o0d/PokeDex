//
//  PokemonDetailPresenter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit

class PokemonDetailPresenter {
    private let coordinator: PokemonDetailCoordinator
    let pokemon: PokemonDisplay
    private let repository: (any PokemonRepositoryProtocol)?
    private(set) var maxSpeciesID: Int
    
    init(coordinator: PokemonDetailCoordinator, pokemon: PokemonDisplay, pokemonRepository: (any PokemonRepositoryProtocol)?) {
        self.coordinator = coordinator
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
    
    func updatePokemon(imageURLStr: String, image: UIImage) throws {
        guard let display = repository?.displayables.first(where: { $0.imageURL == imageURLStr}) as? PokemonDisplay else {
            return
        }
        display.image = image.pngData()
        try repository?.updatePokemonDisplay(display)
    }
    
    func fetchUntilSpeciesID(_ id: Int) async throws {
        try await repository?.loadPokemonDisplayListUntil(speciesID: id)
    }
    
    func evolutionPokemonDisplay(for speciesID: Int) -> PokemonDisplay? {
        return repository?.loadPokemonDisplay(speciesID: speciesID) as? PokemonDisplay
    }
    
    func pushToPokemonDetail(for speciesID: Int) {
        guard let evolutionPokemonDisplay = evolutionPokemonDisplay(for: speciesID) else {
            return
        }
        Task {
            await MainActor.run {
                coordinator.goToNextDetail(model: evolutionPokemonDisplay)
            }
        }
    }
    
    func finish() {
        coordinator.finish()
    }
}
