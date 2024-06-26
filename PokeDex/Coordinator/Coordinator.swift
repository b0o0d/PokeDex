//
//  Coordinator.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func childDidfinish(_ coordinator: Coordinator)
}

extension Coordinator {
    func childDidfinish(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
