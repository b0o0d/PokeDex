//
//  PokemonDetailPresenter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation

class PokemonDetailPresenter {
    private let coordinator: any Pushable & Finishable
    private let pokemon: PokemonDisplay
    private let pokemonStoreService: (any PokemonStoreServiceProtocol)?
    
    init(coordinatore: any Pushable & Finishable, pokemon: PokemonDisplay, pokemonStoreService: (any PokemonStoreServiceProtocol)?) {
        self.coordinator = coordinatore
        self.pokemon = pokemon
        self.pokemonStoreService = pokemonStoreService
    }
    
    var didUpdateFavorite: ((Bool) -> Void)?
    
    func toggleFavorite() {
        pokemon.isFavorite.toggle()
        Task {
            try pokemonStoreService?.updatePokemonDisplay(pokemon)
        }
    }
}
