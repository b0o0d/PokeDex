//
//  PokemonDetailCoordinator.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit

protocol Finishable: Coordinator {
    func finish()
}

extension Finishable {
    func finish() {
        parentCoordinator?.childDidfinish(self)
    }
}

class PokemonDetailCoordinator: Pushable, Finishable {
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: (Coordinator)?
    
    let pokemonDisplay: PokemonDisplay
    let pokemonStore: (any PokemonStoreServiceProtocol)?
    
    init(navigationController: UINavigationController?, model: PokemonDisplay, pokemonStore: (any PokemonStoreServiceProtocol)?) {
        self.navigationController = navigationController
        self.pokemonDisplay = model
        self.pokemonStore = pokemonStore
    }
    
    func start() {
        let viewController = PokemonDetailFactory.create(coordinator: self, model: pokemonDisplay, pokemonStore: pokemonStore)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
