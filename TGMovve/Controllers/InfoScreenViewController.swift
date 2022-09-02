//
//  InfoScreenViewController.swift
//  TGMovve
//
//  Created by Alexander Altman on 30.08.2022.
//

import UIKit

class InfoScreenViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet var stars: [UIImageView]!
    
    
    
    var show: ShowRepresentable!
    var cast: [Cast]?
    
    var runtime: String {
        guard let runtime = show.runtime else {return ""}
        return "\(runtime / 60) h \(runtime - (runtime / 60) * 60) m"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
    
    
    
    func updateUI() {
        videoNameLabel.text = show.title
        infoLabel.text = "\(show.releaseDate.prefix(4)), Жанр, \(runtime)"
        
        setRating()
        descriptionLabel.text = show.overview
    }
    
    func prepareWith(_ content: ContentRepresentable) {
        if let movie = content as? Movie {
            //вызов метода №1
            getMovieInfoFor(id: movie.id)
        }
        if let tvSeries = content as? TVSeries {
            //вызов метода №2
            getTVSeriesInfoFor(id: tvSeries.id)
        }
    }
    
    
    func prepareWith(_ content: Content) {
        if content.type == "Movie" {
            //вызов метода №1
            getMovieInfoFor(id: Int(content.id))
        }
        
        if content.type == "TVSeries" {
            //вызов метода №2
            getTVSeriesInfoFor(id: Int(content.id))
        }
    }
    
    
}

//MARK: UICollectionViewDataSource
extension InfoScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as? CastCell else {
            return CastCell()
        }
        
        //        let cast = cast[indexPath.item]
        //        castCell.actorName.text = cast.name
        //        castCell.castName.text = cast.character
        
        
        // дописать реализацию получения картинки
        
        
        return castCell
    }
}

//MARK: Networking
extension InfoScreenViewController {
    
    func getMovieInfoFor(id: Int) {
        NetworkManager.shared.fetchMovieInfoFor(movieID: id) { movieInfo in
            self.show = movieInfo
            self.updateUI()
        }
        NetworkManager.shared.fetchMovieCastFor(movieID: id) { castInfo in
            self.cast = castInfo
            self.collectionView.reloadData()
        }
    }
    
    
    func getTVSeriesInfoFor(id: Int) {
        NetworkManager.shared.fetchTVSeriesInfoFor(tvID: id) { tvSeriesInfo in
            self.show = tvSeriesInfo
            self.updateUI()
        }
        NetworkManager.shared.fetchTVSeriesCastFor(tvID: id) { castInfo in
            self.cast = castInfo
            self.collectionView.reloadData()
        }
    }
}

//MARK: Raiting manager
extension InfoScreenViewController {
    
    func setRating() {
        raitingLabel.text = String(format: "%.1f", show.voteAverage)
        
        let starFill = UIImage(systemName: "star.fill")
        let starLeadinghalfFilled = UIImage(systemName: "star.leadinghalf.filled")
        
        for starNumber in 1...stars.count {
            
            let rating = (show.voteAverage / 10) * 5
            let starIndex = starNumber - 1
            
            if starNumber <= Int(rating) {
                stars[starIndex].image = starFill
            } else if starNumber <= Int(rating + 1) {
                stars[starIndex].image = starLeadinghalfFilled
            }
        }
    }
}

