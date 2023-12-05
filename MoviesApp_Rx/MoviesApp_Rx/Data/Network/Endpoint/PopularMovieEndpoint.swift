//
//  PopularMovieEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/12/04.
//

import Foundation

struct PopularMovieEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse

    var path: String = "/movie/popular"
    var queries: [String: String]
    
    init(page: Int) {
        self.queries = [
            "page": "\(page)"
        ]
    }
}
