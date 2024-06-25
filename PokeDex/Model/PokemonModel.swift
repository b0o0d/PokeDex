//
//  PokemonModel.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/22.
//

import Foundation

struct PokemonRoughResponse: Decodable {
    let count: Int
    let next: String?
    let results: [PokemonGeneralResult]
}

struct PokemonGeneralResult: Decodable {
    let name: String
    let url: String
}

extension PokemonGeneralResult {
    var id: Int {
        guard let id = URL(string: url)?.lastPathComponent else {
            return 0
        }
        return Int(id) ?? 0
    }
}

struct PokemonDetail: Decodable {
    let species: PokemonGeneralResult
    // FIXME: 有些 Pokemon->sprites->front_default 是 null
    let image: String?
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case species
        case sprites
        case types
    }
    
    enum SpritesCodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let sprites = try container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        image = try? sprites.decode(String.self, forKey: .frontDefault)
        
        types = try container.decode([PokemonType].self, forKey: .types).map { $0.type.name }
        
        species = try container.decode(PokemonGeneralResult.self, forKey: .species)
    }
}

struct PokemonType: Decodable {
    let slot: Int
    let type: PokemonGeneralResult
}

struct PokemonSpecies: Decodable {
    let evolutionChainURL: String
    let flavorTextEntries: [PokemonFlavorText]
    
    enum CodingKeys: String, CodingKey {
        case evolutionChainURL = "evolution_chain"
        case flavorTextEntries = "flavor_text_entries"
    }
    
    enum EvolutionChainCodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let evolutionChain = try container.nestedContainer(keyedBy: EvolutionChainCodingKeys.self, forKey: .evolutionChainURL)
        evolutionChainURL = try evolutionChain.decode(String.self, forKey: .url)
        
        flavorTextEntries = try container.decode([PokemonFlavorText].self, forKey: .flavorTextEntries)
    }
}

struct PokemonFlavorText: Decodable {
    let flavorText: String
    let language: String
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
    
    enum LanguageCodingKeys: String, CodingKey {
        case name
    }
    
    enum VersionCodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        flavorText = try container.decode(String.self, forKey: .flavorText)
        
        let language = try container.nestedContainer(keyedBy: LanguageCodingKeys.self, forKey: .language)
        self.language = try language.decode(String.self, forKey: .name)
        
        let version = try container.nestedContainer(keyedBy: VersionCodingKeys.self, forKey: .version)
        self.version = try version.decode(String.self, forKey: .name)
    }
    
    init(flavorText: String, language: String, version: String) {
        self.flavorText = flavorText
        self.language = language
        self.version = version
    }

}

struct PokemonEvolutionChain: Decodable {
    let id: Int
    let evolvesTo: PokemonEvolution
    
    enum CodingKeys: String, CodingKey {
        case id
        case evolvesTo = "chain"
    }
}

struct PokemonEvolution: Decodable {
    let speciesID: Int
    let evolvesTo: [PokemonEvolution]
    
    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let species = try container.decode(PokemonGeneralResult.self, forKey: .species)
        speciesID = species.id
        
        evolvesTo = try container.decode([PokemonEvolution].self, forKey: .evolvesTo)
    }
    
    init(speciesID: Int, evolvesTo: [PokemonEvolution]) {
        self.speciesID = speciesID
        self.evolvesTo = evolvesTo
    }

}
