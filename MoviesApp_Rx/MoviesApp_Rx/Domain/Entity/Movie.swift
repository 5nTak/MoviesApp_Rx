//
//  Movie.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

struct Movie: Hashable, Contents {
    let uuid = UUID()
    let id: Int
    let title: String
    let originalTitle: String?
    let originalLanguage: String?
    let genreIds: [Int]?
    let adult: Bool?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
}
