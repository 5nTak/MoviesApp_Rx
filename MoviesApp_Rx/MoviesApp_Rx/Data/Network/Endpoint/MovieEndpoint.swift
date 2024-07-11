//
//  MovieEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/10/24.
//

import Foundation

struct MovieEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieResponse

    var path: String = ""
    var queries: [String: String]
    
    init(id: Int) {
        self.path = "/movie/\(id)"
        self.queries = [:]
    }
}
