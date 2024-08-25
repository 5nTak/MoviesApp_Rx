//
//  ReviewsEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/24/24.
//

import Foundation

struct ReviewsEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = ReviewsResponse

    var path: String = ""
    var queries: [String: String]
    
    init(id: Int) {
        self.path = "/movie/\(id)/reviews"
        self.queries = [:]
    }
}
