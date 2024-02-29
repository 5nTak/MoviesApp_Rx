//
//  SearchCollectionEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import Foundation

struct SearchCollectionEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = CollectionListResponse
    
    var path: String = "/search/collection"
    var queries: [String : String]
    
    init(searchText: String) {
        self.queries = [
            "query": "\(searchText)"
        ]
    }
}
