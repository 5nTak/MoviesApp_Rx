//
//  HomeViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "Suggest"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionHeaderView.identifier)
        return collectionView
    }()
    
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<MovieSectionModel>?
    
    var viewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configureHierarchy()
        configureDataSource()
        viewModel?.showMoviesRx()
        bind()
        didSelectMovies()
    }
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    private func bind() {
        viewModel?.sections
            .bind(to: collectionView.rx.items(dataSource: rxDataSource!))
            .disposed(by: disposeBag)
    }
    
    private func didSelectMovies() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let movie = self?.rxDataSource?.sectionModels[indexPath.section].items[indexPath.item] else { return }
                self?.viewModel?.coordinator?.detailFlow(with: movie)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CompositionalLayout
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let layoutSectionKind = MovieListSection(rawValue: sectionIndex) else { return nil }
            
            
            let itemWidthSize = (layoutSectionKind == .discover) || (layoutSectionKind == .latest) ? NSCollectionLayoutDimension.fractionalWidth(1.0) : NSCollectionLayoutDimension.fractionalWidth(0.5)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: itemWidthSize,
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupHeight = (layoutSectionKind == .discover) || (layoutSectionKind == .latest) ? NSCollectionLayoutDimension.fractionalWidth(1.0) : NSCollectionLayoutDimension.fractionalHeight(0.35)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: groupHeight
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5)
            
            switch layoutSectionKind {
            case .discover:
                section.orthogonalScrollingBehavior = .paging
            case .popular, .latest, .trending:
                section.orthogonalScrollingBehavior = .continuous
            }
            
            let sectionHeader = self.createSectionHeader()
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return layout
    }
    
    // MARK: - SectionHeader
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return sectionHeader
    }
}

// MARK: - DataSource
extension HomeViewController {
    func configureHierarchy() {
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<MovieSectionModel>(
            configureCell: { rxDataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCell.identifier,
                    for: indexPath
                ) as? HomeCell else { return UICollectionViewCell() }
                cell.setup(title: item.title)
                cell.loadImage(url: item.posterPath ?? "")
                return cell
            },
            configureSupplementaryView: { rxDataSource, collectionView, kind, indexPath in
                let sectionModel = rxDataSource.sectionModels[indexPath.section]
                guard let section = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HomeCollectionHeaderView.identifier,
                    for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
                section.setTitle(title: sectionModel.title)
                return section
            }
        )
    }
}

// MARK: - Section
enum MovieListSection: Int, CaseIterable {
    case discover, popular, latest, trending

    var description: String {
        switch self {
        case .discover:
            return "Discover"
        case .popular:
            return "Popular"
        case .latest:
            return "Latest"
        case .trending:
            return "Trending"
        }
    }
}
