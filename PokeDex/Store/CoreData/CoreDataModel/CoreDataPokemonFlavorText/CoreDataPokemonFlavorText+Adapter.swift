//
//  CoreDataPokemonFlavorText+Adapter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

extension CoreDataPokemonFlavorText {
    func toPokemonFlavorText() -> PokemonFlavorText {
        return PokemonFlavorText(flavorText: flavorText ?? "",
                                 language: language ?? "",
                                 version: version ?? ""
        )
    }
}

extension Set where Element == CoreDataPokemonFlavorText {
    func toPokemonFlavorTexts() -> [PokemonFlavorText] {
        return map { $0.toPokemonFlavorText() }
    }
}
