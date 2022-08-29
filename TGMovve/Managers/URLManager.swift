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
    
    var tvSeriesDiscover: String {
        return "\(URLBase.tvSeriesDiscover.rawValue)?api_key=\(apiKey)"
    }
    
    var movieDiscover: String {
        return "\(URLBase.movieDiscover.rawValue)?api_key=\(apiKey)"
    }
    
    func tvSeriesDetailsFor(tvID: Int) -> String {
        let baseURL = URLBase.tvSeriesDetails.rawValue
        return "\(baseURL)/\(tvID)?api_key=\(apiKey)"
    }
    
    func tvSeriesCreditsFor(tvID: Int) -> String {
        let baseURL = URLBase.tvSeriesDetails.rawValue
        return "\(baseURL)/\(tvID)/credits?api_key=\(apiKey)"
    }
    
    func movieDetailsFor(movieID: Int) -> String {
        let baseURL = URLBase.movieDetails.rawValue
        return "\(baseURL)/\(movieID)?api_key=\(apiKey)"
    }
    
    func movieCreditsFor(movieID: Int) -> String {
        let baseURL = URLBase.movieDetails.rawValue
        return "\(baseURL)/\(movieID)/credits?api_key=\(apiKey)"
    }
    
    func largeImageFor(_ shortImageURL: String) -> String {
        let baseImageURL = URLBase.largeImage.rawValue
        return "\(baseImageURL)\(shortImageURL)"
    }
    
    func mediumImageFor(_ shortImageURL: String) -> String {
        let baseImageURL = URLBase.mediumImage.rawValue
        return "\(baseImageURL)\(shortImageURL)"
    }
    
    func smallImageFor(_ shortImageURL: String) -> String {
        let baseImageURL = URLBase.smallImage.rawValue
        return "\(baseImageURL)\(shortImageURL)"
    }
        
    private init(){}
}
