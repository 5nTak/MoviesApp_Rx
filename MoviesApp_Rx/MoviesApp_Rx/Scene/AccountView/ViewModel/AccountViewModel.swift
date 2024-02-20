//
//  AccountViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/07.
//

import Foundation

enum AccountViewString: String {
    case id = "ID"
    case password = "Password"
    case login = "로그인"
    case loginResult = "로그인 결과"
    case inputError = "입력 확인"
}

final class AccountViewModel {
    var coordinator: AccountCoordinator?
}
