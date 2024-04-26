//
//  DetailCollection.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/26/24.
//

import Foundation

struct DetailCollection: Hashable {
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
}
