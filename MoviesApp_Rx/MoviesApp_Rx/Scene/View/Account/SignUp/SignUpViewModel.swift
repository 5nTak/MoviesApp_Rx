//
//  SignUpViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 6/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewModel {
    weak var coordinator: SignUpCoordinator?
    private let db = Firestore.firestore()
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let userId = authResult?.user.uid {
                self.db.collection("users").document(userId).setData(["email": email]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(userId))
                    }
                }
            } else {
                completion(.failure(NSError(domain: "SignUp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }
    }
}
