//
//  DefaultNetworkProvider+Rx.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/13.
//

import Foundation
import RxSwift

extension DefaultNetworkProvider: ReactiveCompatible { }

extension Reactive where Base: DefaultNetworkProvider {
    func request<T: APIEndpoint>(_ request: T) -> Single<T.APIResponse> {
        return Single.create { single in
            let task = self.base.request(request) { result in
                switch result {
                case .success(let response):
                    single(.success(response))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
