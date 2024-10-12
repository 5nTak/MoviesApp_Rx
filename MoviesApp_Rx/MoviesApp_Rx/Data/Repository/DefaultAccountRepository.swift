//
//  DefaultAccountRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 10/12/24.
//

import Foundation
import RxSwift

final class DefaultAccountRepository: AccountRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchDetailMovie(id: Int) -> Single<MovieDetail> {
        let request = MovieDetailEndpoint(id: id)
        return self.networkProvider.rx.request(request)
            .map { response in
                let movie = response.toMovieDetail()
                return movie
            }
    }
}
