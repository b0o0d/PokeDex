//
//  PokemonCoreDataStoreService.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

class PokemonCoreDataStoreService {
    private let coreDataStack = CoreDataStack.shared
    
    private func fetchCoreDataPokemonDisplayList(offset: Int, limit: Int) throws -> [CoreDataPokemonDisplay] {
        let fetchRequest = CoreDataPokemonDisplay.fetchRequest(offset: offset, limit: limit)
        return try coreDataStack.viewContext.fetch(fetchRequest)
    }
    
    private func fetchCoreDataPokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> CoreDataPokemonDisplay? {
        let fetchRequest = CoreDataPokemonDisplay.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "speciesID == %d", pokemonDisplay.speciesID)
        fetchRequest.fetchLimit = 1
        return try coreDataStack.viewContext.fetch(fetchRequest).first
    }
    
    private func fetchCoreDataPokemonEvolutionChain(_ evolutionChain: PokemonEvolutionChain) throws -> CoreDataPokemonEvolutionChain? {
        let fetchRequest = CoreDataPokemonEvolutionChain.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", evolutionChain.id)
        fetchRequest.fetchLimit = 1
        return try coreDataStack.viewContext.fetch(fetchRequest).first
    }
    
    private func fetchCoreDataPokemonFlavorText(_ flavorText: PokemonFlavorText, speciesID: Int) throws -> CoreDataPokemonFlavorText? {
        let fetchRequest = CoreDataPokemonFlavorText.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "speciesID == %d && language == %@ AND version == %@", speciesID, flavorText.language, flavorText.version)
        return try coreDataStack.viewContext.fetch(fetchRequest).first
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
    }
}

extension PokemonCoreDataStoreService: PokemonStoreServiceProtocol {
    typealias T = CoreDataPokemonDisplay
    typealias U = CoreDataPokemonEvolutionChain
    typealias V = CoreDataPokemonFlavorText
    
    func fetchPokemonDisplayList(offset: Int, limit: Int) throws -> [PokemonDisplay] {
        return try fetchCoreDataPokemonDisplayList(offset: offset, limit: limit).compactMap { $0.toPokemonDisplay() }
    }
    
    func addPokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> CoreDataPokemonDisplay {
        do {
            let expectNil = try fetchCoreDataPokemonDisplay(pokemonDisplay)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
        } catch {
            throw error
        }
        
        return CoreDataPokemonDisplay.instance(pokemonDisplay: pokemonDisplay, context: coreDataStack.viewContext)
    }
    
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> CoreDataPokemonDisplay {
        do {
            let expectNotNil = try fetchCoreDataPokemonDisplay(pokemonDisplay)
            guard let expectNotNil = expectNotNil else {
                throw PokemonStoreError.pokemonDisplayNotFound
            }
            expectNotNil.image = pokemonDisplay.image
            expectNotNil.isFavorite = pokemonDisplay.isFavorite
            
            return expectNotNil
        } catch {
            throw error
        }
    }
    
    func addPokemonEvolutionChain(_ evolutionChain: PokemonEvolutionChain) throws -> CoreDataPokemonEvolutionChain {
        do {
            let expectNil = try fetchCoreDataPokemonEvolutionChain(evolutionChain)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
        } catch {
            throw error
        }
        
        return CoreDataPokemonEvolutionChain.instance(pokemonEvolutionChain: evolutionChain, context: coreDataStack.viewContext)
    }
    
    func addPokemonFlavorText(_ flavorText: PokemonFlavorText, speciesID: Int) throws -> CoreDataPokemonFlavorText {
        do {
            let expectNil = try fetchCoreDataPokemonFlavorText(flavorText, speciesID: speciesID)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
        } catch {
            throw error
        }
        
        return CoreDataPokemonFlavorText.instance(speciesID: speciesID, pokemonFlavorText: flavorText, context: coreDataStack.viewContext)
    }
    
    func saveContext() {
        coreDataStack.saveContext()
    }
}
