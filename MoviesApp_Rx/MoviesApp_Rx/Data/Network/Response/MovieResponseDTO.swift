//
//  MovieResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

struct MovieResponse: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, video, adult, popularity
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieResponse {
    func toMovie() -> Movie {
        return Movie(
            id: self.id,
            title: self.title,
            originalTitle: self.originalTitle,
            originalLanguage: self.originalLanguage,
            genreIds: self.genreIds,
            adult: self.adult,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            releaseDate: self.releaseDate,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            popularity: self.popularity
        )
    }
}
