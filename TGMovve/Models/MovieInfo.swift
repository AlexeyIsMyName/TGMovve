//
//  MovieInfo.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

import Foundation

struct MovieInfo: Decodable {
    let posterPath: String?
    let id: Int
    let title: String
    let tagline: String?
    let releaseDate: String
    let voteAverage: Float
    let genres: [Genres]
    let overview: String?
    let cast: [Cast]
}
