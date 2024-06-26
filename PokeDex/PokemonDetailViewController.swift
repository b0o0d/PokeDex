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
        config(with: presenter.pokemon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        presenter.finish()
    }
    
    private func setupLayout() {
        view.addSubview(pokemonIDLabel)
        view.addSubview(pokemonNameLabel)
        view.addSubview(typesStackView)
        view.addSubview(imageView)
        view.addSubview(evolutionsStackView)
        view.addSubview(descriptionTextView)
        view.addSubview(favoriteButton)
        
        pokemonIDLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        pokemonNameLabel.snp.makeConstraints { make in
            make.top.equalTo(pokemonIDLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        typesStackView.snp.makeConstraints { make in
            make.top.equalTo(pokemonNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(typesStackView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.equalTo(200)
        }
        
        evolutionsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(evolutionsStackView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(8)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
    
    func config(with model: PokemonDisplay) {
        pokemonIDLabel.text = "ID: \(model.speciesID)"
        pokemonNameLabel.text = model.name
        if let image = model.image {
            imageView.image = UIImage(data: image)
        }
        updateDescriptionTextViewHeight(text: model.flavorText.flavorText)
        
        for type in model.types {
            let typeLabel = UILabel()
            typeLabel.text = type
            typesStackView.addArrangedSubview(typeLabel)
        }
        
        favoriteButton.isSelected = model.isFavorite
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        try? drawEvolutionChain(model.evolutionChain)
    }
    
    private func drawEvolutionChain(_ evolutionChain: PokemonEvolutionChain) throws {
        var queue: Deque<PokemonEvolution> = [evolutionChain.evolvesTo]
        while queue.count > 0 {
            var count = queue.count
            let vStackView = UIStackView()
            vStackView.axis = .vertical
            vStackView.distribution = .fillEqually
            while count > 0 {
                count -= 1
                // FIXME: Currently, it's only draw the evolutions in local
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
                
                if let pokemon = try? presenter.evolutionPokemonDisplay(for: evolution.speciesID), let imageData = pokemon.image {
                    button.setImage(UIImage(data: imageData), for: .normal)
                }
                
                vStackView.addArrangedSubview(button)
            }
            if vStackView.arrangedSubviews.count > 0 {
                evolutionsStackView.addArrangedSubview(vStackView)
            }
        }
    }
    
    private func updateDescriptionTextViewHeight(text: String) {
        var finalText = text.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: " ")
        descriptionTextView.text = finalText
        descriptionTextView.sizeToFit()
    }
    
    @objc func pushToPokemonDetail(_ sender: UIButton) {
        guard sender.tag != presenter.pokemon.speciesID else {
            return
        }
        try? presenter.pushToPokemonDetail(for: sender.tag)
    }
    
    @objc func favoriteButtonTapped() {
        presenter.toggleFavorite()
        favoriteButton.isSelected.toggle()
    }
}
