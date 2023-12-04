//
//  Endpoint.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import Foundation

protocol APIEndpoint {
    associatedtype APIResponse: Decodable

    var method: HTTPMethod { get }
    var baseUrl: URL? { get }
    var path: String { get }
    var url: URL? { get }
    var headers: [String: String]? { get }
    var queries: [String: String] { get }
}

extension APIEndpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var url: URL? {
        guard let url = self.baseUrl?.appendingPathComponent(self.path) else {
            return nil
        }
        var urlComponents = URLComponents(string: url.absoluteString)
        let urlQuries = self.queries.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        urlComponents?.queryItems = urlQuries

        return urlComponents?.url
    }

    var urlReqeust: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }
}
