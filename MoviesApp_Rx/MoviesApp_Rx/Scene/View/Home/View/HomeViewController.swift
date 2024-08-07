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

final class HomeViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.identifier)
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCell.identifier)
        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCollectionHeaderView.identifier)
        return collectionView
    }()
    
    var viewModel: HomeViewModel?
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<MovieSectionModel>?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        viewModel?.showMoviesRx()
        bind()
        didSelectMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.title = "Home"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func bind() {
        if let dataSource = rxDataSource {
            viewModel?.sections
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    private func didSelectMovies() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let movie = self?.rxDataSource?.sectionModels[indexPath.section].items[indexPath.item] else { return }
                self?.viewModel?.coordinator?.detailFlow(with: movie, title: movie.title, movieId: movie.id)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CompositionalLayout
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = MovieListSection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .discover:
                return self.createDiscoverSection()
            case .popular:
                return self.createPopularSection()
            case .trending:
                return self.createTrendingSection()
            case .latest:
                return self.createPopularSection()
            }
        }
        return layout
    }
    
    private func createDiscoverSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .fractionalWidth(1/3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createPopularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createTrendingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/3)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.85),
            heightDimension: .fractionalWidth(0.8)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    // MARK: - SectionHeader
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(70)
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
    private func configureHierarchy() {
        collectionView.backgroundColor = .secondarySystemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<MovieSectionModel>(
            configureCell: { rxDataSource, collectionView, indexPath, item in
                switch indexPath.section {
                case 0:
                    guard let discoverCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PreviewCell.identifier,
                        for: indexPath
                    ) as? PreviewCell else { return UICollectionViewCell() }
                    discoverCell.setup(title: item.title)
                    if item.backdropPath == nil {
                        discoverCell.setFailedLoadImage()
                    } else {
                        discoverCell.loadImage(url: item.backdropPath ?? "")
                    }
                    return discoverCell
                case 1:
                    guard let popularCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PosterCell.identifier,
                        for: indexPath
                    ) as? PosterCell else { return UICollectionViewCell() }
                    popularCell.setup(title: item.title)
                    if item.posterPath == nil {
                        popularCell.setFailedLoadImage()
                    } else {
                        popularCell.loadImage(url: item.posterPath ?? "")
                    }
                    return popularCell
                case 2:
                    guard let trendingCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TrendingCell.identifier,
                        for: indexPath
                    ) as? TrendingCell else { return UICollectionViewCell() }
                    trendingCell.setup(title: item.title, popularity: item.popularity, date: item.releaseData)
                    if item.posterPath == nil {
                        trendingCell.setFailedLoadImage()
                    } else {
                        trendingCell.loadImage(url: item.posterPath ?? "")
                    }
                    return trendingCell
                case 3:
                    guard let latestCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PosterCell.identifier,
                        for: indexPath
                    ) as? PosterCell else { return UICollectionViewCell() }
                    latestCell.setup(title: item.title)
                    if item.posterPath == nil {
                        latestCell.setFailedLoadImage()
                    } else {
                        latestCell.loadImage(url: item.posterPath ?? "")
                    }
                    return latestCell
                default:
                    return UICollectionViewCell()
                }
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
    case discover, popular, trending, latest

    var description: String {
        switch self {
        case .discover:
            return "Discover"
        case .popular:
            return "Popular"
        case .trending:
            return "Trending"
        case .latest:
            return "Latest"
        }
    }
}
