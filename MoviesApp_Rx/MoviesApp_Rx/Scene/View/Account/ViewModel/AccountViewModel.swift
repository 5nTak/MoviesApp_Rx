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
    case login = "Login"
    case loginResult = "Result"
    case inputError = "Check input value"
    case successLogin = "Success !!"
    case join = "Join"
    case findPassword = "Find password"
}

final class AccountViewModel {
    var coordinator: AccountCoordinator?
}
