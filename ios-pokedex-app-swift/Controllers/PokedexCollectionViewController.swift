//
//  ViewController.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 5/6/2025.
//

import UIKit

private let reuseIdentifier = "PokedexIdentifier"

class PokedexCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var pokemonCollection = [PokemonCollectionModel]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIComponents()
        networkingPokemonCollections()
    }
    
    // MARK: - Selectors
    
    @objc func showSearchBar() {
        print("work")
    }
    
    // MARK: - Networking
    
    func networkingPokemonCollections() {
        Service.shared.fetchPokemonCollections { (pokemonCollection) in
            DispatchQueue.main.sync {
                self.pokemonCollection = pokemonCollection
                self.collectionView.reloadData()
            }
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        
        collectionView.register(PokedexCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
}

    // MARK: - UICollectionView DataSource

extension PokedexCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCollectionViewCell
        cell.pokemonCollection = pokemonCollection[indexPath.item]
        return cell
    }
}

    // MARK: - UICollectionView Delegate

extension PokedexCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
}

