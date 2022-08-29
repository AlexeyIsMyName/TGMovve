//
//  TVSeriesInfo.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

import Foundation

struct TVSeriesInfo: Decodable {
    let posterPath: String?
    let id: Int
    let name: String
    let tagline: String
    let firstAirDate: String
    let voteAverage: Float
    let genres: [Genres]
    let overview: String
    let cast: [Cast]
}
