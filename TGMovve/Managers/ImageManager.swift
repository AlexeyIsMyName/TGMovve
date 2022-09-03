//
//  ImageManager.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 03.09.2022.
//

import Foundation
import UIKit


class ImageManager {
    static var shared = ImageManager()
    private init() {}
    
    
    enum Size {
        case small
        case medium
        case large
    }
    
    func fetchImegeOf(size: Size, from url: String, complition: @escaping (UIImage) -> Void) {
        switch size {
        case .small:
            fetchSmallImage(from: url, complition: complition)
        case .medium:
            fetchMediumImage(from: url, complition: complition)
        case .large:
            fetchLargeImage(from: url, complition: complition)
        }
    }
    
    private func fetchSmallImage(from url: String, complition: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            URLManager.get.smallImageFor(url) { imageURL in
                
                
                
                
                
                
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                guard let image = UIImage(data: imageData) else { return }
                DispatchQueue.main.async {
    
                    complition(image)
                    
                }
                
            }
        }
    }
    
    private func fetchMediumImage(from url: String, complition: (UIImage) -> Void) {
        
    }
    
    private func fetchLargeImage(from url: String, complition: (UIImage) -> Void) {
        
    }
    
}
