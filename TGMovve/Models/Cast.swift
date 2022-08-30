//
//  Cast.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 29.08.2022.
//

import Foundation

struct Cast: Decodable {
    let name: String
    let character: String
    let profilePath: String?
}

struct CastData: Decodable {
    let cast: [Cast]
}
