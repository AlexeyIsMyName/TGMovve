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
    var cast: [Cast]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        getShow()
        getCast()
    }
    
    func updateUI() {
        videoNameLabel.text = show.title
        //        infoLabel.text = "\(show.releaseDate.prefix(4)), Жанр, \((show.runtime ?? 0) / 60) h \(show.runtime - ((show.runtime ?? 0) / 60) * 60) m"
        
        setRating()
        descriptionLabel.text = show.overview
    }
}

//MARK: UICollectionViewDataSource
extension InfoScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as? CastCell else {
            return CastCell()
        }
        
        let cast = cast[indexPath.item]
        castCell.actorName.text = cast.name
        castCell.castName.text = cast.character
        
        
        // дописать реализацию получения картинки
        
        
        return castCell
    }
}

//MARK: Networking
extension InfoScreenViewController {
    func getShow() {
        let movieInfo = MovieInfo(posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
                                  id: 616037,
                                  title: "Thor: Love and Thunder",
                                  tagline: "The one is not the only.",
                                  releaseDate: "2022-07-06",
                                  voteAverage: 8.767,
                                  genres: [Genre(id: 28, name: "Action"), Genre(id: 12, name: "Adventure"), Genre(id: 14, name: "Fantasy")],
                                  overview: "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor Odinson enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Relatively Mighty Girl Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
                                  homepage: "https://www.marvel.com/movies/thor-love-and-thunder",
                                  runtime: 223)
        
        show = movieInfo
        updateUI()
    }
    
    func getCast() {
        let castInfo = [
            Cast(name: "Chris Hemsworth", character: "Thor Odinson", profilePath: "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg"),
            Cast(name: "Christian Bale", character: "Gorr", profilePath: "/qCpZn2e3dimwbryLnqxZuI88PTi.jpg"),
            Cast(name: "Tessa Thompson", character: "King Valkyrie", profilePath: "/fycqdiiM6dsNSbnONBVVQ57ILV1.jpg"),
            Cast(name: "Taika Waititi", character: "Korg / Old Kronan God (voice)", profilePath: "/zCLBXGo5BS2e27srDBa5WpRnKul.jpg"),
            Cast(name: "Natalie Portman", character: "Jane Foster / The Mighty Thor", profilePath: "/mqKHKayGsEK3TOZDHs3eUAhCP6V.jpg"),
            Cast(name: "Chris Hemsworth", character: "Thor Odinson", profilePath: "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg"),
            Cast(name: "Christian Bale", character: "Gorr", profilePath: "/qCpZn2e3dimwbryLnqxZuI88PTi.jpg"),
            Cast(name: "Tessa Thompson", character: "King Valkyrie", profilePath: "/fycqdiiM6dsNSbnONBVVQ57ILV1.jpg"),
            Cast(name: "Taika Waititi", character: "Korg / Old Kronan God (voice)", profilePath: "/zCLBXGo5BS2e27srDBa5WpRnKul.jpg"),
            Cast(name: "Natalie Portman", character: "Jane Foster / The Mighty Thor", profilePath: "/mqKHKayGsEK3TOZDHs3eUAhCP6V.jpg")
        ]
        cast = castInfo
        collectionView.reloadData()
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
