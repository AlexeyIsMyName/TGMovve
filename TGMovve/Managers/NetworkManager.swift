//
//  NetworkManager.swift
//  TGMovve
//
//  Created by Anton Ermokhin on 30.08.2022.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    
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
    
    func fetchMovieInfoFor(movieID: Int, completion: @escaping (MovieInfo) -> Void) {
        
        URLManager.get.movieDetailsFor(movieID: movieID) {  url in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movieInfo = try decoder.decode(MovieInfo.self, from: data)
                    DispatchQueue.main.async {
                        completion(movieInfo)
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }
    
    func fetchTVSeriesInfoFor(tvID: Int, completion: @escaping (TVSeriesInfo) -> Void) {
        
        URLManager.get.tvSeriesDetailsFor(tvID: tvID) { url in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let tvSeriesInfo = try decoder.decode(TVSeriesInfo.self, from: data)
                    DispatchQueue.main.async {
                        completion(tvSeriesInfo)
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }
    
    func fetchMovieCastFor(movieID: Int, completion: @escaping ([Cast]) -> Void) {
        
        URLManager.get.movieCreditsFor(movieID: movieID) { url in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let castData = try decoder.decode(CastData.self, from: data)
                    DispatchQueue.main.async {
                        completion(castData.cast)
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }
    
    func fetchTVSeriesCastFor(tvID: Int, completion: @escaping ([Cast]) -> Void) {
        
        URLManager.get.tvSeriesCreditsFor(tvID: tvID) { url in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let castData = try decoder.decode(CastData.self, from: data)
                    DispatchQueue.main.async {
                        completion(castData.cast)
                    }
                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }
    
    
}
