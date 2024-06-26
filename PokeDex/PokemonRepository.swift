//
//  PokemonRepository.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/24.
//

import Foundation

protocol PokemonRepositoryProtocol {
    var offset: Int { get set }
    var limit: Int { get }
    var storeService: any PokemonStoreServiceProtocol { get }
    var apiClient: PokemonAPIClient { get }
    var displayables: [any PokemonDisplayable] { get set }
    var delegate: PokemonRepositoryDelegate? { get set }
    
    func loadPokemonDisplayList() async throws
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws
    func sync() throws
}

protocol PokemonRepositoryDelegate: AnyObject {
    func didUpdateList()
}

class PokemonRepository: PokemonRepositoryProtocol {
    var offset: Int = 0
    let limit: Int = 20
    var storeService: any PokemonStoreServiceProtocol
    var apiClient: PokemonAPIClient
    var displayables: [any PokemonDisplayable] {
        get {
            rwQueue.sync { [weak self] in
                return self?._displayables ?? []
            }
        }
        set {
            rwQueue.async(flags: .barrier) { [weak self] in
                guard let self = self else {
                    return
                }
                let appendMax = newValue.suffix(self.limit)
                for displayable in appendMax {
                    guard let display = displayable as? PokemonDisplay, (display.coreDataObjectID == nil || !display.coreDataObjectID!.isTemporaryID) else {
                        continue
                    }
                    try? self.storeService.addPokemonDisplay(display)
                }
                self._displayables = newValue
            }
        }
    }
    
    private var _displayables: [any PokemonDisplayable] = []
    private var rwQueue = DispatchQueue(label: "PokemonRepository")
    
    weak var delegate: PokemonRepositoryDelegate?
    
    init(storeService: any PokemonStoreServiceProtocol, apiClient: PokemonAPIClient) {
        self.storeService = storeService
        self.apiClient = apiClient
        
        try? loadLocal()
    }
    
    private func loadLocal() throws {
        let pokemonDisplays = try self.storeService.fetchPokemonDisplayList()
        self.displayables = pokemonDisplays
        offset = pokemonDisplays.count
    }
    
    private func checkAppendable(pokemonDisplay: any PokemonDisplayable) -> Bool {
        guard let lastPokemonDisplay = displayables.last else {
            return true
        }
        return pokemonDisplay.speciesID > lastPokemonDisplay.speciesID
    }
    
    func loadPokemonDisplayList() async throws {
        let roughResponse = await self.apiClient.fetchRoughPokemons(offset: self.offset, limit: self.limit)
        guard let roughResponse = roughResponse else {
            return
        }
        
        let pokemons = roughResponse.results
        let pokemonDisplays = await withTaskGroup(of: PokemonDisplay?.self) { group in
            for pokemon in pokemons {
                group.addTask {
                    let species = await self.apiClient.fetchPokemonSpecies(id: pokemon.id)
                    guard let species = species else {
                        return nil
                    }
                    
                    let pokemonDetail = await self.apiClient.fetchPokemonDetail(id: species.pokemonRequestID)
                    guard let pokemonDetail = pokemonDetail else {
                        return nil
                    }
                    
                    let evolutionChain = await self.apiClient.pokemonEvolutionChain(url: species.evolutionChainURL)
                    guard let evolutionChain = evolutionChain else {
                        return nil
                    }
                    try? self.storeService.addPokemonEvolutionChain(evolutionChain)
                    
                    let flavorText = species.flavorTextEntries.last(where: { $0.language == "en" })
                    guard let flavorText = flavorText else {
                        return nil
                    }
                    try? self.storeService.addPokemonFlavorText(flavorText, speciesID: pokemonDetail.species.id)
                    
                    let pokemonDisplay = PokemonDisplayAdapter.adapt(
                        pokemonDetail: pokemonDetail,
                        pokemonEvolutionChain: evolutionChain,
                        flavorText: flavorText
                    )
                    return pokemonDisplay
                }
            }
            var rets: [PokemonDisplay] = []
            while let pokemonDisplay = await group.next() {
                guard let pokemonDisplay = pokemonDisplay else {
                    continue
                }
                rets.append(pokemonDisplay)
            }
            rets.sort { $0.speciesID < $1.speciesID }
            return rets
        }
        
        let appendables = pokemonDisplays.filter { self.checkAppendable(pokemonDisplay: $0) }
        if !appendables.isEmpty {
            self.displayables.append(contentsOf: appendables)
            self.offset += self.limit
        }
        self.delegate?.didUpdateList()
    }
    
    func updatePokemonDisplay(_ pokemonDisplay: PokemonDisplay) throws {
        try storeService.updatePokemonDisplay(pokemonDisplay)
    }
    
    func sync() throws {
        let localDisplays = try storeService.fetchPokemonDisplayList()
        var i = 0
        var j = 0
        while i < displayables.count && j < localDisplays.count {
            guard let display = displayables[i] as? PokemonDisplay else {
                i += 1
                continue
            }
            let localDisplay = localDisplays[j]
            if display.speciesID == localDisplay.speciesID {
                if display.isFavorite != localDisplay.isFavorite {
                    display.isFavorite = localDisplay.isFavorite
                }
                i += 1
                j += 1
            } else if display.speciesID < localDisplay.speciesID {
                i += 1
            } else {
                j += 1
            }
            
        }
    }
}

