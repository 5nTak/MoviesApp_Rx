//
//  FavoritesManager.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/9/24.
//

import FirebaseFirestore
import RxSwift
import FirebaseAuth

final class FavoritesManager {
    private let db = Firestore.firestore()
    
    func getUserId() -> Single<String> {
        return Single.create { single in
            if let userId = Auth.auth().currentUser?.uid {
                single(.success(userId))
            } else {
                single(.failure(NSError(domain: "FavoritesManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            }
            return Disposables.create()
        }
    }
    
    func addFavoriteMovie(movieId: Int) -> Completable {
        return getUserId().flatMapCompletable { userId in
            return Completable.create { completable in
                self.db.collection("users").document(userId).collection("favorites").document("\(movieId)").setData([:]) { error in
                    if let error = error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    func removeFavoriteMovie(movieId: Int) -> Completable {
        return getUserId().flatMapCompletable { userId in
            return Completable.create { completable in
                self.db.collection("users").document(userId).collection("favorites").document("\(movieId)").delete() { error in
                    if let error = error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    func isFavoriteMovie(movieId: Int) -> Single<Bool> {
        return getUserId().flatMap { userId in
            return Single.create { single in
                self.db.collection("users").document(userId).collection("favorites").document("\(movieId)").getDocument { document, error in
                    if let document = document, document.exists {
                        single(.success(true))
                    } else {
                        single(.success(false))
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    func getFavoriteMovies() -> Single<[Int]> {
        return getUserId().flatMap { userId in
            return Single.create { single in
                self.db.collection("users").document(userId).collection("favorites").getDocuments { querySnapshot, error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        let movieIds = querySnapshot?.documents.compactMap { Int($0.documentID) } ?? []
                        single(.success(movieIds))
                    }
                }
                return Disposables.create()
            }
        }
    }
}
