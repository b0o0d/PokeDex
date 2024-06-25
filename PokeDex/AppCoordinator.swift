//
//  AppCoordinator.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit

protocol Pushable: Coordinator {
    func push(model: PokemonDisplay, pokemonStore: (any PokemonStoreServiceProtocol)?)
}

extension Pushable {
    func push(model: PokemonDisplay, pokemonStore: (any PokemonStoreServiceProtocol)?) {
        let coordinator = PokemonDetailCoordinator(navigationController: navigationController, model: model, pokemonStore: pokemonStore)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

class AppCoordinator: Pushable {
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = PokemonListFactory.create(coordinator: self)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
}
