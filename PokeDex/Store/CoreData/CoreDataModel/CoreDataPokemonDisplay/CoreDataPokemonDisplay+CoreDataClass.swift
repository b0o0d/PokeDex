//
//  CoreDataPokemonDisplay+CoreDataClass.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData

@objc(CoreDataPokemonDisplay)
public class CoreDataPokemonDisplay: NSManagedObject {
    static func instance(pokemonDisplay: PokemonDisplay, context: NSManagedObjectContext) -> CoreDataPokemonDisplay {
        context.performAndWait {
            let coreDataPokemonDisplay = CoreDataPokemonDisplay(context: context)
            
            coreDataPokemonDisplay.speciesID = Int32(pokemonDisplay.speciesID)
            coreDataPokemonDisplay.name = pokemonDisplay.name
            coreDataPokemonDisplay.types = pokemonDisplay.types
            coreDataPokemonDisplay.imageURL = pokemonDisplay.imageURL
            coreDataPokemonDisplay.image = pokemonDisplay.image
            coreDataPokemonDisplay.evolutionChain = CoreDataPokemonEvolutionChain.existingInstance(pokemonEvolutionChain: pokemonDisplay.evolutionChain, context: context)
            coreDataPokemonDisplay.flavorText = CoreDataPokemonFlavorText.existingInstance(speciesID: pokemonDisplay.speciesID, pokemonFlavorText: pokemonDisplay.flavorText, context: context)
            coreDataPokemonDisplay.isFavorite = pokemonDisplay.isFavorite
            
            return coreDataPokemonDisplay
        }
    }
}
