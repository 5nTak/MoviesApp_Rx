//
//  Reviews.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/24/24.
//

import Foundation

struct Reviews {
    let id: Int
    let result: [Review]
    let totalPages: Int
    let totalResults: Int
}

struct Review {
    let id: String
    let author: String
    let authorDetails: Author
    let content: String
    let createdAt: String
    let updatedAt: String
    let url: String
}

struct Author {
    let name: String
    let userName: String
    let avatarPath: String?
}
