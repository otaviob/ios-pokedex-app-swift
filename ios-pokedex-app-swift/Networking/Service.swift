//
//  Service.swift
//  ios-pokedex-app-swift
//
//  Created by Otavio Brito on 8/6/2025.
//

import Foundation

class Service {
    
    static let shared = Service()
    let BASE_URL = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    
    func downloadPokemonCollections() {
        
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
                
                    print(resultArray)
                
            } catch let error {
                print("failed to create json with error: ", error.localizedDescription)
            }   
        }.resume()
    }
}
