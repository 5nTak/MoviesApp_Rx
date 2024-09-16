//
//  TrailerResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import Foundation

struct TrailerResponse: Decodable {
    let id: Int
    let results: [VideoResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, results
    }
}

struct VideoResponse: Decodable {
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name, key, site, size, type
        case publishedAt = "published_at"
    }
}

extension TrailerResponse {
    func toTrailer() -> Trailer {
        return Trailer(id: self.id, results: toVideos())
    }
    
    func toVideos() -> [Video] {
        return self.results.compactMap { toVideo(videoResponse: $0) }
    }
    
    func toVideo(videoResponse: VideoResponse) -> Video {
        return Video(
            name: videoResponse.name,
            key: videoResponse.key,
            site: videoResponse.site,
            size: videoResponse.size,
            type: videoResponse.type,
            publishedAt: videoResponse.publishedAt
        )
    }
}
