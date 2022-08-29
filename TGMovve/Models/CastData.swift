//
//  Cast.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

import Foundation

struct CastData: Codable {
    let cast: [Cast]
}

struct Cast: Codable {
    let name: String
    let character: String
    let profilePath: String?
}
