//
//  URLManager.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 30.08.2022.
//

import Foundation

class URLManager {
    
    static let get = URLManager()
    
    private enum URLBase: String {
        case tvSeriesDiscover = "https://api.themoviedb.org/3/discover/tv"
        case movieDiscover = "https://api.themoviedb.org/3/discover/movie"
        case tvSeriesDetails = "https://api.themoviedb.org/3/tv"
        case movieDetails = "https://api.themoviedb.org/3/movie"
        case largeImage = "https://image.tmdb.org/t/p/w500"
        case mediumImage = "https://image.tmdb.org/t/p/w185"
        case smallImage = "https://image.tmdb.org/t/p/w92"
    }
    
    private let apiKey = "45679b9862cd16ef700c12d00d673fca"
    
    func tvSeriesDiscover(completion: (URL) -> Void) {
        if let url = URL(string: "\(URLBase.tvSeriesDiscover.rawValue)?api_key=\(apiKey)") {
            completion(url)
        }
    }
    
    func movieDiscover(completion: (URL) -> Void) {
        if let url = URL(string: "\(URLBase.movieDiscover.rawValue)?api_key=\(apiKey)") {
            completion(url)
        }
    }
    
    func tvSeriesDetailsFor(tvID: Int, completion: (URL) -> Void) {
        let baseURL = URLBase.tvSeriesDetails.rawValue
        if let url = URL(string: "\(baseURL)/\(tvID)?api_key=\(apiKey)") {
            completion(url)
        }
    }
    
    func tvSeriesCreditsFor(tvID: Int, completion: (URL) -> Void) {
        let baseURL = URLBase.tvSeriesDetails.rawValue
        if let url = URL(string: "\(baseURL)/\(tvID)/credits?api_key=\(apiKey)") {
            completion(url)
        }
    }
    
    func movieDetailsFor(movieID: Int, completion: (URL) -> Void) {
        let baseURL = URLBase.movieDetails.rawValue
        if let url = URL(string: "\(baseURL)/\(movieID)?api_key=\(apiKey)") {
            completion(url)
        }
    }
    
    func movieCreditsFor(movieID: Int, completion: (URL) -> Void) {
        let baseURL = URLBase.movieDetails.rawValue
        if let url = URL(string: "\(baseURL)/\(movieID)/credits?api_key=\(apiKey)") {
            completion(url)
        }
    }
    
    func largeImageFor(_ shortImageURL: String, completion: (URL) -> Void) {
        let baseImageURL = URLBase.largeImage.rawValue
        if let url = URL(string: "\(baseImageURL)\(shortImageURL)") {
            completion(url)
        }
    }
    
    func mediumImageFor(_ shortImageURL: String, completion: (URL) -> Void) {
        let baseImageURL = URLBase.mediumImage.rawValue
        if let url = URL(string: "\(baseImageURL)\(shortImageURL)") {
            completion(url)
        }
    }
    
    func smallImageFor(_ shortImageURL: String, completion: (URL) -> Void) {
        let baseImageURL = URLBase.smallImage.rawValue
        if let url = URL(string: "\(baseImageURL)\(shortImageURL)") {
            completion(url)
        }
    }
        
    private init(){}
}
