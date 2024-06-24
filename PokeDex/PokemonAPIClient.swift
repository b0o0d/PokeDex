//
//  PokemonAPIClient.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/22.
//

import Foundation
import Alamofire

class PokemonAPIClient {
    private(set) var next: String?
    
    func fetchRoughPokemons(offset: Int, limit: Int = 20) async -> PokemonRoughResponse? {
        let url = "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        let value = try? await AF.request(url).serializingDecodable(PokemonRoughResponse.self).value
        if let value = value {
            next = value.next
            return value
        }
        return nil
    }
    
    func fetchNextRoughPokemons() async -> PokemonRoughResponse? {
        guard let next = next else {
            return await fetchRoughPokemons(offset: 0)
        }
        let value = try? await AF.request(next).serializingDecodable(PokemonRoughResponse.self).value
        
        self.next = value?.next
        return value
    }
    
    func fetchPokemonDetail(id: Int) async -> PokemonDetail? {
        let url = "https://pokeapi.co/api/v2/pokemon/\(id)"
        let value = try? await AF.request(url).serializingDecodable(PokemonDetail.self).value
        return value
    }
    
    // 不能 by id, 因為有些 Pokemon 對 species 的請求和 PokemonGeneralResult.id 不同
    // 因此必須改為同步在 fetchPokemonDetail 後才能請求
    func fetchPokemonSpecies(url: String) async -> PokemonSpecies? {
        let value = try? await AF.request(url).serializingDecodable(PokemonSpecies.self).value
        return value
    }
    
    func pokemonEvolutionChain(url: String) async -> PokemonEvolutionChain? {
        let value = try? await AF.request(url).serializingDecodable(PokemonEvolutionChain.self).value
        return value
    }

}
