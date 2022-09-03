//
//  InfoScreenViewController.swift
//  TGMovve
//
//  Created by Alexander Altman on 30.08.2022.
//

import UIKit
import CoreData

class InfoScreenViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet var bgView: UIView!
    
    var show: ShowRepresentable!
    var cast: [Cast]?
    
    var runtime: String {
        guard let runtime = show.runtime else {return ""}
        return ", \(runtime / 60) h \(runtime - (runtime / 60) * 60) m"
    }
    
    var genre: String {
        show.genres.map {$0.name}.joined(separator: ", ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        setGradientView()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: Any) {
        
        if let isMatches = ContextManager.shared.deleteIfMatches(title: show.title), isMatches {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        } else {
            
            let newContent = Content(context: ContextManager.shared.context)
            newContent.id = Int32(show.id)
            newContent.title = show.title
            newContent.posterPath = show.posterPath
            newContent.releaseData = show.releaseDate
            
            if let _ = show as? MovieInfo {
                newContent.type = "Movie"
            }
            
            if let _ = show as? TVSeriesInfo {
                newContent.type = "TVSeries"
            }
            
            ContextManager.shared.saveContext()
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        }
        
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: show.homepage!)!)
    }
    
    func updateUI() {
        setRating()
        videoNameLabel.text = show.title
        descriptionLabel.text = show.overview
        infoLabel.text = "\(show.releaseDate.prefix(4)), \(genre) \(runtime)"
        
        if show.homepage != nil {
            detailsButton.isEnabled = true
        }
        
        if let posterURL = show.posterPath {
            ImageManager.shared.fetchImegeOf(size: .large, from: posterURL) { image in
                self.posterImage.image = image
            }
        }
        
        if let isMatches = ContextManager.shared.isDataMatchesWith(title: show.title), isMatches {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        }
    }
    
    func setGradientView() {
        let colorTop =  UIColor(red: 21.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 0.0).cgColor
        let colorTopC = UIColor(red: 21.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 0.5).cgColor
        let colorBottomC = UIColor(red: 21.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 0.75).cgColor
        let colorBottom = UIColor(red: 21.0/255.0, green: 24.0/255.0, blue: 33.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorTopC, colorBottomC, colorBottom]
        gradientLayer.locations = [0.0, 0.2, 0.5, 0.9]
        gradientLayer.frame = bgView.bounds
        
        bgView.layer.insertSublayer(gradientLayer, at:0)
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
        return cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as? CastCell else {
            return CastCell()
        }
        
        if let cast = cast?[indexPath.item] {
            castCell.actorName.text = cast.name
            castCell.castName.text = cast.character
            
            if let posterURL = cast.profilePath {
                ImageManager.shared.fetchImegeOf(size: .small, from: posterURL) { image in
                    castCell.actorImage.image = image
                }
            }
        }
        
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
