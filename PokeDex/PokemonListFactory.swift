//
//  PokemonListFactory.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation

class PokemonListFactory {
    static func create(coordinator: Coordinator) -> PokemonListViewController {
        let apiClient = PokemonAPIClient()
        let storeService = PokemonCoreDataStoreService()
        let repository = PokemonRepository(storeService: storeService, apiClient: apiClient)
        let presenter = PokemonListPresenter(coordinator: coordinator, repository: repository)
        let viewController = PokemonListViewController(presenter: presenter)
        return viewController
    }
}
