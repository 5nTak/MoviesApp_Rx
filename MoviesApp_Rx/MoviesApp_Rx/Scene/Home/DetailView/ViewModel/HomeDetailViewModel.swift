//
//  HomeDetailViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import Foundation
import UIKit

final class DetailViewModel {
    weak var coordinator: DetailCoordinator?
    
    var updateUI: (() -> Void)?
    
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String?
    var posterView: UIImage?
    var overView: String?
    var releaseDate: String?
    var voteAverage: Double?
    var voteCount: Int?
    
    func fetchData(for movie: Movie?) {
        guard let movie = movie else { return }
        
    }
    
    private func updateUIWithData(_ data: [String: Any]) {
        
    }
}
