//
//  NetworkManager.swift
//  TGMovve
//
//  Created by Anton Ermokhin on 30.08.2022.
//

import Foundation

class NetworkManager {
    
    let shared = NetworkManager()
    
    func fetchMovies(with completion: @escaping ([Movie]) -> Void) {
        
        URLManager.get.movieDiscover { url in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movieData = try decoder.decode(MovieData.self, from: data)
                    DispatchQueue.main.async {
                        completion(movieData.results)
                    }
                } catch let error {
                    print(error)
                }
                
            }.resume()
        }
        
    }
    
    func fetchTVSeries(with completion: @escaping ([TVSeries]) -> Void) {
        
        URLManager.get.tvSeriesDiscover { url in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let tvSeriesData = try decoder.decode(TVSeriesData.self, from: data)
                    DispatchQueue.main.async {
                        completion(tvSeriesData.results)
                    }
                } catch let error {
                    print(error)
                }
                
            }.resume()
        }
    }
    private init() {}
}
