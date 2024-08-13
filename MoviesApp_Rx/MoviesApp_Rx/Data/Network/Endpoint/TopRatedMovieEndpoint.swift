//
//  TopRatedMovieEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/11/24.
//

import Foundation

struct TopRatedMovieEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse

    var path: String = "/movie/top_rated"
    var queries: [String: String]
    
    init(page: Int) {
        self.queries = [
            "page": "\(page)"
        ]
    }
}
