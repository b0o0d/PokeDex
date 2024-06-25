//
//  PokemonListCell.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

protocol BasicCellProtocol: UITableViewCell {
    associatedtype Model
    static var reuseIdentifier: String { get }
    
    func setupLayout()
    func configure(with model: Model)
}

class PokemonBasicCell: UITableViewCell, BasicCellProtocol {
    typealias Model = PokemonDisplayable
    static let reuseIdentifier = "PokemonBasicCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        // Override this method in subclass
    }
    
    func configure(with model: any PokemonDisplayable) {
        // Override this method in subclass
    }
}

class PokemonListCell: PokemonBasicCell {
    lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var typesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var pokemonIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func favoriteButtonTapped() {
        favoriteTapped?(favoriteButton.tag)
        favoriteButton.isSelected.toggle()
    }
    
    var imageDownloaded: ((URL?, UIImage?) -> Void)?
    var favoriteTapped: ((Int) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.image = nil
        pokemonNameLabel.text = nil
        pokemonIDLabel.text = nil
        typesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        favoriteButton.isSelected = false
    }
    
    // MARK: - BasicCellProtocol
    override func setupLayout() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonNameLabel)
        contentView.addSubview(typesStackView)
        contentView.addSubview(pokemonIDLabel)
        contentView.addSubview(favoriteButton)
        
        pokemonImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        pokemonNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonImageView.snp.trailing).offset(16)
            make.top.equalTo(contentView.snp.top).offset(8)
        }
        
        typesStackView.snp.makeConstraints { make in
            make.leading.equalTo(pokemonImageView.snp.trailing).offset(16)
            make.top.equalTo(pokemonNameLabel.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
        
        pokemonIDLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(pokemonIDLabel.snp.leading).offset(-8)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    override func configure(with model: any PokemonDisplayable) {
        pokemonNameLabel.text = model.name
        pokemonIDLabel.text = String(model.speciesID)
        for type in model.types {
            let typeLabel = UILabel()
            typeLabel.text = type
            typeLabel.font = .systemFont(ofSize: 16, weight: .regular)
            typeLabel.textColor = .black
            typeLabel.textAlignment = .center
            typeLabel.layer.cornerRadius = 8
            typeLabel.layer.masksToBounds = true
            typesStackView.addArrangedSubview(typeLabel)
        }
        favoriteButton.isSelected = model.isFavorite
        favoriteButton.tag = model.speciesID
        
        if let imageData = model.image {
            pokemonImageView.image = UIImage(data: imageData)
        } else if let imageURLStr = model.imageURL, let imageURL = URL(string: imageURLStr) {
            pokemonImageView.sd_setImage(with: imageURL) { [weak self] image, error, type, url in
                self?.imageDownloaded?(url, image)
            }
        }
    }
}
