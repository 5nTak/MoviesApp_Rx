//
//  UpcomingEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/20/24.
//

import Foundation

struct UpcomingEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = MovieListResponse
    
    var path: String = "/movie/upcoming"
    var queries: [String : String]
    
    init(page: Int) {
        self.queries = [
            "page": "\(page)"
        ]
    }
}
