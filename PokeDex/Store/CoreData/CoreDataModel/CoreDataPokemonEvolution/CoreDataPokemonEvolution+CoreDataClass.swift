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
    static func instance(pokemonEvolution: PokemonEvolution, context: NSManagedObjectContext) -> CoreDataPokemonEvolution {
        let coreDataPokemonEvolution = CoreDataPokemonEvolution(context: context)
        coreDataPokemonEvolution.speciesName = pokemonEvolution.speciesName
        coreDataPokemonEvolution.evolvesTo = NSSet(array: pokemonEvolution.evolvesTo.compactMap { CoreDataPokemonEvolution.instance(pokemonEvolution: $0, context: context)
        })
        return coreDataPokemonEvolution
    }
}
