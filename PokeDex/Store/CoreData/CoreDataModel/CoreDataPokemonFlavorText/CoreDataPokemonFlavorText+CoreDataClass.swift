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
        guard let coreDataPokemonFlavorText = NSEntityDescription.insertNewObject(forEntityName: "CoreDataPokemonFlavorText", into: context) as? CoreDataPokemonFlavorText else {
            fatalError("Unable to create CoreDataPokemonFlavorText instance")
        }
        
        coreDataPokemonFlavorText.flavorText = pokemonFlavorText.flavorText.data(using: .utf8)
        coreDataPokemonFlavorText.language = pokemonFlavorText.language
        coreDataPokemonFlavorText.speciesID = Int32(speciesID)
        coreDataPokemonFlavorText.version = pokemonFlavorText.version
        
        return coreDataPokemonFlavorText
    }
    
    static func existingInstance(speciesID: Int, pokemonFlavorText: PokemonFlavorText, context: NSManagedObjectContext) -> CoreDataPokemonFlavorText? {
        let fetchRequest: NSFetchRequest<CoreDataPokemonFlavorText> = CoreDataPokemonFlavorText.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "speciesID == %d && language == %@ AND version == %@", speciesID, pokemonFlavorText.language, pokemonFlavorText.version)
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.first == nil {
                fatalError("Unable to fetch CoreDataPokemonFlavorText instance")
            }
            return result.first
        } catch {
            return nil
        }
    }
}
