//
//  PokemonCoreDataStoreServiceTests.swift
//  PokeDexTests
//
//  Created by Bo Chiu on 2024/6/23.
//

import XCTest
@testable import PokeDex

final class PokemonCoreDataStoreServiceTests: XCTestCase {
    var sut: PokemonCoreDataStoreService?

    override func setUpWithError() throws {
        try super.setUpWithError()
        let inMemory = CoreDataStack(inMemory: true)
        sut = PokemonCoreDataStoreService(coreDataStack: inMemory)
        try sut?.deleteAll()
        sut?.saveContext()
    }

    override func tearDownWithError() throws {
        try sut?.deleteAll()
        sut?.saveContext()
        sut = nil
        print("tear down")
        try super.tearDownWithError()
    }

    func testCoreDataAddFetch() async throws {
        let offset = 1024
        let limit = 278
        let response = await PokemonAPIClient.fetchRoughPokemons(offset: offset, limit: limit)
        XCTAssertNotNil(response)
        XCTAssertTrue(response!.results.count == limit)
        
        var addeds: [CoreDataPokemonDisplay] = []
        for result in response!.results {
            XCTAssertTrue(result.id != 0)
            let detail = await PokemonAPIClient.fetchPokemonDetail(id: result.id)
            XCTAssertNotNil(detail)
            let species = await PokemonAPIClient.fetchPokemonSpecies(url: detail!.species.url)
            XCTAssertNotNil(species)
            let enLastFlavorText = species?.flavorTextEntries.last { $0.language == "en" }
            XCTAssertNotNil(enLastFlavorText)
            try? sut?.addPokemonFlavorText(enLastFlavorText!, speciesID: detail!.species.id)
            let evolutionChain = await PokemonAPIClient.pokemonEvolutionChain(url: species!.evolutionChainURL)
            XCTAssertNotNil(evolutionChain)
            try? sut?.addPokemonEvolutionChain(evolutionChain!)
            sut?.saveContext()
            
            let display: PokemonDisplay? = PokemonDisplayAdapter.adapt(pokemonDetail: detail!, pokemonEvolutionChain: evolutionChain!, pokemonSpecies: species!)
            XCTAssertNotNil(display)
            let added = try? sut?.addPokemonDisplay(display!)
            if let added = added {
                addeds.append(added)
            }
        }
        sut?.saveContext()
        for added in addeds {
            let display = added.toPokemonDisplay()
            XCTAssertNotNil(display)
            XCTAssertNotNil(display?.coreDataObjectID)
        }
        
        let fetched = try sut?.fetchPokemonDisplayList(offset: 0, limit: 10000)
        XCTAssertNotNil(fetched)
        XCTAssertTrue(fetched!.count <= limit)
    }

}

