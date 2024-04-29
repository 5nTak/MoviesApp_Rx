//
//  Contents.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/27/24.
//

import Foundation

protocol Contents {
    var id: Int { get }
    var overview: String { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
}
