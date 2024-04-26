//
//  CollectionListResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/24.
//

import Foundation

struct CollectionListResponse: Decodable {
    let results: [CollectionResponse]
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case results, page
    }
}

extension CollectionListResponse {
    func toCollection(collectionResponse: CollectionResponse) -> Collection? {
        return Collection(
            id: collectionResponse.id,
            name: collectionResponse.name,
            originalLanguage: collectionResponse.originalLanguage,
            adult: collectionResponse.adult,
            overview: collectionResponse.overview,
            posterPath: collectionResponse.posterPath,
            backdropPath: collectionResponse.backdropPath
        )
    }
    
    func toCollections() -> [Collection] {
        return self.results.compactMap { toCollection(collectionResponse: $0) }
    }
    
    func toCollectionList() -> CollectionList {
        return CollectionList(
            results: self.toCollections(),
            page: self.page
        )
    }
}
