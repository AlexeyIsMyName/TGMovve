//
//  ShowRepresentable.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 30.08.2022.
//

protocol ShowRepresentable {
    var posterPath: String? { get }
    var id: Int { get }
    var title: String { get }
    var tagline: String? { get }
    var releaseDate: String { get }
    var voteAverage: Float { get }
    var genres: [Genre] { get }
    var overview: String? { get }
    var homepage: String? { get }
}
