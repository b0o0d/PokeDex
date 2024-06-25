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
    static func instance(pokemonEvolutionChain: PokemonEvolutionChain, context: NSManagedObjectContext) -> CoreDataPokemonEvolutionChain {
        context.performAndWait {
            let coreDataPokemonEvolutionChain = CoreDataPokemonEvolutionChain(context: context)
            
            coreDataPokemonEvolutionChain.id = Int32(pokemonEvolutionChain.id)
            coreDataPokemonEvolutionChain.evolvesTo = CoreDataPokemonEvolution.instance(pokemonEvolution: pokemonEvolutionChain.evolvesTo, context: context)
            return coreDataPokemonEvolutionChain
        }
    }
    
    static func existingInstance(pokemonEvolutionChain: PokemonEvolutionChain, context: NSManagedObjectContext) -> CoreDataPokemonEvolutionChain? {        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<CoreDataPokemonEvolutionChain> = CoreDataPokemonEvolutionChain.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", pokemonEvolutionChain.id)
            
            do {
                let result = try context.fetch(fetchRequest)
                return result.first
            } catch {
                return nil
            }
        }
    }
}
