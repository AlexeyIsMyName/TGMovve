//
//  InfoScreenViewController.swift
//  TGMovve
//
//  Created by Alexander Altman on 30.08.2022.
//

import UIKit
import CoreData

class InfoScreenViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    
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
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: Any) {
        
        let newContent = Content(context: self.context)
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
        
        if checkDataInFavorites() {
            context.delete(newContent)
            bookmarkButton.image = UIImage(systemName: "bookmark")
        } else {
            do {
                try context.save()
                bookmarkButton.image = UIImage(systemName: "bookmark.fill")
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: show.homepage!)!)
    }
    
    func updateUI() {
        videoNameLabel.text = show.title
        infoLabel.text = "\(show.releaseDate.prefix(4)), \(genre) \(runtime)"
        if show.homepage != nil {
            detailsButton.isEnabled = true
        }
        setRating()
        descriptionLabel.text = show.overview
        
        if let posterURL = show.posterPath {
            DispatchQueue.global().async {
                URLManager.get.largeImageFor(posterURL) { imageURL in
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        if checkDataInFavorites() {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        }
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
        print(cast?.count ?? 0)
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
                DispatchQueue.global().async {
                    URLManager.get.smallImageFor(posterURL) { imageURL in
                        guard let imageData = try? Data(contentsOf: imageURL) else { return }
                        DispatchQueue.main.async {
                            castCell.actorImage.image = UIImage(data: imageData)
                        }
                    }
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

//MARK: - Querying data

extension InfoScreenViewController {
    
    func checkDataInFavorites() -> Bool {
        
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        
        request.predicate = NSPredicate(format: "title MATCHES[cd] %@", show.title)
                
        do {
            let contents = try context.fetch(request)
            if contents.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        return true
    }
}
