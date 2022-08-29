//
//  URLManager.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 30.08.2022.
//

import Foundation

class URLManager {
    private enum URLBase: String {
            case tvSeriesDiscover = "https://api.themoviedb.org/3/discover/movie"
            case movieDiscover = "https://api.themoviedb.org/3/discover/tv"
        //    case tvDetails
        //    case movieDetails
        //    case tvCredits
        //    case movieCredits
            case largeImage = "https://image.tmdb.org/t/p/w92/"
            case mediumImage = "https://image.tmdb.org/t/p/w185/"
            case smallImage = "https://image.tmdb.org/t/p/w500/"
        }
    
    private let apiKey = "45679b9862cd16ef700c12d00d673fca"
    
    var tvSeriesDiscover: String {
        return "\(URLBase.tvSeriesDiscover.rawValue)?api_key=\(apiKey)"
    }
    
    var movieDiscover: String {
        return "\(URLBase.movieDiscover.rawValue)?api_key=\(apiKey)"
    }
    
    func tvDetailsFor(tvID: Int) -> String {
        let baseURL = URLBase.tvSeriesDiscover.rawValue
        
        
        
        return baseURL
    }
}
