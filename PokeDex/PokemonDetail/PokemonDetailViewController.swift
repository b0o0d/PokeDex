//
//  PokemonDetailViewController.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit
import SnapKit
import DequeModule

class PokemonDetailViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var pokemonIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var typesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var evolutionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        return button
    }()
    
    private let presenter: PokemonDetailPresenter
    
    init(presenter: PokemonDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupLayout()
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    deinit {
        presenter.finish()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(pokemonIDLabel)
        contentView.addSubview(pokemonNameLabel)
        contentView.addSubview(typesStackView)
        contentView.addSubview(imageView)
        contentView.addSubview(evolutionsStackView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(favoriteButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        pokemonIDLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(contentView.snp.top).offset(16)
        }
        
        pokemonNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonIDLabel.snp.trailing).offset(16)
            make.top.equalTo(pokemonIDLabel)
        }
        
        typesStackView.snp.makeConstraints { make in
            make.leading.equalTo(pokemonIDLabel)
            make.top.equalTo(pokemonNameLabel.snp.bottom).offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(pokemonIDLabel.snp.bottom).offset(16)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        evolutionsStackView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(16)
        }
    }
    
    func config() {
        pokemonIDLabel.text = "ID: \(presenter.pokemon.speciesID)"
        pokemonNameLabel.text = presenter.pokemon.name
        if let image = presenter.pokemon.image {
            imageView.image = UIImage(data: image)
        }
        updateDescriptionTextViewHeight(text: presenter.pokemon.flavorText.flavorText)
        
        for type in presenter.pokemon.types {
            let typeLabel = UILabel()
            typeLabel.text = type
            typesStackView.addArrangedSubview(typeLabel)
        }
        
        favoriteButton.isSelected = presenter.pokemon.isFavorite
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        let (isNeeded, id) = isNeededToFetchEvolutionDisplay(presenter.pokemon.evolutionChain)
        if isNeeded {
            Task.detached { [weak self] in
                do {
                    try await self?.presenter.fetchUntilSpeciesID(id)
                    await MainActor.run { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.drawEvolutionChain(self.presenter.pokemon.evolutionChain)
                    }
                } catch {
                    print(error)
                }
            }
        } else {
            drawEvolutionChain(presenter.pokemon.evolutionChain)
        }
    }
    
    private func isNeededToFetchEvolutionDisplay(_ evolutionChain: PokemonEvolutionChain) -> (Bool, Int) {
        var queue: Deque<PokemonEvolution> = [evolutionChain.evolvesTo]
        // find the max speciesID
        var maxSpeciesID = evolutionChain.evolvesTo.speciesID
        while queue.count > 0 {
            var count = queue.count
            while count > 0 {
                count -= 1
                guard let evolution = queue.popFirst() else {
                    continue
                }
                maxSpeciesID = max(maxSpeciesID, evolution.speciesID)
                for evo in evolution.evolvesTo {
                    queue.append(evo)
                }
            }
        }
        
        return (maxSpeciesID > presenter.maxSpeciesID, maxSpeciesID)
    }
    
    @MainActor
    private func drawEvolutionChain(_ evolutionChain: PokemonEvolutionChain) {
        evolutionsStackView.removeAllArrangedSubviews()
        
        // draw
        var queue: Deque<PokemonEvolution> = [evolutionChain.evolvesTo]
        while queue.count > 0 {
            var count = queue.count
            let vStackView = UIStackView()
            vStackView.axis = .vertical
            vStackView.distribution = .fillEqually
            while count > 0 {
                count -= 1
                guard let evolution = queue.popFirst() else {
                    continue
                }
                for evo in evolution.evolvesTo {
                    queue.append(evo)
                }
                let button = UIButton()
                button.tag = evolution.speciesID
                button.addTarget(self, action: #selector(pushToPokemonDetail(_:)), for: .touchUpInside)
                button.layer.borderColor = UIColor.gray.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 8
                button.clipsToBounds = true
                if let pokemon = presenter.evolutionPokemonDisplay(for: evolution.speciesID) {
                    if let imageData = pokemon.image {
                        button.setImage(UIImage(data: imageData), for: .normal)
                    } else if let imageURL = pokemon.imageURL {
                        button.sd_setImage(with: URL(string: imageURL), for: .normal) { [weak self] image, error, cacheType, url in
                            guard let url = url, let image = image else {
                                return
                            }
                            Task { [weak self] in
                                try? self?.presenter.updatePokemon(imageURLStr:url.absoluteString, image:image)
                            }
                        }
                    } else {
                        button.setTitle(pokemon.name, for: .normal)
                    }
                } else {
                    // handle disconuntinuous evolution chain
                    button.setTitle("\(evolution.speciesID)", for: .normal)
                }
                vStackView.addArrangedSubview(button)
            }
            if vStackView.arrangedSubviews.count > 0 {
                evolutionsStackView.addArrangedSubview(vStackView)
            }
        }
    }
    
    private func updateDescriptionTextViewHeight(text: String) {
        let finalText = text.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: " ")
        descriptionTextView.text = finalText
        descriptionTextView.sizeToFit()
    }
    
    @objc func pushToPokemonDetail(_ sender: UIButton) {
        guard sender.tag != presenter.pokemon.speciesID else {
            return
        }
        presenter.pushToPokemonDetail(for: sender.tag)
    }
    
    @objc func favoriteButtonTapped() {
        presenter.toggleFavorite()
        favoriteButton.isSelected.toggle()
    }
}
