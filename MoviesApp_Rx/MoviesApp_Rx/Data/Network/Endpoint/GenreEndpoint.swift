//
//  GenreEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/14/24.
//

import Foundation

struct GenreEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = GenresResponse
    
    var path: String = "/genre/movie/list"
    var queries: [String: String]
    
    init() {
        self.queries = [:]
    }
}
