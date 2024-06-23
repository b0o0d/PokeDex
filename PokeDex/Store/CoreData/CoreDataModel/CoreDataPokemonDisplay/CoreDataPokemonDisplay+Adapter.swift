//
//  CoreDataPokemonDisplay+Adapter.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/23.
//

import Foundation

extension CoreDataPokemonDisplay {
    func toPokemonDisplay() -> PokemonDisplay? {
        guard
            let coreDataEvolutionChain = evolutionChain,
            let evolutionChain = coreDataEvolutionChain.toPokemonEvolutionChain(),
            let coreDataPokemonFlavorTextSet = flavorTextEntries as? Set<CoreDataPokemonFlavorText>
        else {
            return nil
        }
        
        let flavorTextEntries = coreDataPokemonFlavorTextSet.toPokemonFlavorTexts()
        
        return PokemonDisplay(speciesID: Int(speciesID),
                              name: name ?? "",
                              types: types ?? [],
                              imageURL: imageURL,
                              image: image,
                              evolutionChain: evolutionChain,
                              flavorTextEntries: flavorTextEntries,
                              isFavorite: isFavorite,
                              coreDataObjectID: objectID.isTemporaryID ? nil : objectID
        )
    }
}
