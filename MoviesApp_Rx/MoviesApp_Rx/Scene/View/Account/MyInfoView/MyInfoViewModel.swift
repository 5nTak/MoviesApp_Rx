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

struct AccountSectionModel {
    var title: String
    var items: [Item]
}

extension AccountSectionModel: SectionModelType {
    typealias Item = Any
    
    init(original: AccountSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class MyInfoViewModel {
    var coordinator: AccountCoordinator?
    
    typealias AccountSection = SectionModel<String, Any>
    
    let sections = BehaviorRelay<[AccountSectionModel]>(value: [])
    private let profileSection = BehaviorRelay<[AccountSection]>(value: [])
    private let starSection = BehaviorRelay<[AccountSection]>(value: [])
    private let settingSection = BehaviorRelay<[AccountSection]>(value: [])
    private let disposeBag = DisposeBag()
    
    var email: String
    
    init(email: String) {
        self.email = email
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
                    AccountSectionModel(title: MyInfoSection.profile.description, items: profile),
                    AccountSectionModel(title: MyInfoSection.star.description, items: star),
                    AccountSectionModel(title: MyInfoSection.setting.description, items: setting)
                    ]
            }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
    
    private func setProfile() {
        let profileItems: [Any] = ["User Email: example@example.com"] // 예시 데이터
        let section = AccountSection(model: MyInfoSection.profile.description, items: profileItems)
        profileSection.accept([section])
    }
    
    private func setStar() {
        let starItems: [Any] = ["Favorite Movie 1", "Favorite Movie 2"] // 예시 데이터
        let section = AccountSection(model: MyInfoSection.star.description, items: starItems)
        starSection.accept([section])
    }
    
    private func showSetting() {
        let settingItems: [Any] = ["Logout"]
        let section = AccountSection(model: MyInfoSection.setting.description, items: settingItems)
        settingSection.accept([section])
    }
}
