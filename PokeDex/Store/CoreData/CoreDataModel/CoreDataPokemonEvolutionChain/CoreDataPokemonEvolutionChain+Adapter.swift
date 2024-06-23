//
//  CoreDataPokemonEvolutionChain+Adapter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

extension CoreDataPokemonEvolutionChain {
    func toPokemonEvolutionChain() -> PokemonEvolutionChain? {
        guard let coreDataEvolvesTo = evolvesTo else {
            return nil
        }
        return PokemonEvolutionChain(id: Int(id), evolvesTo: coreDataEvolvesTo.toPokemonEvolution())
    }
}
