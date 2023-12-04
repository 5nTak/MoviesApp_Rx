//
//  MovieListEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

struct MovieListEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse

    var path: String = "/discover/movie"
    var queries: [String: String]
    
    init(page: Int) {
        self.queries = [
            "page": "\(page)"
        ]
    }
}
