//
//  MyInfoViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum AccountSectionItem {
    case profile(email: String)
    case star(movie: Movie)
    case setting(option: String)
}

struct AccountSectionModel {
    var title: String
    var items: [Item]
}

extension AccountSectionModel: SectionModelType {
    typealias Item = AccountSectionItem
    
    init(original: AccountSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class MyInfoViewModel {
    var coordinator: AccountCoordinator?
    
    typealias AccountSection = SectionModel<String, AccountSectionItem>
    
    let sections = BehaviorRelay<[AccountSectionModel]>(value: [])
    private let profileSection = BehaviorRelay<[AccountSection]>(value: [])
    private let starSection = BehaviorRelay<[AccountSectionItem]>(value: [])
    private let settingSection = BehaviorRelay<[AccountSection]>(value: [])
    private let favoritesManager = FavoritesManager.shared()
    private let searchUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    var email: String
    
    init(email: String, searchUseCase: SearchUseCase) {
        self.email = email
        self.searchUseCase = searchUseCase
        self.bindFavorites()
        self.setSections()
    }
    
    func showLogin() {
        coordinator?.showLogin()
    }
    
    func setSections() {
        self.setProfile()
        self.showSetting()
        
        Observable.combineLatest(profileSection, starSection, settingSection)
            .observe(on: MainScheduler.instance)
            .map { profile, star, setting in
                return [
                    AccountSectionModel(title: MyInfoSection.profile.description, items: profile.flatMap { $0.items }),
                    AccountSectionModel(title: MyInfoSection.star.description, items: star),
                    AccountSectionModel(title: MyInfoSection.setting.description, items: setting.flatMap { $0.items })
                ]
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
    
    private func bindFavorites() {
        favoritesManager.favoriteMoviesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieIds in
                self?.fetchStarSection(movieIds: movieIds)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchStarSection(movieIds: [Int]) {
        var starItems = [AccountSectionItem]()
        let fetchGroup = DispatchGroup()
        
        movieIds.forEach { id in
            fetchGroup.enter()
            searchUseCase.fetchSearchMovie(id: id)
                .asObservable()
                .subscribe(onNext: { movie in
                    starItems.append(.star(movie: movie))
                    fetchGroup.leave()
                }, onError: { _ in
                    fetchGroup.leave()
                })
                .disposed(by: disposeBag)
        }
        
        fetchGroup.notify(queue: .main) { [weak self] in
            self?.starSection.accept(starItems)
            self?.setSections()
        }
    }
    
    private func setProfile() {
        let profileItems: [AccountSectionItem] = [.profile(email: self.email)]
        let section = AccountSection(model: MyInfoSection.profile.description, items: profileItems)
        profileSection.accept([section])
    }
    
    private func showSetting() {
        let settingItems: [AccountSectionItem] = [.setting(option: "Logout")]
        let section = AccountSection(model: MyInfoSection.setting.description, items: settingItems)
        settingSection.accept([section])
    }
}
