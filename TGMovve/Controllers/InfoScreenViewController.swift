//
//  InfoScreenViewController.swift
//  TGMovve
//
//  Created by Alexander Altman on 30.08.2022.
//

import UIKit

class InfoScreenViewController: UIViewController {
    
    @IBOutlet weak var PosterImage: UIImageView!
    @IBOutlet weak var VideoNameLabel: UILabel!
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var RaitingLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var DetailsButton: UIButton!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
        CollectionView.delegate = self
    }
    
    
    
    
}

extension InfoScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}


