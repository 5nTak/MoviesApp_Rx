//
//  ReviewsResponseDTO.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/24/24.
//

import Foundation

struct ReviewsResponse: Decodable {
    let id: Int
    let results: [ReviewResponse]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id, results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct ReviewResponse: Decodable {
    let id: String
    let author: String
    let authorDetails: AuthorResponse
    let content: String
    let createdAt: String
    let updatedAt: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, content, url
        case authorDetails = "author_details"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AuthorResponse: Decodable {
    let name: String
    let username: String
    let avatarPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
    }
}

extension ReviewsResponse {
    func toReviews() -> Reviews {
        return Reviews(
            id: self.id,
            result: self.toReviewList(),
            totalPages: self.totalPages,
            totalResults: self.totalResults
        )
    }
    
    func toReviewList() -> [Review] {
        return self.results.compactMap { toReview(reviewResponse: $0) }
    }
    
    func toReview(reviewResponse: ReviewResponse) -> Review {
        return Review(
            id: reviewResponse.id,
            author: reviewResponse.author,
            authorDetails: toAuthorDetails(authorResponse: reviewResponse.authorDetails),
            content: reviewResponse.content,
            createdAt: reviewResponse.createdAt,
            updatedAt: reviewResponse.updatedAt,
            url: reviewResponse.url
        )
    }
    
    func toAuthorDetails(authorResponse: AuthorResponse) -> Author {
        return Author(
            name: authorResponse.name,
            userName: authorResponse.username,
            avatarPath: authorResponse.avatarPath
        )
    }
}
