//
//  MovieInfo.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

struct MovieInfo: Decodable, ShowRepresentable {
    let posterPath: String?
    let id: Int
    let title: String
    let tagline: String?
    let releaseDate: String
    let voteAverage: Float
    let genres: [Genre]
    let overview: String?
    let homepage: String?
}
