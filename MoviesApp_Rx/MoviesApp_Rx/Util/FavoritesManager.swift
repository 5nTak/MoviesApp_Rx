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
    private var userId: String
    private let db = Firestore.firestore()
    var favoriteMoviesSubject = BehaviorSubject<[Int]>(value: [])
    private let disposeBag = DisposeBag()
    
    private init(userId: String) {
        self.userId = userId
        self.observeFavorites()
    }
    
    static func shared() -> FavoritesManager {
        guard let userId = Auth.auth().currentUser?.uid else { return FavoritesManager(userId: "") }
        
        let instance = FavoritesManager(userId: userId)

        return instance
    }
    
    private func observeFavorites() {
        db.collection("users").document(self.userId).collection("favorites").rx.observeSnapshot()
            .map { snapshot in
                return snapshot.documents
                    .compactMap { $0.documentID }
                    .compactMap { Int($0) }
            }
            .subscribe(onNext: { [weak self] movieIds in
                self?.favoriteMoviesSubject.onNext(movieIds)
            }, onError: { error in
                print("Error observing favorites: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func addFavoriteMovie(movieId: Int) -> Completable {
        return Completable.create { completable in
            self.db.collection("users").document(self.userId).collection("favorites").document("\(movieId)").setData([:]) { error in
                if let error = error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    func removeFavoriteMovie(movieId: Int) -> Completable {
        return Completable.create { completable in
            self.db.collection("users").document(self.userId).collection("favorites").document("\(movieId)").delete { error in
                if let error = error {
                    completable(.error(error))
                } else {
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    func getFavoriteMovies() -> Observable<[Int]> {
        self.db.collection("users").document(userId).collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                let movieIds = querySnapshot?.documents.compactMap { Int($0.documentID) } ?? []
                self.favoriteMoviesSubject.onNext(movieIds)
            }
        }
        
        return favoriteMoviesSubject
    }
    
    func isFavoriteMovie(movieId: Int) -> Single<Bool> {
        return Single.create { single in
            self.db.collection("users").document(self.userId).collection("favorites").document("\(movieId)").getDocument { document, error in
                if let error = error {
                    single(.failure(error))
                } else if let document = document, document.exists {
                    single(.success(true))
                } else {
                    single(.success(false))
                }
            }
            return Disposables.create()
        }
    }
}

extension Reactive where Base: DocumentReference {
    func observeSnapshot() -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            let listener = self.base.addSnapshotListener { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}

extension Reactive where Base: CollectionReference {
    func observeSnapshot() -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            let listener = self.base.addSnapshotListener { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}
