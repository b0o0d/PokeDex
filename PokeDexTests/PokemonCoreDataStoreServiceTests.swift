//
//  PokemonCoreDataStoreServiceTests.swift
//  PokeDexTests
//
//  Created by Bo Chiu on 2024/6/23.
//

import XCTest
@testable import PokeDex

final class PokemonCoreDataStoreServiceTests: XCTestCase {
    func testCoreDataAddFetch() async throws {
        let apiClient = PokemonAPIClient()
        let inMemory = CoreDataStack(inMemory: true)
        let sut = PokemonCoreDataStoreService(coreDataStack: inMemory)
        try sut.deleteAll()
        
        let offset = 0
        let limit = 1302
        let response = await apiClient.fetchRoughPokemons(offset: offset, limit: limit)
        XCTAssertNotNil(response)
        XCTAssertTrue(response!.results.count == limit)
        
        let addeds = await withTaskGroup(of: CoreDataPokemonDisplay?.self) { group in
            for result in response!.results {
                group.addTask {
                    XCTAssertTrue(result.id != 0)
                    let detail = await apiClient.fetchPokemonDetail(id: result.id)
                    XCTAssertNotNil(detail)
                    let species = await apiClient.fetchPokemonSpecies(url: detail!.species.url)
                    XCTAssertNotNil(species)
                    let enLastFlavorText = species?.flavorTextEntries.last { $0.language == "en" }
                    XCTAssertNotNil(enLastFlavorText)
                    try? sut.addPokemonFlavorText(enLastFlavorText!, speciesID: detail!.species.id)
                    let evolutionChain = await apiClient.pokemonEvolutionChain(url: species!.evolutionChainURL)
                    XCTAssertNotNil(evolutionChain)
                    try? sut.addPokemonEvolutionChain(evolutionChain!)
                    
                    let display: PokemonDisplay? = PokemonDisplayAdapter.adapt(pokemonDetail: detail!, pokemonEvolutionChain: evolutionChain!, flavorText: enLastFlavorText!)
                    XCTAssertNotNil(display)
                    let added = try? sut.addPokemonDisplay(display!)
                    return added
                }
            }
            
            var rets: [CoreDataPokemonDisplay] = []
            while let next = await group.next() {
                if let next = next {
                    rets.append(next)
                }
            }
            
            return rets
        }
        XCTAssert(addeds.count == 1025)
    }

}

