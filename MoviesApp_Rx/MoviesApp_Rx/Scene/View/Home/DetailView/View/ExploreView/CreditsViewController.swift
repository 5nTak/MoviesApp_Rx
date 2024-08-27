//
//  CreditsViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class CreditsViewController: UIViewController {
    private let viewModel: CreditsViewModel
    private let disposeBag = DisposeBag()
    
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<CreditsSectionModel>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(CreditParentCell.self, forCellWithReuseIdentifier: CreditParentCell.identifier)
        collectionView.register(CreditsCell.self, forCellWithReuseIdentifier: CreditsCell.identifier)
        return collectionView
    }()
    
    init(viewModel: CreditsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        if let dataSource = rxDataSource {
            viewModel.credits
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
        
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
    }
}

extension CreditsViewController {
    private func configureDataSource() {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<CreditsSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditsCell.identifier, for: indexPath) as? CreditsCell else { return UICollectionViewCell() }
                switch item {
                case .parent(let title):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditParentCell.identifier, for: indexPath) as? CreditParentCell else { return UICollectionViewCell() }
                    let isExpanded = self.viewModel.isSectionExpanded(sectionTitle: title)
                    cell.configure(with: title, expanded: isExpanded)
                    return cell
                case .cast(let casts):
                    cell.setup(profilePath: casts.profilePath ?? "", name: casts.name, role: casts.character)
                case .crew(let crews):
                    cell.setup(profilePath: crews.profilePath ?? "", name: crews.name, role: crews.job)
                }
                return cell
            }
        )
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            if let item = self.rxDataSource?.sectionModels[sectionIndex].items.first {
                switch item {
                case .parent:
                    return self.createParentSectionLayout()
                default:
                    return self.createCreditsLayout()
                }
            }
            return nil
        }
        return layout
    }
    
    private func createParentSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(50))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createCreditsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
