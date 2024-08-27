//
//  CreditEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import Foundation

struct CreditEndpoint: TmdbAPIEndpoint {
    typealias APIResponse = CreditResponse
    
    var path: String = ""
    var queries: [String: String]
    
    init(id: Int) {
        self.path = "/movie/\(id)/credits"
        self.queries = [:]
    }
}
