//
//  SignUpViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 6/28/24.
//

import Foundation
import FirebaseAuth

final class SignUpViewModel {
    weak var coordinator: SignUpCoordinator?
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
