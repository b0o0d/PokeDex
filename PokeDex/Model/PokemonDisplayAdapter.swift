//
//  PokemonDisplayAdapter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/22.
//

import Foundation

class PokemonDisplayAdapter {
    static func adapt(pokemonDetail: PokemonDetail,
                      pokemonEvolutionChain: PokemonEvolutionChain,
                      flavorText: PokemonFlavorText
                ) -> PokemonDisplay {
        return PokemonDisplay(speciesID: pokemonDetail.species.id,
                              name: pokemonDetail.species.name,
                              types: pokemonDetail.types,
                              imageURL: pokemonDetail.image,
                              evolutionChain: pokemonEvolutionChain,
                              flavorText: flavorText
                )
    }
}
