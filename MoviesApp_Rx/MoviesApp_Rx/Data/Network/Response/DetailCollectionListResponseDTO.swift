//
//  DetailCollectionListResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/26/24.
//

import Foundation

struct DetailCollectionListResponse: Decodable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [DetailCollectionResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, parts
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

extension DetailCollectionListResponse {
    func toDetailCollection(detailCollectionResponse: DetailCollectionResponse) -> DetailCollection {
        return DetailCollection(
            id: detailCollectionResponse.id,
            title: detailCollectionResponse.title,
            posterPath: detailCollectionResponse.posterPath,
            backdropPath: detailCollectionResponse.backdropPath,
            overview: detailCollectionResponse.overview,
            mediaType: detailCollectionResponse.mediaType,
            popularity: detailCollectionResponse.popularity,
            releaseDate: detailCollectionResponse.releaseDate,
            voteAverage: detailCollectionResponse.voteAverage,
            voteCount: detailCollectionResponse.voteCount
        )
    }
    
    func toDetailCollections() -> [DetailCollection] {
        return self.parts.compactMap { toDetailCollection(detailCollectionResponse: $0) }
    }
    
    func toDetailCollectionList() -> DetailCollectionList {
        return DetailCollectionList(
            id: self.id,
            name: self.name,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            parts: self.toDetailCollections()
        )
    }
}
