//
//  RecentlyViewedMoviesManager.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/18/24.
//

import FirebaseFirestore
import FirebaseAuth
import RxSwift

final class RecentlyViewedMoviesManager {
    static let shared = RecentlyViewedMoviesManager()
    
    var recentlyMovies = BehaviorSubject<[Int]>(value: [])
    private let db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    private let disposeBag = DisposeBag()
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.observeRecently()
        }
    }
    
    func observeRecently() {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").document(userId).collection("recentlyViewed")
                .order(by: "timestamp", descending: true)
                .rx.observeSnapshot()
                .map { snapshot in
                    return snapshot.documents
                        .compactMap { $0.documentID }
                        .compactMap { Int($0) }
                }
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] movieIds in
                    self?.recentlyMovies.onNext(movieIds)
                }, onError: { error in
                    print("Error observing favorites: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            let recentlyViewed = userDefaults.array(forKey: "recentlyViewedMovies") as? [Int] ?? []
            recentlyMovies.onNext(recentlyViewed)
        }
    }
    
    // MARK: - 영화 추가 함수
    func addRecentlyViewed(movieId: Int) {
        if Auth.auth().currentUser?.uid != nil {
            addMovieToFirestore(movieId: movieId)
        } else {
            addMovieToUserDefaults(movieId: movieId)
        }
    }
    
    private func addMovieToFirestore(movieId: Int) {
        if let userId = Auth.auth().currentUser?.uid {
            let timestamp = Timestamp(date: Date())
            self.db.collection("users").document(userId).collection("recentlyViewed").document("\(movieId)").setData(["timestamp": timestamp]) { error in
                if let error = error {
                    print(error)
                } else {
                    print(self.db.collection("users").document(userId).collection("recentlyViewed"))
                }
            }
        }
    }
    
    private func addMovieToUserDefaults(movieId: Int) {
        var recentlyViewed = userDefaults.array(forKey: "recentlyViewedMovies") as? [Int] ?? []
        
        if let index = recentlyViewed.firstIndex(of: movieId) {
            recentlyViewed.remove(at: index)
        }
        
        recentlyViewed.insert(movieId, at: 0)
        
        if recentlyViewed.count > 20 {
            recentlyViewed.removeLast()
        }
        
        userDefaults.set(recentlyViewed, forKey: "recentlyViewedMovies")
        recentlyMovies.onNext(recentlyViewed)
    }
    
    // MARK: - 영화 삭제 함수
    func deleteMovies(movieIds: [Int]) {
        if let userId = Auth.auth().currentUser?.uid {
            deleteMoviesFromFirestore(movieIds: movieIds)
        } else {
            deleteMoviesFromUserDefaults(movieIds: movieIds)
        }
    }
    
    private func deleteMoviesFromFirestore(movieIds: [Int]) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let batch = db.batch()
        for movieId in movieIds {
            let movieRef = db.collection("users").document(userId).collection("recentlyViewed").document("\(movieId)")
            batch.deleteDocument(movieRef)
        }
        batch.commit { error in
            if let error = error {
                print("Error deleting movies: \(error)")
            } else {
                print("Movies successfully deleted from Firestore.")
            }
        }
    }
    
    private func deleteMoviesFromUserDefaults(movieIds: [Int]) {
        var recentlyViewed = userDefaults.array(forKey: "recentlyViewedMovies") as? [Int] ?? []
        recentlyViewed.removeAll { movieIds.contains($0) }
        userDefaults.set(recentlyViewed, forKey: "recentlyViewedMovies")
        recentlyMovies.onNext(recentlyViewed)
    }
}

extension Reactive where Base: Query {
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
