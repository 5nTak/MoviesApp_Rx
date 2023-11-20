//
//  DefaultNetworkProvider.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import Foundation

final class DefaultNetworkProvider: NetworkProvider {
    let session: URLSession = .shared
    
    func request<T: APIEndpoint>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void
    ) -> URLSessionTask? {
        guard let urlRequest = request.urlReqeust else {
            completion(.failure(.invalidRequest))
            return nil
        }
        
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(description: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode(response.statusCode, data: data)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.APIResponse.self, from: data)
                completion(.success(decoded))
                return
            } catch let error {
                completion(.failure(.parsingError(description: error.localizedDescription, data: data)))
                return
            }
        }
        task.resume()
        
        return task
    }
}
