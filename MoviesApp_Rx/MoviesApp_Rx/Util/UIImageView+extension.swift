//
//  UIImageView+extension.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/12/04.
//

import UIKit
import Kingfisher

extension UIImageView {
    var cornerImageProcessor: RoundCornerImageProcessor {
        return RoundCornerImageProcessor(cornerRadius: 20)
    }
    var imageSize: String {
        return "/w500"
    }
    var imageBaseUrl: String {
        return "https://image.tmdb.org/t/p"
    }
    
    func setImageCache(with urlString: String) {
        ImageCache.default.retrieveImage(
            forKey: urlString,
            options: nil) { result in
                switch result {
                case .success(let value):
                    if let image = value.image {
                        self.image = image
                    } else {
                        guard let url = URL(string: urlString) else { return }
                        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                        self.kf.setImage(with: resource)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
