//
//  PokemonStoreServiceProtocol.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

protocol PokemonStoreServiceProtocol {
    associatedtype T
    
    func fetchPokemonDisplayList(offset: Int, limit: Int) throws -> [PokemonDisplay]
    func addPokemonDisplay(_ pokemonDisplay: PokemonDisplay) async throws -> T
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) async throws -> T
}

enum PokemonStoreError: Error {
    case pokemonDisplayNotFound
    case alreadyExists
}
