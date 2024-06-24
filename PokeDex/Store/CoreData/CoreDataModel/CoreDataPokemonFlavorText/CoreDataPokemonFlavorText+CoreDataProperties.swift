//
//  CoreDataPokemonFlavorText+CoreDataProperties.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//
//

import Foundation
import CoreData


extension CoreDataPokemonFlavorText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataPokemonFlavorText> {
        return NSFetchRequest<CoreDataPokemonFlavorText>(entityName: "CoreDataPokemonFlavorText")
    }

    @NSManaged public var flavorText: Data?
    @NSManaged public var language: String?
    @NSManaged public var speciesID: Int32
    @NSManaged public var version: String?

}

extension CoreDataPokemonFlavorText : Identifiable {

}
