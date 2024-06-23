//
//  CoreDataPokemonFlavorText+CoreDataClass.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData

@objc(CoreDataPokemonFlavorText)
public class CoreDataPokemonFlavorText: NSManagedObject {
    static func findOrCreatePokemonFlavorText(matching pokemonFlavorText: PokemonFlavorText, in context: NSManagedObjectContext) throws -> CoreDataPokemonFlavorText {
        let request: NSFetchRequest<CoreDataPokemonFlavorText> = CoreDataPokemonFlavorText.fetchRequest()
        request.predicate = NSPredicate(format: "flavorText = %@ AND language = %@ AND version = %@", pokemonFlavorText.flavorText, pokemonFlavorText.language, pokemonFlavorText.version)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "CoreDataPokemonFlavorText.findOrCreatePokemonFlavorText -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let pokemonFlavorTextEntity = CoreDataPokemonFlavorText(pokemonFlavorText: pokemonFlavorText, context: context)
        return pokemonFlavorTextEntity
    }
    
    init(pokemonFlavorText: PokemonFlavorText, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataPokemonFlavorText", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.flavorText = pokemonFlavorText.flavorText
        self.language = pokemonFlavorText.language
        self.version = pokemonFlavorText.version
    }
}
