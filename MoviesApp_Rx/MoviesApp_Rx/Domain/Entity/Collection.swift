//
//  SearchMovie.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/24.
//

import Foundation

struct Collection: Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let originalLanguage: String?
    let adult: Bool?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
}
