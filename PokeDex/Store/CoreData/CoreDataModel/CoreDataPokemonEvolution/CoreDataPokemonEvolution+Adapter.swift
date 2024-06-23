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
            return PokemonEvolution(speciesName: speciesName ?? "", evolvesTo: [])
        }
        var evolvesToArray: [PokemonEvolution] = []
        for evolution in coreDataEvolvesTo {
            evolvesToArray.append(evolution.toPokemonEvolution())
        }
        return PokemonEvolution(speciesName: speciesName ?? "", evolvesTo: evolvesToArray)
    }
}
