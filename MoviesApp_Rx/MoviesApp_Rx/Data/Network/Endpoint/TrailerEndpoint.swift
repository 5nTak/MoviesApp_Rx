//
//  TrailerEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import Foundation

struct TrailersEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = TrailerResponse

    var path: String = ""
    var queries: [String: String]
    
    init(id: Int) {
        self.path = "/movie/\(id)/videos"
        self.queries = [:]
    }
}
