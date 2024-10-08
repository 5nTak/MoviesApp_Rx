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
        return RoundCornerImageProcessor(cornerRadius: 10)
    }
    var imageSize: String {
        return "/w500"
    }
    var imageBaseUrl: String {
        return "https://image.tmdb.org/t/p"
    }
    
    func setImageCache(with urlString: String) {
        self.kf.indicatorType = .activity
        ImageCache.default.retrieveImage(
            forKey: urlString,
            options: [
                .transition(.fade(1.0)),
                .processor(self.cornerImageProcessor),
                .forceTransition
            ]
        ) { result in
                switch result {
                case .success(let value):
                    if let image = value.image {
                        self.image = image
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    } else {
                        guard let url = URL(string: urlString) else { return }
                        self.kf.setImage(with: url, placeholder: UIImage(systemName: "ellipsis"))
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
