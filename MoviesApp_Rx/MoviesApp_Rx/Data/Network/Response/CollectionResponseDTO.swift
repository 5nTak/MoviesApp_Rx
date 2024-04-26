//
//  CollectionResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/24.
//

import Foundation

struct CollectionResponse: Decodable {
    let id: Int
    let name: String
    let originalLanguage: String?
    let adult: Bool?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, adult
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

extension CollectionResponse {
    func toCollection() -> Collection {
        return Collection(
            id: self.id,
            name: self.name,
            originalLanguage: self.originalLanguage,
            adult: self.adult,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath
        )
    }
}
