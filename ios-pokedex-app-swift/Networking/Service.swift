//
//  Service.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 8/6/2025.
//

import UIKit

class Service {
    
    static let shared = Service()
    let BASE_URL = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    
    /// download
    
    func fetchPokemonCollections(completion: @escaping ([PokedexCollectionModel]) -> ()) {
        
        var pokemoncollectionArray = [PokedexCollectionModel]()
        
        guard let url = URL(string: BASE_URL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle error
            if let error = error {
                print("failed to fetch data with error", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                guard let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else { return }
                
                for (key, result) in resultArray.enumerated() {
                    if let dictionary = result as? [String: AnyObject] {
                        let pokemon = PokedexCollectionModel(id: key, dictionary: dictionary)
                        guard let imageUrl = pokemon.imageUrl else { return }
                        
                        self.fetchImage(withUrlString: imageUrl, completion: { (image) in
                            pokemon.image = image
                            pokemoncollectionArray.append(pokemon)
                            pokemoncollectionArray.sort { (pokeCollection1, pokeCollection2) -> Bool in
                                return pokeCollection1.id! < pokeCollection2.id!
                            }
                            completion(pokemoncollectionArray)
                        })
                    }
                }
                
            } catch let error {
                print("failed to create json with error: ", error.localizedDescription)
            }
        }.resume()
    }
    
    /// donwload image 
    
    private func fetchImage(withUrlString urlString: String, completion: @escaping(UIImage) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch image with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
            
        }.resume()
    }
}





