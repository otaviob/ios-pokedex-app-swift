//
//  ViewController.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 5/6/2025.
//

import UIKit

class PokedexCollectionViewController: UICollectionViewController {
    
    
    // MARK: - Inicialiers

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIComponents()
        
    }
    
    
    // MARK: - Configure UIComponents
    
    func configureUIComponents() {
        // [Style] - Navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Pokedex"

        
        
    }
    
    


}

