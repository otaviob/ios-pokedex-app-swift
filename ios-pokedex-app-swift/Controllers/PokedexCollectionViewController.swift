//
//  PokedexCollectionViewController.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 5/6/2025.
//

import UIKit

private let reuseIdentifier = "PokedexIdentifier"

class PokedexCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var pokedexCollection = [PokedexCollectionModel]()
    var filteredPokedex = [PokedexCollectionModel]()
    var inSearchMode = false
    var searchBar: UISearchBar!
    
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
        configureSerchBar()
    }
    
    @objc func handleDismissal() {
        print("work")
        dismissInfoView(withPokedex: nil)
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
    
    // MARK: - Helper Functions
    
    func configureSerchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func configueSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func dismissInfoView(pokedex: PokedexCollectionModel?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
        }
    }
    
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
        
        configueSearchBarButton()
        
        collectionView.register(PokedexCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        visualEffectView.alpha = 0
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(gesture)
    }
}

// MARK: - SearchBar

extension PokedexCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configueSearchBarButton()
        inSearchMode = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokedex = pokedexCollection.filter({ $0 .name?.range(of: searchText.lowercased(), options: .caseInsensitive) != nil})
            
            collectionView.reloadData()
            }
        }
    }
    


    // MARK: - UICollectionViewDataSource/Delegate

extension PokedexCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokedex.count : pokedexCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCollectionViewCell
        
        cell.pokedexCollection = inSearchMode ? filteredPokedex[indexPath.row] : pokedexCollection[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = PokedexInfoViewController()
        controller.pokedex = inSearchMode ? filteredPokedex[indexPath.row] : pokedexCollection[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension PokedexCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
}

// MARK: - Delegate

extension PokedexCollectionViewController: PokedexCollectionViewCellDelegate {
    
    func presentPokedexInfoView(withPokedex pokedex: PokedexCollectionModel) {
        
        view.addSubview(infoView)
        infoView.configureUIComponents()
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
    func dismissInfoView(withPokedex pokedex: PokedexCollectionModel?) {
        dismissInfoView(pokedex: pokedex)
    }
}



