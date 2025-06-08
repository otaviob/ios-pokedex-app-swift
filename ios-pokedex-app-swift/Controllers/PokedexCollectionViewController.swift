//
//  ViewController.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 5/6/2025.
//

import UIKit

private let reuseIdentifier = "PokedexIdentifier"

class PokedexCollectionViewController: UICollectionViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIComponents()
        downloadPokemonCollections()
        
    }
    
    // MARK: - Selectors
    
    @objc func showSearchBar() {
        print("work")
    }
    
    // MARK: - Networking
    
    func downloadPokemonCollections() {
        Service.shared.downloadPokemonCollections()
        
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
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCollectionViewCell
        cell.backgroundColor = .mainColor()
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

