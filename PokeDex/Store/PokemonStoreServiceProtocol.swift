//
//  PokemonStoreServiceProtocol.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

protocol PokemonStoreServiceProtocol {
    associatedtype T
    associatedtype U
    associatedtype V
    
    func fetchPokemonDisplayList() throws -> [PokemonDisplay]
    func fetchPokemonDisplay(speciesID: Int) throws -> PokemonDisplay?
    @discardableResult
    func addPokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> T
    @discardableResult
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws -> T
    
    @discardableResult
    func addPokemonEvolutionChain(_ evolutionChain: PokemonEvolutionChain) throws -> U
    
    @discardableResult
    func addPokemonFlavorText(_ flavorText: PokemonFlavorText, speciesID: Int) throws -> V
}

enum PokemonStoreError: Error {
    case pokemonDisplayNotFound
    case alreadyExists
}
