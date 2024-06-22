//
//  PokemonStoreServiceProtocol.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

protocol PokemonStoreServiceProtocol {
    func fetchPokemonDisplayList(offset: Int, limit: Int, completion: ((Result<[PokemonDisplay], Error>) -> Void)?)
    func fetchPokemonDisplay(_ pokemonDisplay: PokemonDisplay, completion: ((Result<PokemonDisplay, Error>) -> Void)?)
    func addPokemonDisplay(_ pokemonDisplay: PokemonDisplay, completion: ((Result<Void, Error>) -> Void)?)
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay, completion: ((Result<Void, Error>) -> Void)?)
    func saveChanges(completion: ((Result<Void, Error>) -> Void)?)
}
