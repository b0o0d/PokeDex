//
//  CoreDataPokemonFlavorText+Adapter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

extension CoreDataPokemonFlavorText {
    func toPokemonFlavorText() -> PokemonFlavorText {
        guard let data = flavorText, let text = String(data: data, encoding: .utf8), let lang = language, let ver = version else {
            return PokemonFlavorText(flavorText: "", language: "", version: "")
        }
        return PokemonFlavorText(flavorText: text,
                                 language: lang,
                                 version: ver
        )
    }
}
