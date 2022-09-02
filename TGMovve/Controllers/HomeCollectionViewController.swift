//
//  HomeCollectionViewController.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 31.08.2022.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let compositionalLayout: UICollectionViewCompositionalLayout = {
        let inset: CGFloat = 8
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        section.orthogonalScrollingBehavior = .continuous
        
        // Supplementary Item - HEADER
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: inset, bottom: 8, trailing: inset)
        section.boundarySupplementaryItems = [headerItem]
        
        // Decoration Item - BACKGROUND
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        section.decorationItems = [backgroundItem]
        
        // Section Configuration
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        // Make UICollectionViewCompositionalLayout
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: "background")
        
        return layout
    }()
    
    var contentList: [String: [ContentRepresentable]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        collectionView.collectionViewLayout = compositionalLayout
        fillData()
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "ContentCell", bundle: nil), forCellWithReuseIdentifier: "ContentCell")
        collectionView.register(UINib(nibName: "HeaderSupplementaryView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "ContentHeader")
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentList.values.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentHeader", for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }
        
        headerView.viewModel = HeaderSupplementaryView.ViewModel(name: Array(contentList.keys)[indexPath.section])
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        
        let valueKey = Array(contentList.keys)[section]
        let contentType = contentList[valueKey]
        numberOfItems = contentType?.count ?? 0
        
        return numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as? ContentCell else {
            return UICollectionViewCell()
        }
        
        let valueKey = Array(contentList.keys)[indexPath.section]
        
        if let contentArray = contentList[valueKey] {
            let content = contentArray[indexPath.item]
            
            contentCell.viewModel = ContentCell.ViewModel(
                posterURL: content.posterPath,
                title: content.title,
                date: content.releaseDate
            )
        }
        
        return contentCell
    }
    
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailsFromHome", sender: nil)
        
        let valueKey = Array(contentList.keys)[indexPath.section]
        
        if let contentArray = contentList[valueKey] {
            let content = contentArray[indexPath.item]
            let newContent = Content(context: self.context)
            newContent.id = Int32(content.id)
            newContent.title = content.title
            newContent.posterPath = content.posterPath
            newContent.releaseData = content.releaseDate
            
            if let _ = content as? Movie {
                newContent.type = "Movie"
            }
            
            if let _ = content as? TVSeries {
                newContent.type = "TVSeries"
            }
            
            
            
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        guard let infoScreenVC = segue.destination as? InfoScreenViewController else { return }
        
        let valueKey = Array(contentList.keys)[indexPath.section]
        
        if let contentArray = contentList[valueKey] {
            let content = contentArray[indexPath.item]
            infoScreenVC.prepareWith(content)
        }
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {}
    
    
    // MARK: - Data proveder methods
    private func fillData() {
        NetworkManager.shared.fetchMovies { movies in
            self.contentList["Popular Movies"] = movies
            self.collectionView.reloadData()
        }
        
        NetworkManager.shared.fetchTVSeries { tvShows in
            self.contentList["TV Shows"] = tvShows
            self.collectionView.reloadData()
        }
    }
    
    
}
