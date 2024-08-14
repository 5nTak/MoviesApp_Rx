//
//  GenreResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/14/24.
//

import Foundation

struct GenresResponse: Decodable {
    let genres: [GenreResponse]
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
    
    func toGenre(genreResponse: GenreResponse) -> Genre {
        return Genre(
            id: genreResponse.id,
            name: genreResponse.name
        )
    }
    
    func toGenres() -> [Genre] {
        return self.genres.compactMap { toGenre(genreResponse: $0) }
    }
}

struct GenreResponse: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    func toGenre() -> Genre {
        return Genre(id: self.id, name: self.name)
    }
}
