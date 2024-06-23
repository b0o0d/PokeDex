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
    
    private func addCoreDataPokemonDisplay(_ pokemonDisplay: PokemonDisplay) async throws -> CoreDataPokemonDisplay {
        do {
            return try await coreDataStack.persistentContainer.performBackgroundTask { context in
                let added = try CoreDataPokemonDisplay.findOrCreatePokemonDisplay(matching: pokemonDisplay, in: context)
                try context.save()
                return added
            }
        } catch {
            throw error
        }
        
    }
    
    private func updateCoreDataPokemonDisplay(_ pokemonDisplay: PokemonDisplay) async throws -> CoreDataPokemonDisplay {
        do {
            return try await coreDataStack.persistentContainer.performBackgroundTask { context in
                let updated = try CoreDataPokemonDisplay.findOrCreatePokemonDisplay(matching: pokemonDisplay, in: context)
                updated.image = pokemonDisplay.image
                updated.isFavorite = pokemonDisplay.isFavorite
                try context.save()
                return updated
            }
        } catch {
            throw error
        }
    }
}

extension PokemonCoreDataStoreService: PokemonStoreServiceProtocol {
    typealias T = CoreDataPokemonDisplay
    
    func fetchPokemonDisplayList(offset: Int, limit: Int) throws -> [PokemonDisplay] {
        return try fetchCoreDataPokemonDisplayList(offset: offset, limit: limit).compactMap { $0.toPokemonDisplay() }
    }
    
    func addPokemonDisplay(_ pokemonDisplay: PokemonDisplay) async throws -> CoreDataPokemonDisplay {
        do {
            let expectNil = try fetchCoreDataPokemonDisplay(pokemonDisplay)
            guard expectNil == nil else {
                throw PokemonStoreError.alreadyExists
            }
        } catch {
            throw error
        }
        return try await addCoreDataPokemonDisplay(pokemonDisplay)
    }
    
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) async throws -> CoreDataPokemonDisplay {
        do {
            let expectNonNil = try fetchCoreDataPokemonDisplay(pokemonDisplay)
            guard expectNonNil != nil else {
                throw PokemonStoreError.pokemonDisplayNotFound
            }
        } catch {
            throw error
        }
        return try await updateCoreDataPokemonDisplay(pokemonDisplay)
    }
}
