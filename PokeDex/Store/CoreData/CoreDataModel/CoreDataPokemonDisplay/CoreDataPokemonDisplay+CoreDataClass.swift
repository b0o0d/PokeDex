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
    static func findOrCreatePokemonDisplay(matching pokemonDisplay: PokemonDisplay, in context: NSManagedObjectContext) throws -> CoreDataPokemonDisplay {
        let request: NSFetchRequest<CoreDataPokemonDisplay> = CoreDataPokemonDisplay.fetchRequest()
        request.predicate = NSPredicate(format: "speciesID = %d", pokemonDisplay.speciesID)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "CoreDataPokemonDisplay.findOrCreatePokemonDisplay -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        return CoreDataPokemonDisplay(pokemonDisplay: pokemonDisplay, context: context)
    }
    
    init(pokemonDisplay: PokemonDisplay, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataPokemonDisplay", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.speciesID = Int32(pokemonDisplay.speciesID)
        self.name = pokemonDisplay.name
        self.types = pokemonDisplay.types
        self.imageURL = pokemonDisplay.imageURL
        self.image = pokemonDisplay.image
        self.evolutionChain = try! CoreDataPokemonEvolutionChain.findOrCreatePokemonEvolutionChain(matching: pokemonDisplay.evolutionChain, in: context)
        self.flavorTextEntries = NSSet(array: pokemonDisplay.flavorTextEntries.map { pokemonFlavorText in
            return try! CoreDataPokemonFlavorText.findOrCreatePokemonFlavorText(matching: pokemonFlavorText, in: context)
        })
        self.isFavorite = pokemonDisplay.isFavorite
    }
}
