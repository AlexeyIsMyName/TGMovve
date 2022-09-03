//
//  ContentCell.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 31.08.2022.
//

import UIKit

final class ContentCell: UICollectionViewCell {
    
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:viewModel.date)

            if let date = date {
                dateFormatter.dateFormat = "MMM dd, yyyy"
                dateLabel.text = dateFormatter.string(from: date)
            }
            
            if let posterURL = viewModel.posterURL {
                ImageManager.shared.fetchImegeOf(size: .medium, from: posterURL) { image in
                    self.posterImage.image = image
                }
            }
            
        }
    }
    
    
}
