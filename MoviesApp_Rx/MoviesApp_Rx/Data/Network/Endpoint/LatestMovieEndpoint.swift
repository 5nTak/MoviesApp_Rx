//
//  LatestMovieEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/12/10.
//

import Foundation

struct LatestMovieEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieResponse
    
    var path: String = "/movie/latest"
    var queries: [String : String]
    
    init() {
        self.queries = [:]
    }
}
