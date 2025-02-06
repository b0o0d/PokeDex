//
//  PokemonDetailFactory.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation

class PokemonDetailFactory {
    static func create(coordinator: PokemonDetailCoordinator, model: PokemonDisplay, pokemonRepository: (any PokemonRepositoryProtocol)?) -> PokemonDetailViewController {
        let presenter = PokemonDetailPresenter(coordinator: coordinator, pokemon: model, pokemonRepository: pokemonRepository)
        let viewController = PokemonDetailViewController(presenter: presenter)
        return viewController
    }
}
