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

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
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
