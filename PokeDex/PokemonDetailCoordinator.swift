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
