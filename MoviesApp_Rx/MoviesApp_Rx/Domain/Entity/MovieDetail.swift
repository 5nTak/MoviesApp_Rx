//
//  MovieDetail.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/31/24.
//

import Foundation

struct MovieDetail: Hashable, Contents {
    let id: Int
    let title: String
    let genres: [Genre]?
    let adult: Bool?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
}
