//
//  Tv.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

import Foundation

struct TVSeries: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let firstAirDate: String
}

struct TVSeriesData: Decodable {
    let results: [TVSeries]
}
