//
//  TVSeriesInfo.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

struct TVSeriesInfo: Decodable, ShowRepresentable {
    
    var title: String {
        return name
    }
    
    var releaseDate: String {
        return firstAirDate
    }
    
    let posterPath: String?
    let id: Int
    let name: String
    let tagline: String?
    let firstAirDate: String
    let voteAverage: Float
    let genres: [Genre]
    let overview: String?
    let homepage: String?
    let runtime: Int?
}
