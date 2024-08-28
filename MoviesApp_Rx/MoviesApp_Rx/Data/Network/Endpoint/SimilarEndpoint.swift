//
//  SimilarEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/28/24.
//

import Foundation

struct SimilarEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse
    
    var path: String = ""
    var queries: [String: String]
    
    init(id: Int, page: Int) {
        self.path = "/movie/\(id)/similar"
        self.queries = [
            "page" : "\(page)"
        ]
    }
}
