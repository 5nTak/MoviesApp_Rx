//
//  NetworkError.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case serverError(description: String)
    case invalidResponse
    case invalidStatusCode(Int, data: Data)
    case invalidData
    case parsingError(description: String, data: Data)
}
