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
    private let favoritesManager = FavoritesManager()
    private let searchUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    var email: String
    
    init(email: String, searchUseCase: SearchUseCase) {
        self.email = email
        self.searchUseCase = searchUseCase
    }
    
    func showLogin() {
        coordinator?.showLogin()
    }
    
    func setSections() {
        setProfile()
        setStar()
        showSetting()
        
        Observable.combineLatest(profileSection, starSection, settingSection)
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
    
    private func setProfile() {
        let profileItems: [AccountSectionItem] = [.profile(email: self.email)]
        let section = AccountSection(model: MyInfoSection.profile.description, items: profileItems)
        profileSection.accept([section])
    }
    
    private func setStar() {
        favoritesManager.getFavoriteMovies()
            .subscribe(onSuccess: { [weak self] movieIds in
                guard let self = self else { return }
                movieIds.forEach { id in
                    self.loadStar(id: id)
                }
            }, onFailure: { error in
                print("Error fetching favorite movies: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func loadStar(id: Int) {
        searchUseCase.fetchSearchMovie(id: id)
            .asObservable()
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                var currentItems = self.starSection.value
                currentItems.append(.star(movie: movie))
                self.starSection.accept(currentItems)
            })
            .disposed(by: disposeBag)
    }
    
    private func showSetting() {
        let settingItems: [AccountSectionItem] = [.setting(option: "Logout")]
        let section = AccountSection(model: MyInfoSection.setting.description, items: settingItems)
        settingSection.accept([section])
    }
}
