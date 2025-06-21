//
//  PokedexCollectionViewCell.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 5/6/2025.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var pokemonCollection: PokemonCollectionModel? {
        didSet {
            nameLabel.text = pokemonCollection?.name
            imageView.image = pokemonCollection?.image
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainColor()
        view.addSubview(nameLabel)
        nameLabel.center(inView: view)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Bulbasaur"
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handlongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("long press did begin")
        
        }
    }
        
        // MARK: - Helper Functions
        
        func configureUIComponents() {
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            
            addSubview(imageView)
            imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32)
            
            addSubview(nameContainerView)
            nameContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
            
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlongPress))
            self.addGestureRecognizer(longPressGestureRecognizer)
        }
    }

