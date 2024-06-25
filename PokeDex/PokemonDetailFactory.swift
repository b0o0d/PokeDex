//
//  PokemonDetailFactory.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation

class PokemonDetailFactory {
    static func create(coordinator: Pushable & Finishable, model: PokemonDisplay, pokemonStore: (any PokemonStoreServiceProtocol)?) -> PokemonDetailViewController {
        let presenter = PokemonDetailPresenter(coordinatore: coordinator, pokemon: model, pokemonStoreService: pokemonStore)
        let viewController = PokemonDetailViewController(presenter: presenter)
        return viewController
    }
}
