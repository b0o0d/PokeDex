//
//  PokemonRepositoryTests.swift
//  PokeDexTests
//
//  Created by Bo Chiu on 2024/6/24.
//

import XCTest
@testable import PokeDex

final class PokemonRepositoryTests: XCTestCase {
    func testRepository() async throws {
        let inMemory = CoreDataStack(inMemory: true)
        let store = PokemonCoreDataStoreService(coreDataStack: inMemory)
        let apiClient = PokemonAPIClient()
        let sut = PokemonRepository(storeService: store, apiClient: apiClient)
        
        let expectation = XCTestExpectation(description: "Load Pokemon Display List")
        
        var times = 5
        var count = sut.displayables.count
        
        let oriTimes = times
        let oriCount = count
        
        while times > 0 {
            try await sut.loadPokemonDisplayList()
            times -= 1
            XCTAssert(sut.displayables.count == count + sut.defaultLimit)
            count = sut.displayables.count
        }
        XCTAssert(sut.displayables.count == oriCount + sut.defaultLimit * oriTimes)
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10)
    }
}
