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
    
    var pokedexCollection = [PokemonCollectionModel]()
    
    let infoView: PokedexInfoView = {
        let view = PokedexInfoView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
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
        Service.shared.fetchPokemonCollections { (pokedexCollection) in
            DispatchQueue.main.sync {
                self.pokedexCollection = pokedexCollection
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
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        visualEffectView.alpha = 0
        
    }
}

    // MARK: - UICollectionView DataSource

extension PokedexCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokedexCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCollectionViewCell
        cell.pokedexCollection = pokedexCollection[indexPath.item]
        cell.delegate = self
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

extension PokedexCollectionViewController: PokedexCollectionViewCellDelegate {
    
    func presentPokedexInfoView(withPokedex pokedex: PokemonCollectionModel) {
        
        view.addSubview(infoView)
        infoView.delegate = self
        infoView.pokedex = pokedex
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 350)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -44).isActive = true
        
        infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        infoView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
    }
    
    
}

extension PokedexCollectionViewController: InfoViewDelegate {
    func dismisssInfoView(withPokemon pokemon: PokemonCollectionModel?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
            
        }
        
    }
}



