//
//  CoreDataPokemonEvolution+CoreDataClass.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData

@objc(CoreDataPokemonEvolution)
public class CoreDataPokemonEvolution: NSManagedObject {
    static func findOrCreatePokemonEvolution(matching pokemonEvolution: PokemonEvolution, in context: NSManagedObjectContext) throws -> CoreDataPokemonEvolution {
        let request: NSFetchRequest<CoreDataPokemonEvolution> = CoreDataPokemonEvolution.fetchRequest()
        request.predicate = NSPredicate(format: "speciesName = %d", pokemonEvolution.speciesName)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "CoreDataPokemonEvolution.findOrCreatePokemonEvolution -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        return CoreDataPokemonEvolution(pokemonEvolution: pokemonEvolution, context: context)
    }
    
    init(pokemonEvolution: PokemonEvolution, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataPokemonEvolution", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.speciesName = pokemonEvolution.speciesName
        self.evolvesTo = NSSet(array: pokemonEvolution.evolvesTo.map { pokemonEvolution in
            return try! CoreDataPokemonEvolution.findOrCreatePokemonEvolution(matching: pokemonEvolution, in: context)
        })
    }
}
