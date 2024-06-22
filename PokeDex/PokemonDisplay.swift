//
//  PokemonDisplay.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/22.
//

import Foundation

class PokemonDisplay {
    let speciesID: Int
    let name: String
    let types: [String]
    let imageURL: String?
    var image: Data?
    let evolutionChain: PokemonEvolutionChain
    let flavorTextEntries: [PokemonFlavorText]
    var isFavorite: Bool
    
    init(speciesID: Int, name: String, types: [String], imageURL: String?, evolutionChain: PokemonEvolutionChain, flavorTextEntries: [PokemonFlavorText], isFavorite: Bool = false) {
        self.speciesID = speciesID
        self.name = name
        self.types = types
        self.imageURL = imageURL
        self.evolutionChain = evolutionChain
        self.flavorTextEntries = flavorTextEntries
        self.isFavorite = isFavorite
    }
}
