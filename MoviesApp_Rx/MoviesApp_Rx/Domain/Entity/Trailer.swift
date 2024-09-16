//
//  Trailer.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import Foundation

struct Trailer {
    let id: Int
    let results: [Video]
}

struct Video {
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let publishedAt: String
}
