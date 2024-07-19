//
//  AccountViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/07.
//

import Foundation
import FirebaseAuth

final class AccountViewModel {
    var coordinator: AccountCoordinator?
    
    func join() {
        coordinator?.showSignUp()
    }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
