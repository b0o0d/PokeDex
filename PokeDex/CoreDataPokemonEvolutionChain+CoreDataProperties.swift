//
//  CoreDataPokemonEvolutionChain+CoreDataProperties.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData


extension CoreDataPokemonEvolutionChain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPokemonEvolutionChain> {
        return NSFetchRequest<CoreDataPokemonEvolutionChain>(entityName: "CoreDataPokemonEvolutionChain")
    }

    @NSManaged public var id: Int32
    @NSManaged public var evolvesTo: CoreDataPokemonEvolution?

}

extension CoreDataPokemonEvolutionChain : Identifiable {

}
