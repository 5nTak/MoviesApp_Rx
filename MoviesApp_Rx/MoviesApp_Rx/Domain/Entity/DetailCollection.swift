//
//  DetailCollection.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/26/24.
//

import Foundation

struct DetailCollection: Hashable, Contents {
    let uuid = UUID()
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let mediaType: String
    let popularity: Double
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    
    func toMovie() -> Movie {
        return Movie(
            id: self.id,
            title: self.title,
            originalTitle: nil,
            originalLanguage: nil,
            genreIds: nil,
            adult: nil,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            video: nil,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            popularity: self.popularity
        )
    }
}
