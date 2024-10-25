# MoviesApp

## 목차

- [프로젝트 소개](#프로젝트-소개)
- [기술 스택](#기술-스택)
- [브랜치별 기능](#브랜치별-기능)
- [구현](#구현)

---

## 프로젝트 소개

영화 정보 검색 및 즐겨찾기 기능을 통해 나만의 영화 목록을 가지는 앱입니다.

## 기술 스택

- MVVM, Clean Architecture, Coordinator, Compositional Layout, RxSwift, Firebase, FireStore

---

## 브랜치별 기능

### Network
네트워크 요청을 관리하기 위한 Network Layer 구축.
- 재사용성, 유연성, 반응형 프로그래밍 지원을 목표로 설계.
- URLSession 기반의 비동기 네트워크 통신을 쉽게 확장하고 유지할 수 있도록 구성.
- 다양한 API 요청에 쉽게 확장될 수 있도록 설계.
  - request의 헤더나 파라미터 등의 설정을 유연하게 변경 가능.
  - 필요에 따라 APIEndpoint 프로토콜을 채택한 새로운 Endpoint 정의, DefaultNetworkProvider를 확장하여 request 처리 가능.
- **의존성 역전 원칙(DIP)** 을 지키면서, 각 구성 요소가 명확히 분리되도록 설계.
### NetworkProvider
```swift
protocol NetworkProvider {
    var session: URLSession { get }
    func request<T: APIEndpoint>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void
    ) -> URLSessionTask?
}
```
- NetworkProvider: 실제 네트워크 요청을 처리하고, 응답을 디코딩하는 역할.
```swift
final class DefaultNetworkProvider: NetworkProvider {
    let session: URLSession = .shared
    
    func request<T: APIEndpoint>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void
    ) -> URLSessionTask? {
        guard let urlRequest = request.urlReqeust else {
            completion(.failure(.invalidRequest))
            return nil
        }
        
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            ///... 에러처리            
            do {
                let decoded = try JSONDecoder().decode(T.APIResponse.self, from: data)
                completion(.success(decoded))
                return
            } catch let error {
                completion(.failure(.parsingError(description: error.localizedDescription, data: data)))
                return
            }
        }
        task.resume()
        
        return task
    }
}
```
- DefaultNetworkProvider
  - NetworkProvider를 구체적으로 구현하고, 내부적으로 URLSession을 사용하여 네트워크 통신 수행.
  - 기본적으로 클로저 기반의 비동기 네트워크 요청을 처리.
```swift
extension DefaultNetworkProvider: ReactiveCompatible { }

extension Reactive where Base: DefaultNetworkProvider {
    func request<T: APIEndpoint>(_ request: T) -> Single<T.APIResponse> {
        return Single.create { single in
            let task = self.base.request(request) { result in
                switch result {
                case .success(let response):
                    single(.success(response))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
```
-  RxSwift의 Single 타입으로 네트워크 요청을 쉽게 사용할 수 있으며, Observable 패턴을 활용해 데이터를 구독하고, 응답을 처리. 이를 통해 네트워크 요청과 UI 업데이트를 자연스럽게 결합할 수 있음.

---

### Home
- Grid / Expand switch layout
    
    <img src="https://github.com/user-attachments/assets/39486b81-b9c0-48c5-9bf9-3d5d2f50d138" width="300">
    
- Star(즐겨찾기) 기능 (로그인상태일 경우로 제한)
  - [FavoriteManager](#favoritesmanager)를 사용하여 즐겨찾기한 영화들을 관리.
	-	즐겨찾기 기능은 로그인한 사용자에게만 제공.
    <img src="https://github.com/user-attachments/assets/4894ebe4-a777-4d3a-9cab-a0fdacb653fe" width="300">
- CALayer, BazierPath으로 커스텀 뷰 구현 경험
  - 영화 상세 화면의 TopPoster섹션에서 BackgroundImage와 PosterImage, 다른 섹션과의 구분을 고려한 Custom View 구현.
    <img width="300" src="https://github.com/user-attachments/assets/97ec277f-48ac-4acf-8217-d3dbabed64cf">
    <img width="450" src="https://github.com/user-attachments/assets/7391c29e-328f-4593-8210-232dfc299b98">
- YoutubePlayer 라이브러리 채용
  - YouTubePlayer 라이브러리를 이용하여 영화 트레일러를 앱 내에서 재생할 수 있도록 구성.
    
    <img alt="YoutubePlayer" src="https://github.com/user-attachments/assets/0e57815b-4708-4420-b04b-58d8d09a5b0c" width="300">
    
  > WebView와 고민한 점 <br>
  > 웹 기반 콘텐츠를 앱 내에서 제공하기 위해 WebView와 네이티브 비디오 플레이어 중 고민 -> 퍼포먼스와 UI 일관성 측면에서 네이티브 플레이어를 채택.

---

### Search
- 검색어 비동기처리
 
  <img src="https://github.com/user-attachments/assets/af42b773-6cf9-40a1-8d5c-2643438cdd57" width="300">
- [최근 본 영화 (UserDefault, FireStore)](#recentlyviewedmoviesmanager)
  - 저장 기능
    - 영화 상세 화면 진입 시 자동으로 SearchView의 recently섹션에 가장 최근 본 영화 순서대로 정렬되어 업데이트.
      <img src="https://github.com/user-attachments/assets/d15bf4d5-ecc9-4d4e-b041-8e3a28a2f9ad" width="300">

  - 삭제 기능<br>
    <img src="https://github.com/user-attachments/assets/749e19d9-1c85-4947-a86b-e71af1e87886" width="300">

---

### Account
- Firebase 회원가입, 로그인/로그아웃 기능
  
  <img alt="signUp" src="https://github.com/user-attachments/assets/6dddc08b-4f46-4e43-974b-f1bb2349deab" width="300">
  <img alt="signIn/Out" src="https://github.com/user-attachments/assets/320c2daf-81e0-4641-a501-a245a3105e95" width="300">

- Star(즐겨찾기)한 영화 비동기 처리

<img src="https://github.com/user-attachments/assets/fdd085ec-4428-4a18-8322-8e762cb80210" width="300">

---

## 구현
- [디자인패턴](#clean-architecture--mvvm-구조)
- [레이아웃](#compositional-layout)
- [화면 흐름](#coordinator)
- [즐겨찾기(FavoritesManager)](#favoritesmanager)
- [최근 본 영화(RecentlyViewedManager)](#recentlyviewedmoviesmanager)

---

### Clean Architecture + MVVM 구조
  <img width="1000" alt="실행 흐름(CleanArchitecture+MVVM)" src="https://github.com/user-attachments/assets/07072b0f-b3b2-482f-ac7a-5874785a7c7e">

  - 채택 이유
    - 각 레이어가 독립적이기 때문에 기능 확장 시 다른 레이어에 영향을 주지 않고 변경 가능.
    - View와 Model간의 의존성을 줄이고, 데이터 처리와 UI 로직을 분리하여 앱의 복잡성 감소.
    - 네트워크 호출, 데이터 처리, UI 업데이트가 각각 독립적이므로 코드 유지보수성 향상.

---

### Compositional Layout

  - DetailView
    
      <img src="https://github.com/user-attachments/assets/f2d66338-ca04-4f73-96f5-8bd55ce4fc08" width="300">

    - TopPoster section: 영화 포스터 및 배경 이미지.
    - Title section: 영화 제목 및 평점.
    - ExploreMovie section: 리뷰, 트레일러, 크레딧, 비슷한 영화 추천.
    - MovieInfo section: 장르, 개봉일자.
    - Overview section: 영화 개요.
      
  - CreditsView

    <img src="https://github.com/user-attachments/assets/4b927df5-fcd5-4be2-89de-352271ae3dcd" width="300">

    - 영화의 크레딧 정보를 Cast(출연진)와 Crew(제작진)으로 나누어 섹션 형태로 보여주며, 이 섹션들은 사용자가 확장 및 축소할 수 있도록 설계.
    - RxDataSources의 SectionModelType의 Item으로 사용한 CreditsSectionItem의 case로 parent(String)를 추가하여 상위 섹션으로 각각의 섹션의 이름을 표시하도록 설계.
      ```swift
      enum CreditsSectionItem {
        case parent(String)  // 상위 섹션 (Cast, Crew 표시)
        case cast(Cast)      // 출연진 정보 (이름, 역할)
        case crew(Crew)      // 제작진 정보 (이름, 직책)
      }
      ```

    - parent섹션(Cast/Crew): 각 섹션은 하나의 셀로 표현되며, parent섹션을 클릭하면 해당 섹션을 토글시켜 UI에 반영.
    - Cast/Crew섹션: 3열 Grid형태로 출연진과 제작진 정보를 표시하며, 확장된 상태에서만 표시.
      ```swift
      collectionView.rx.modelSelected(CreditsSectionItem.self)
        .subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            switch item {
            case .parent(let title):
                self.viewModel.toggleSectionVisibility(sectionTitle: title)
            default:
                break
            }
        })
        .disposed(by: disposeBag)

      func toggleSectionVisibility(sectionTitle: String) {
        if sectionTitle == "Cast" {
            isCastSectionVisible.toggle()
        } else if sectionTitle == "Crew" {
            isCrewSectionVisible.toggle()
        }
        fetchCredits()
      }
      ```
  - SearchView

    <img src="https://github.com/user-attachments/assets/89f84086-1499-4f47-aa94-ca6c4440e0a9" width="300">

    - recentlyMovie section: 최근 본 영화 표시.
    - discover section: 인기/평점 순 영화 추천.
    - genre section: 장르별 영화 목록.
    - movie section(검색 결과): 검색어 기반 영화 검색 결과 표시.
    - collection section(검색 결과): 검색어 기반 컬렉션 검색 결과 표시.
      
  - MyInfoView

    <img src="https://github.com/user-attachments/assets/e6a19fe1-9801-4396-bcd3-92366358b350" width="300">

    - profile section: 로그인 email 및 유저 정보 표시.
    - star section
      - FavoriteManager.favoriteMoviesSubject를 구독하여 즐겨찾기한 영화 ID 목록을 관찰. 해당 ID들을 이용해 영화 상세 정보를 네트워킹으로 받아오고, 영화 포스터와 제목을 표시.
      - 즐겨찾기한 영화가 없다면, 해당 상태를 알리는 Label 표시.
    - setting section: 설정 섹션. 현재는 로그아웃 버튼만 존재하지만, 추후 기능 확장 가능.

---

### Coordinator
<img width="1097" alt="화면 흐름" src="https://github.com/user-attachments/assets/5e10f5ac-c2f1-4380-bd38-bd38e26b3a63">

- 채택 이유
  - 화면 전환 로직을 VC나 VM에서 분리하여, 화면 간 이동을 중앙에서 통합 관리. 코드의 중복을 줄이고, 화면 전환에 대한 책임 구분.
  - 화면 간 의존성 최소화: VC는 화면 전환에 대한 책임이 없으므로, View끼리 서로 직접적인 의존성이 없음. 화면 간 전환 로직이 중앙에 집중되어 유지보수가 용이.
  - 단일 책임 원칙 준수(SRP): Coordinator는 화면 전환이라는 하나의 책임만을 가지므로, VC는 자신의 역할인 UI 처리에만 집중 가능.
  - 새로운 화면을 추가하거나 화면 전환 로직을 변경할 때, 기존의 화면 코드에 거의 영향을 주지 않고 Coordinator만 수정하면 되기 때문에 화면 전환 확장에 대처 용이.
  - 하나의 Coordinator는 여러 화면 간의 전환 로직을 담당하므로, 동일한 화면 전환을 여러 곳에서 사용 가능.(ex. 영화 상세 화면)

---

### FavoritesManager
  - Firebase Firestore와 RxSwift를 활용하여 앱 내에서 유저가 즐겨찾기한 영화 데이터를 실시간으로 관리하는 클래스.
      ```swift
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

        // Firestore에서 유저의 즐겨찾기 데이터를 실시간으로 감시하여, favoriteMoviesSubject를 통해 변경 사항을 방출
        private func observeFavorites() {
            if Auth.auth().currentUser != nil {
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
        }

        // 즐겨찾기 추가 (상세 화면의 star버튼 tap)
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
      
       // 즐겨찾기 제거 (상세 화면의 star버튼 tap)
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
      
        // 상세 화면 진입 시 해당 영화가 즐겨찾기 목록에 포함되어 있는지 확인
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
      ```
    - Firestore를 활용하여 유저별 즐겨찾기 목록을 관리.
	  - BehaviorSubject를 사용하여 즐겨찾기 영화 ID 목록을 구독하고 실시간으로 변동 사항을 반영.
    - 로그인 상태에서 영화 목록을 즐겨찾기에 추가하거나 삭제할 수 있으며, 즐겨찾기 목록은 Firebase Firestore에서 실시간으로 반영되고 관리.
    - FavoriteManager는 singleton패턴을 사용하여 앱 전역적으로 하나의 인스턴스를 유지.
  - Firestore의 DocumentReference 및 CollectionReference를 RxSwift에서 쉽게 사용할 수 있도록 확장.
    ```swift
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
    ```

---

### RecentlyViewedMoviesManager
- 최근에 본 영화를 관리하는 singleton 객체.
```swift
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

    // 가장 최근에 본 영화 순서대로 정렬
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
    
    // MARK: - 추가
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
    
    // MARK: - 삭제
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
```
- 오프라인 및 온라인에 따른 데이터 관리
  - 로그인 상태: Firestore를 통해 클라우드 기반의 영화 목록을 관리.
  - 로그아웃 상태: UserDefaults를 통해 로컬 저장소에 영화를 저장.
- BehaviorSubject와 RxSwift를 사용하여 실시간으로 데이터의 변화를 감지하고 UI에 즉시 반영.
  - `BehaviorSubject<[Int]>`를 통해 영화 ID 배열을 스트림으로 관리하며, 뷰모델이나 뷰컨트롤러에서 이를 구독하여 영화 목록이 업데이트될 때마다 UI를 자동으로 갱신.
- timeStamp 사용으로 최근 본 순으로 정렬.
- 최근 본 영화 목록은 최대 20개까지 관리되며, 오래된 영화는 자동으로 제거되어 메모리 사용을 절약.

---

### 기타 구현
  - VoteAverageView
    
    <img src="https://github.com/user-attachments/assets/54ebdf2c-1203-454c-a58f-f86899d185de" width="300">
    
    - 영화의 평균 평점을 시각적으로 보여주는 컴포넌트.
    
  - LoginTextField

    <img src="https://github.com/user-attachments/assets/50740982-5598-42a2-b874-59b24ea6da84" width="300">
    
    - 로그인 화면에서 사용자 입력을 받는 커스텀 텍스트 필드.
    - 잘못된 입력 검증 및 경고 애니메이션 구현.
