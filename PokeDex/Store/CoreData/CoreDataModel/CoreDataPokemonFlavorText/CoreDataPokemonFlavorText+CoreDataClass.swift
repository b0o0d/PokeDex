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
    static func instance(speciesID: Int, pokemonFlavorText: PokemonFlavorText, context: NSManagedObjectContext) -> CoreDataPokemonFlavorText {
        context.performAndWait {
            guard let coreDataPokemonFlavorText = NSEntityDescription.insertNewObject(forEntityName: "CoreDataPokemonFlavorText", into: context) as? CoreDataPokemonFlavorText else {
                fatalError("Unable to create CoreDataPokemonFlavorText instance")
            }
            
            coreDataPokemonFlavorText.flavorText = pokemonFlavorText.flavorText.data(using: .utf8)
            coreDataPokemonFlavorText.language = pokemonFlavorText.language
            coreDataPokemonFlavorText.speciesID = Int32(speciesID)
            coreDataPokemonFlavorText.version = pokemonFlavorText.version
            
            return coreDataPokemonFlavorText
        }
    }
    
    static func existingInstance(speciesID: Int, pokemonFlavorText: PokemonFlavorText, context: NSManagedObjectContext) -> CoreDataPokemonFlavorText? {
        context.performAndWait {
            let fetchRequest: NSFetchRequest<CoreDataPokemonFlavorText> = CoreDataPokemonFlavorText.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "speciesID == %d", speciesID)
            
            do {
                let result = try context.fetch(fetchRequest)
                return result.first
            } catch {
                return nil
            }
        }
    }
}
