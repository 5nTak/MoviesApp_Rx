//
//  NetworkProvider.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import Foundation

protocol NetworkProvider {
    var session: URLSession { get }
    func request<T: APIEndpoint>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void
    ) -> URLSessionTask?
}
