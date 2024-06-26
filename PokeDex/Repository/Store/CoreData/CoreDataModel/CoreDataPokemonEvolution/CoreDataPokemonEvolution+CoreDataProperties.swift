//
//  CoreDataPokemonEvolution+CoreDataProperties.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/24.
//
//

import Foundation
import CoreData


extension CoreDataPokemonEvolution {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPokemonEvolution> {
        return NSFetchRequest<CoreDataPokemonEvolution>(entityName: "CoreDataPokemonEvolution")
    }

    @NSManaged public var speciesID: Int32
    @NSManaged public var evolvesTo: NSSet?
    @NSManaged public var evolvesFrom: NSSet?

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

// MARK: Generated accessors for evolvesFrom
extension CoreDataPokemonEvolution {

    @objc(addEvolvesFromObject:)
    @NSManaged public func addToEvolvesFrom(_ value: CoreDataPokemonEvolution)

    @objc(removeEvolvesFromObject:)
    @NSManaged public func removeFromEvolvesFrom(_ value: CoreDataPokemonEvolution)

    @objc(addEvolvesFrom:)
    @NSManaged public func addToEvolvesFrom(_ values: NSSet)

    @objc(removeEvolvesFrom:)
    @NSManaged public func removeFromEvolvesFrom(_ values: NSSet)

}

extension CoreDataPokemonEvolution : Identifiable {

}
