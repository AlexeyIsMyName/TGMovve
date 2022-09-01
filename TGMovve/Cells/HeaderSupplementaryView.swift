//
//  HeaderSupplementaryView.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 31.08.2022.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    
    struct ViewModel {
        let name: String
    }
    
    @IBOutlet var groupNameLabel: UILabel!

    var viewModel: ViewModel! {
        didSet {
            groupNameLabel.text = viewModel.name
        }
    }
}
