//
//  CoreDataPokemonEvolution+CoreDataProperties.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData


extension CoreDataPokemonEvolution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPokemonEvolution> {
        return NSFetchRequest<CoreDataPokemonEvolution>(entityName: "CoreDataPokemonEvolution")
    }

    @NSManaged public var evolvesTo: NSSet?

}

// MARK: Generated accessors for evolvesTo
extension CoreDataPokemonEvolution {

    @objc(addEvolvesToObject:)
    @NSManaged public func addToEvolvesTo(_ value: CoreDataPokemonEvolution)

    @objc(removeEvolvesToObject:)
    @NSManaged public func removeFromEvolvesTo(_ value: CoreDataPokemonEvolution)

    @objc(addEvolvesTo:)
    @NSManaged public func addToEvolvesTo(_ values: NSSet)

    @objc(removeEvolvesTo:)
    @NSManaged public func removeFromEvolvesTo(_ values: NSSet)

}

extension CoreDataPokemonEvolution : Identifiable {

}
