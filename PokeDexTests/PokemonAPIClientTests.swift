//
//  PokemonAPIClientTests.swift
//  PokeDexTests
//
//  Created by Bo Chiu on 2024/6/22.
//

import XCTest
@testable import PokeDex

final class PokemonAPIClientTests: XCTestCase {
    func testAPIDTOMapping() async throws {
        let sut = PokemonAPIClient()
        
        let response = await sut.fetchRoughPokemons(offset: 1025, limit: 277)
        XCTAssertNotNil(response)
        XCTAssertTrue(response!.results.count == 277)
        
        
        for result in response!.results {
            XCTAssertTrue(result.id != 0)
            let detail = await sut.fetchPokemonDetail(id: result.id)
            XCTAssertNotNil(detail)
            let species = await sut.fetchPokemonSpecies(url: detail!.species.url)
            XCTAssertNotNil(species)
            let evolutionChain = await sut.pokemonEvolutionChain(url: species!.evolutionChainURL)
            XCTAssertNotNil(evolutionChain)
        }
    }
    
    func testFetchNextRoughPokemons() async throws {
        let sut = PokemonAPIClient()
        
        let response = await sut.fetchNextRoughPokemons()
        XCTAssertNotNil(response)
        XCTAssertTrue(response!.results.count == 20)
        var results = response!.results
        while sut.next != nil {
            let nextResponse = await sut.fetchNextRoughPokemons()
            XCTAssertNotNil(nextResponse)
            results.append(contentsOf: nextResponse!.results)
        }
        XCTAssertTrue(results.count == response!.count)
    }

}
