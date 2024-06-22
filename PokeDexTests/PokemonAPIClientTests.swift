//
//  PokemonAPIClientTests.swift
//  PokeDexTests
//
//  Created by Bo Chiu on 2024/6/22.
//

import XCTest
@testable import PokeDex

final class PokemonAPIClientTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testAPIDTOMapping() async throws {
        let response = await PokemonAPIClient.fetchRoughPokemons(offset: 1025, limit: 277)
        XCTAssertNotNil(response)
        XCTAssertTrue(response!.results.count == 277)
        
        
        for result in response!.results {
            XCTAssertTrue(result.id != 0)
            let detail = await PokemonAPIClient.fetchPokemonDetail(id: result.id)
            XCTAssertNotNil(detail)
            let species = await PokemonAPIClient.fetchPokemonSpecies(url: detail!.species.url)
            XCTAssertNotNil(species)
            let evolutionChain = await PokemonAPIClient.pokemonEvolutionChain(url: species!.evolutionChainURL)
            XCTAssertNotNil(evolutionChain)
        }
    }
    
    func testFetchNextRoughPokemons() async throws {
        let response = await PokemonAPIClient.fetchNextRoughPokemons()
        XCTAssertNotNil(response)
        XCTAssertTrue(response!.results.count == 20)
        var results = response!.results
        while PokemonAPIClient.next != nil {
            let nextResponse = await PokemonAPIClient.fetchNextRoughPokemons()
            XCTAssertNotNil(nextResponse)
            results.append(contentsOf: nextResponse!.results)
        }
        XCTAssertTrue(results.count == response!.count)
    }

}
