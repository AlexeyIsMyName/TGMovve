//
//  TemporaryManager.swift
//  TGMovve
//
//  Created by Eduard Tokarev on 30.08.2022.
//

import Foundation

//        let URL = "https://api.themoviedb.org/3/discover/movie?api_key=45679b9862cd16ef700c12d00d673fca"

extension Movie {
    static func  getMovies() -> [Movie] {
        let movies = [
            Movie(id: 616037, title: "Thor: Love and Thunder", posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg", releaseDate: "2022-07-06"),
            Movie(id: 610150, title: "Dragon Ball Super: Super Hero", posterPath: "/rugyJdeoJm7cSJL1q4jBpTNbxyU.jpg", releaseDate: "2022-06-11"),
            Movie(id: 766507, title: "Prey", posterPath: "/ujr5pztc1oitbe7ViMUOilFaJ7s.jpg", releaseDate: "2022-08-02"),
            Movie(id: 361743, title: "Top Gun: Maverick", posterPath: "/62HCnUTziyWcpDaBO2i1DX17ljH.jpg", releaseDate: "2022-05-24"),
            Movie(id: 438148, title: "Minions: The Rise of Gru", posterPath: "/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg", releaseDate: "2022-06-29")
        ]
        return movies
    }
}

extension TVSeries {
    static func getTVSeries() -> [TVSeries] {

        let tvSeries = [
            TVSeries(id: 94997, name: "House of the Dragon", posterPath: "/wW5WW34KhCDNGRs3gnzqrzQeiEB.jpg", firstAirDate: "2022-08-21"),
            TVSeries(id: 92783, name: "She-Hulk: Attorney at Law", posterPath: "/hJfI6AGrmr4uSHRccfJuSsapvOb.jpg", firstAirDate: "2022-08-18"),
            TVSeries(id: 90802, name: "The Sandman", posterPath: "/q54qEgagGOYCq5D1903eBVMNkbo.jpg", firstAirDate: "2022-08-05"),
            TVSeries(id: 66370, name: "Ode to Joy", posterPath: "/mw4ZkRFHMuA5Ao4Zsc7p8PVnf8q.jpg", firstAirDate: "2016-04-18"),
            TVSeries(id: 80020, name: "Super Dragon Ball Heroes", posterPath: "/jYeTfpxS3IzgqKkYCjmdCKwq8PW.jpg", firstAirDate: "2018-07-01")
        ]
        return tvSeries
    }
}
