//
//  CoreDataPokemonEvolutionChain+CoreDataClass.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData

@objc(CoreDataPokemonEvolutionChain)
public class CoreDataPokemonEvolutionChain: NSManagedObject {
    static func findOrCreatePokemonEvolutionChain(matching pokemonEvolutionChain: PokemonEvolutionChain, in context: NSManagedObjectContext) throws -> CoreDataPokemonEvolutionChain {
        let request: NSFetchRequest<CoreDataPokemonEvolutionChain> = CoreDataPokemonEvolutionChain.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", pokemonEvolutionChain.id)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "CoreDataPokemonEvolutionChain.findOrCreatePokemonEvolutionChain -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        return CoreDataPokemonEvolutionChain(matching: pokemonEvolutionChain, context: context)
    }
    
    init(matching pokemonEvolutionChain: PokemonEvolutionChain, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataPokemonEvolutionChain", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.id = Int32(pokemonEvolutionChain.id)
        self.evolvesTo = try! CoreDataPokemonEvolution.findOrCreatePokemonEvolution(matching: pokemonEvolutionChain.evolvesTo, in: context)
    }
}
