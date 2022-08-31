//
//  ContentCell.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 31.08.2022.
//

import UIKit

class ContentCell: UICollectionViewCell {
    
    struct ViewModel {
        let posterURL: String?
        let title: String
        let date: String
    }
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var viewModel: ViewModel! {
        didSet {
            
            titleLabel.text = viewModel.title
            dateLabel.text = viewModel.date
            
            if let posterURL = viewModel.posterURL {
                DispatchQueue.global().async {
                    URLManager.get.mediumImageFor(posterURL) { imageURL in
                        guard let imageData = try? Data(contentsOf: imageURL) else { return }
                        DispatchQueue.main.async {
                            self.posterImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
        }
    }
}
