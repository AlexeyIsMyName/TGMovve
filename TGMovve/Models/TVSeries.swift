//
//  Tv.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

struct TVSeries: Decodable, ContentRepresentable {
    
    var title: String {
        return name
    }
    
    var releaseDate: String {
        return firstAirDate
    }
    
    let id: Int
    let name: String
    let posterPath: String?
    let firstAirDate: String
}

struct TVSeriesData: Decodable {
    let results: [TVSeries]
}
