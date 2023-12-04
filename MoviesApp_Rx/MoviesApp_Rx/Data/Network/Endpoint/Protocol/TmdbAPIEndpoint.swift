//
//  TmdbAPIEndpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/25.
//

import Foundation

protocol TmdbAPIEndpoint: APIEndpoint, TmdbAPISpec { }

protocol TmdbAPISpec { }

extension TmdbAPISpec {
    var baseUrl: URL? {
        return URL(string: "https://api.themoviedb.org/3")
    }
    
//    var key: String {
//        return "93b931d7c44780baea8cfb86bd286b46"
//    }
    var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5M2I5MzFkN2M0NDc4MGJhZWE4Y2ZiODZiZDI4NmI0NiIsInN1YiI6IjY1NWM2NmM5ZDRmZTA0MDBlMWI2NDk2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.eNsVl4Yzs9NKwBL0kO1haWm7vH_6MBmXmXu0mPQBaOM"]
    }
}
