//
//  PokemonDisplay.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/22.
//

import Foundation
import CoreData

protocol PokemonDisplayable: Hashable {
    var speciesID: Int { get }
    var name: String { get }
    var types: [String] { get }
    var imageURL: String? { get }
    var image: Data? { get }
    var evolutionChain: PokemonEvolutionChain { get }
    var flavorText: PokemonFlavorText { get }
    var isFavorite: Bool { get set }
}

class PokemonDisplay: PokemonDisplayable {
    let speciesID: Int
    let name: String
    let types: [String]
    let imageURL: String?
    var image: Data?
    let evolutionChain: PokemonEvolutionChain
    let flavorText: PokemonFlavorText
    var isFavorite: Bool
    
    var coreDataObjectID: NSManagedObjectID?
    
    init(speciesID: Int,
         name: String,
         types: [String],
         imageURL: String?,
         image: Data? = nil,
         evolutionChain: PokemonEvolutionChain,
         flavorText: PokemonFlavorText,
         isFavorite: Bool = false,
         coreDataObjectID: NSManagedObjectID? = nil
    ) {
        self.speciesID = speciesID
        self.name = name
        self.types = types
        self.imageURL = imageURL
        self.image = image
        self.evolutionChain = evolutionChain
        self.flavorText = flavorText
        self.isFavorite = isFavorite
        self.coreDataObjectID = coreDataObjectID
    }
    
    // MARK: - Hashable
    static func == (lhs: PokemonDisplay, rhs: PokemonDisplay) -> Bool {
        return
            lhs.speciesID == rhs.speciesID &&
            lhs.name == rhs.name &&
            lhs.types == rhs.types &&
            lhs.imageURL == rhs.imageURL &&
            lhs.evolutionChain.id == rhs.evolutionChain.id &&
            lhs.flavorText.flavorText == rhs.flavorText.flavorText
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(speciesID)
        hasher.combine(name)
        hasher.combine(types)
        hasher.combine(imageURL)
        hasher.combine(evolutionChain.id)
        hasher.combine(flavorText.flavorText)
    }
}
