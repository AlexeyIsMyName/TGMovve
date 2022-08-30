//
//  ContentRepresentable.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 31.08.2022.
//

protocol ContentRepresentable {
    var id: Int { get }
    var title: String { get }
    var posterPath: String? { get }
    var releaseDate: String { get }
}
