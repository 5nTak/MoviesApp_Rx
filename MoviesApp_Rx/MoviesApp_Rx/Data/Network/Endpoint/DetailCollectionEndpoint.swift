//
//  DetailCollectionEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/26/24.
//

import Foundation

struct DetailCollectionEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = DetailCollectionListResponse
    
    var path: String = ""
    var queries: [String : String]
    
    init(id: Int) {
        self.path = "/collection/\(id)"
        self.queries = [:]
    }
}
