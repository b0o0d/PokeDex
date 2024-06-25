//
//  PokemonDetailViewController.swift
//  PokeDex
//
//  Created by Bo Chiu on 2024/6/25.
//

import Foundation
import UIKit
import SnapKit

class PokemonDetailViewController: UIViewController {
    private let presenter: PokemonDetailPresenter
    
    init(presenter: PokemonDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PokemonDetailViewController viewDidLoad")
    }
}
