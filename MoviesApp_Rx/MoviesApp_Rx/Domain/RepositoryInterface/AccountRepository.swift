//
//  AccountRepository.swift
//  MoviesApp_Rx
//
//  Created by Tak on 10/12/24.
//

import Foundation
import RxSwift

protocol AccountRepository {
    func fetchDetailMovie(id: Int) -> Single<MovieDetail>
}
