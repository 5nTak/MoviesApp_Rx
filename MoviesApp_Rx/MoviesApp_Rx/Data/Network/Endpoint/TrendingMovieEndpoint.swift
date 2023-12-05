//
//  TrendingMovieEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/12/05.
//

import Foundation

struct TrendingMovieEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse
    
    var path: String = "/trending/movie/day"
    var queries: [String : String]
    
    init() {
        self.queries = [:]
    }
}
