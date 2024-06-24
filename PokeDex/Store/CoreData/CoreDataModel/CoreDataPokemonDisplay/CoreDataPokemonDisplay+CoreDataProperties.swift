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
    @NSManaged public var flavorText: CoreDataPokemonFlavorText?

}

extension CoreDataPokemonDisplay : Identifiable {

}

extension CoreDataPokemonDisplay {
    @nonobjc public class func fetchRequest(offset: Int, limit: Int) -> NSFetchRequest<CoreDataPokemonDisplay> {
        let request = NSFetchRequest<CoreDataPokemonDisplay>(entityName: "CoreDataPokemonDisplay")
        request.sortDescriptors = [NSSortDescriptor(key: "speciesID", ascending: true)]
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        return request
    }
}

