//
//  ImageManager.swift
//  TGMovve
//
//  Created by ALEKSEY SUSLOV on 03.09.2022.
//

import Foundation
import UIKit


final class ImageManager {
    static var shared = ImageManager()
    private init() {}
    
    
    enum Size {
        case small
        case medium
        case large
    }
    
    
    // MARK: - choosing the right fork which image size is needed
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
    
    
    // MARK: - Methods of getting different sizes of the image
    private func fetchSmallImage(from url: String, complition: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            URLManager.get.smallImageFor(url) { imageURL in
                self.fetchImage(from: imageURL, complition: complition)
            }
        }
    }
    
    private func fetchMediumImage(from url: String, complition: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            URLManager.get.mediumImageFor(url) { imageURL in
                self.fetchImage(from: imageURL, complition: complition)
            }
        }
    }
    
    private func fetchLargeImage(from url: String, complition: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            URLManager.get.largeImageFor(url) { imageURL in
                self.fetchImage(from: imageURL, complition: complition)
            }
        }
    }
    
    
    // MARK: - Networking and getting images depending on if the image is available in the cache
    private func fetchImage(from url: URL, complition: @escaping (UIImage) -> Void) {
        // Используем изображение из кеша, если есть
        if let cahcedImage = self.getCachedImage(from: url) {
            DispatchQueue.main.async {
                complition(cahcedImage)
            }
            return
        }
        
        // Если изображения в кеше нет, то гризим его из сети
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
//                print("NETWORKING ERROR")
                return
            }
            
//            guard url == response.url else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    complition(image)
                }
            }
            
            // Сохраняем изображение в кеш
            self.saveDataToCache(with: data, and: response)
            
        }.resume()
    }
    
    
    // MARK: - Caching methods
    private func getCachedImage(from url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
//            print("GOT Image from Chache \(urlRequest)")
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveDataToCache(with data: Data, and reponse: URLResponse) {
        guard let urlResponse = reponse.url else { return }
        let urlRequest = URLRequest(url: urlResponse)
        let cachedResponse = CachedURLResponse(response: reponse, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
//        print("Saved Image in Cache \(urlRequest)")
    }
    
    
}
