//
//  HomeCollectionViewController.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 31.08.2022.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    let compositionalLayout: UICollectionViewCompositionalLayout = {
        let inset: CGFloat = 8
        let leadingInset: CGFloat = 8
        let trailingInset: CGFloat = 8
        
        // Items
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leadingInset, bottom: 0, trailing: trailingInset)
        
        // Outer Group
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leadingInset, bottom: 0, trailing: trailingInset)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: leadingInset, bottom: inset, trailing: trailingInset)
        section.orthogonalScrollingBehavior = .continuous
        
        // Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: leadingInset, bottom: 8, trailing: trailingInset)
        section.boundarySupplementaryItems = [headerItem]
        
        // Decoration Item
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        section.decorationItems = [backgroundItem]
        
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as? ContentCell else {
            return UICollectionViewCell()
        }
        
        let valueKey = Array(contentList.keys)[indexPath.section]
        
        if let contentArray = contentList[valueKey] {
            let content = contentArray[indexPath.item]
            cell.viewModel = ContentCell.ViewModel(posterURL: content.posterPath, title: content.title, date: content.releaseDate)
        }
        
        return cell
    }

    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailsFromHome", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        print(indexPath)
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
