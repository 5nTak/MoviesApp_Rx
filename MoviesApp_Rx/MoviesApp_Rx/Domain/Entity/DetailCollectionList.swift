//
//  DetailCollectionList.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/26/24.
//

import Foundation

struct DetailCollectionList: Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [DetailCollection]
}
