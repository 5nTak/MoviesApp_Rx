//
//  DetailCollectionResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/26/24.
//

import Foundation

struct DetailCollectionResponse: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension DetailCollectionResponse {
    func toDetailCollection() -> DetailCollection {
        return DetailCollection(
            id: self.id,
            title: self.title,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            overview: self.overview,
            mediaType: self.mediaType,
            popularity: self.popularity,
            releaseDate: self.releaseDate,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}
