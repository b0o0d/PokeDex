//
//  CoreDataPokemonEvolution+Adapter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

extension CoreDataPokemonEvolution {
    func toPokemonEvolution() -> PokemonEvolution {
        guard let coreDataEvolvesTo = evolvesTo as? Set<CoreDataPokemonEvolution>, coreDataEvolvesTo.count > 0 else {
            return PokemonEvolution(speciesID: Int(speciesID), evolvesTo: [])
        }
        let evolvesToArray = coreDataEvolvesTo.compactMap { $0.toPokemonEvolution() }
        
        return PokemonEvolution(speciesID: Int(speciesID), evolvesTo: evolvesToArray)
    }
}
