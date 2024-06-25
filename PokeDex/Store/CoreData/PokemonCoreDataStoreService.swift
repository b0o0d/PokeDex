//
//  PokemonCoreDataStoreService.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation
import CoreData

class PokemonCoreDataStoreService {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    private func fetchCoreDataPokemonDisplayList(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) throws -> [CoreDataPokemonDisplay] {
        let fetchRequest = CoreDataPokemonDisplay.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    private func fetchCoreDataPokemonDisplay(_ pokemonDisplay: PokemonDisplay, context: NSManagedObjectContext) throws -> CoreDataPokemonDisplay? {
        try context.performAndWait {
            let fetchRequest = CoreDataPokemonDisplay.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "speciesID == %d", pokemonDisplay.speciesID)
            fetchRequest.fetchLimit = 1
            return try context.fetch(fetchRequest).first
        }
    }
    
    private func fetchCoreDataPokemonEvolutionChain(_ evolutionChain: PokemonEvolutionChain, context: NSManagedObjectContext) throws -> CoreDataPokemonEvolutionChain? {
        try context.performAndWait {
            let fetchRequest = CoreDataPokemonEvolutionChain.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", evolutionChain.id)
            fetchRequest.fetchLimit = 1
            return try context.fetch(fetchRequest).first
        }
    }
    
    private func fetchCoreDataPokemonFlavorText(_ flavorText: PokemonFlavorText, speciesID: Int, context: NSManagedObjectContext) throws -> CoreDataPokemonFlavorText? {
        try context.performAndWait {
            let fetchRequest = CoreDataPokemonFlavorText.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "speciesID == %d && language == %@ AND version == %@", speciesID, flavorText.language, flavorText.version)
            return try context.fetch(fetchRequest).first
        }
    }
    
    func deleteAll() throws {
        let fetchRequest = CoreDataPokemonDisplay.fetchRequest()
        let allPokemonDisplay = try coreDataStack.viewContext.fetch(fetchRequest)
        allPokemonDisplay.forEach { coreDataStack.viewContext.delete($0) }
        
        let fetchRequestEvolutionChain = CoreDataPokemonEvolutionChain.fetchRequest()
        let allPokemonEvolutionChain = try coreDataStack.viewContext.fetch(fetchRequestEvolutionChain)
        allPokemonEvolutionChain.forEach { coreDataStack.viewContext.delete($0) }
        
        let fetchRequestFlavorText = CoreDataPokemonFlavorText.fetchRequest()
        let allPokemonFlavorText = try coreDataStack.viewContext.fetch(fetchRequestFlavorText)
        allPokemonFlavorText.forEach { coreDataStack.viewContext.delete($0) }
        try coreDataStack.viewContext.save()
    }
}

extension PokemonCoreDataStoreService: PokemonStoreServiceProtocol {
    typealias T = CoreDataPokemonDisplay
    typealias U = CoreDataPokemonEvolutionChain
    typealias V = CoreDataPokemonFlavorText
    
    func fetchPokemonDisplayList() throws -> [PokemonDisplay] {
        return try fetchCoreDataPokemonDisplayList().compactMap { $0.toPokemonDisplay() }
    }
    
    @discardableResult
    func addPokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> CoreDataPokemonDisplay {
        let backgroundContext = coreDataStack.backgroundContext
        do {
            let expectNil = try fetchCoreDataPokemonDisplay(pokemonDisplay, context: backgroundContext)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
            let ret = CoreDataPokemonDisplay.instance(pokemonDisplay: pokemonDisplay, context: backgroundContext)
            try backgroundContext.save()
            return ret
        } catch {
            throw error
        }
    }
    
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> CoreDataPokemonDisplay {
        let backgroundContext = coreDataStack.backgroundContext
        do {
            let expectNotNil = try fetchCoreDataPokemonDisplay(pokemonDisplay, context: backgroundContext)
            guard let expectNotNil = expectNotNil else {
                throw PokemonStoreError.pokemonDisplayNotFound
            }
            expectNotNil.image = pokemonDisplay.image
            expectNotNil.isFavorite = pokemonDisplay.isFavorite
            try backgroundContext.save()
            return expectNotNil
        } catch {
            throw error
        }
    }
    
    func addPokemonEvolutionChain(_ evolutionChain: PokemonEvolutionChain) throws -> CoreDataPokemonEvolutionChain {
        let backgroundContext = coreDataStack.backgroundContext
        do {
            let expectNil = try fetchCoreDataPokemonEvolutionChain(evolutionChain, context: backgroundContext)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
            let ret = CoreDataPokemonEvolutionChain.instance(pokemonEvolutionChain: evolutionChain, context: backgroundContext)
            try backgroundContext.save()
            return ret
        } catch {
            throw error
        }
    }
    
    func addPokemonFlavorText(_ flavorText: PokemonFlavorText, speciesID: Int) throws -> CoreDataPokemonFlavorText {
        let backgroundContext = coreDataStack.backgroundContext
        do {
            let expectNil = try fetchCoreDataPokemonFlavorText(flavorText, speciesID: speciesID, context: backgroundContext)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
            let ret = CoreDataPokemonFlavorText.instance(speciesID: speciesID, pokemonFlavorText: flavorText, context: backgroundContext)
            try backgroundContext.save()
            return ret
        } catch {
            throw error
        }
    }
}
