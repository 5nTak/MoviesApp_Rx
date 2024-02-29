//
//  SearchMovieEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation

struct SearchMovieEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse
    
    var path: String = "/search/movie"
    var queries: [String : String]
    
    init(searchText: String) {
        self.queries = [
            "query": "\(searchText)"
        ]
    }
}
