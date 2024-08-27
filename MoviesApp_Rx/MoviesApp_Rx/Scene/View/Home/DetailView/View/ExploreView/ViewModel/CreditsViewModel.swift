//
//  CreditViewModel.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum CreditsSectionKind: String, CaseIterable {
    case parent = "Credits"
    case cast = "Cast"
    case crew = "Crew"
    
    var description: String {
        return self.rawValue
    }
}

enum CreditsSectionItem {
    case parent(String)
    case cast(Cast)
    case crew(Crew)
}

struct CreditsSectionModel {
    var title: String
    var items: [CreditsSectionItem]
}

extension CreditsSectionModel: SectionModelType {
    typealias Item = CreditsSectionItem
    
    init(original: CreditsSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

final class CreditsViewModel {
    typealias CreditsSection = SectionModel<String, CreditsSectionItem>
    
    private let disposeBag = DisposeBag()
    private let useCase: SearchUseCase
    
    let movieId: Int
    
    let credits = BehaviorRelay<[CreditsSectionModel]>(value: [])
    
    private var isCastSectionVisible = true
    private var isCrewSectionVisible = true
    
    init(movieId: Int, useCase: SearchUseCase) {
        self.movieId = movieId
        self.useCase = useCase
        
        fetchCredits()
    }
    private func fetchCredits() {
            useCase.fetchCredits(id: movieId)
                .asObservable()
                .subscribe(onNext: { [weak self] credit in
                    self?.setupSectionModels(credit: credit)
                })
                .disposed(by: disposeBag)
        }
    
    private func setupSectionModels(credit: Credit) {
        var sections: [CreditsSectionModel] = []
        
        sections.append(CreditsSectionModel(title: CreditsSectionKind.parent.rawValue, items: [.parent(CreditsSectionKind.cast.rawValue)]))
        
        if isCastSectionVisible {
            let castItems = credit.casts.map { CreditsSectionItem.cast($0) }
            sections.append(CreditsSectionModel(title: CreditsSectionKind.cast.rawValue, items: castItems))
        }
        
        sections.append(CreditsSectionModel(title: CreditsSectionKind.parent.rawValue, items: [.parent(CreditsSectionKind.crew.rawValue)]))
        
        if isCrewSectionVisible {
            let crewItems = credit.crews.map { CreditsSectionItem.crew($0) }
            sections.append(CreditsSectionModel(title: CreditsSectionKind.crew.rawValue, items: crewItems))
        }
        
        credits.accept(sections)
    }
    
    func toggleSectionVisibility(sectionTitle: String) {
        if sectionTitle == "Cast" {
            isCastSectionVisible.toggle()
        } else if sectionTitle == "Crew" {
            isCrewSectionVisible.toggle()
        }
        fetchCredits()
    }
    
    func isSectionExpanded(sectionTitle: String) -> Bool {
        if sectionTitle == "Cast" {
            return isCastSectionVisible
        } else if sectionTitle == "Crew" {
            return isCrewSectionVisible
        }
        return false
    }
}
