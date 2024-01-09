//
//  HomeDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import UIKit

final class DetailViewModel {
    var updateUI: (() -> Void)?
    
    var title: String?
    var posterView: UIImage?
    var overView: String?
    var releaseDate: String?
    var voteAverage: Double?
    var voteCount: Int?
    
    func fetchData() {
        
    }
    
    private func updateUIWithData(_ data: [String: Any]) {
        
    }
}
