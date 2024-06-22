//
//  CoreDataPokemonDisplay+CoreDataProperties.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData


extension CoreDataPokemonDisplay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPokemonDisplay> {
        return NSFetchRequest<CoreDataPokemonDisplay>(entityName: "CoreDataPokemonDisplay")
    }

    @NSManaged public var image: Data?
    @NSManaged public var imageURL: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var speciesID: Int32
    @NSManaged public var types: [String]?
    @NSManaged public var evolutionChain: CoreDataPokemonEvolutionChain?
    @NSManaged public var flavorTextEntries: NSSet?

}

// MARK: Generated accessors for flavorTextEntries
extension CoreDataPokemonDisplay {

    @objc(addFlavorTextEntriesObject:)
    @NSManaged public func addToFlavorTextEntries(_ value: CoreDataPokemonFlavorText)

    @objc(removeFlavorTextEntriesObject:)
    @NSManaged public func removeFromFlavorTextEntries(_ value: CoreDataPokemonFlavorText)

    @objc(addFlavorTextEntries:)
    @NSManaged public func addToFlavorTextEntries(_ values: NSSet)

    @objc(removeFlavorTextEntries:)
    @NSManaged public func removeFromFlavorTextEntries(_ values: NSSet)

}

extension CoreDataPokemonDisplay : Identifiable {

}
