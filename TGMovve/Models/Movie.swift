//
//  Movies.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

struct Movie: Decodable, ContentRepresentable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
}

struct MovieData: Decodable {
    let results: [Movie]
}
