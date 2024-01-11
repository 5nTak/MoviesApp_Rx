//
//  HomeViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2023/11/20.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "맞춤 영화"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<MovieListSection, Movie>?
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setCollectionView()
        bind()
        viewModel?.showContents()
    }
    
    func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: starButton)
    }
    
    func bind() {
        viewModel?.discoveredMoviesHandler = { movies in
            self.applySnapshot(movies: movies, section: .discover)
        }
        viewModel?.popularMoviesHandler = { movies in
            self.applySnapshot(movies: movies, section: .popular)
        }
        viewModel?.latestMovieHandler = { movies in
            self.applySnapshot(movies: movies, section: .latest)
        }
        viewModel?.trendingMoviesHandler = { movies in
            self.applySnapshot(movies: movies, section: .trending)
        }
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        configureHierarchy()
        configureDataSource()
        createSections()
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

// MARK: - DiffableDataSource
extension HomeViewController {
    func configureHierarchy() {
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        // cell 합치기 고려
        // MARK: - Cell Registration
        let discoveryCell = UICollectionView.CellRegistration<HomeDiscoveryCell, Movie> { cell, indexPath, movie in
            cell.setup(title: self.viewModel?.discoveredMovies[indexPath.row].title ?? "")
            cell.loadImage(url: self.viewModel?.discoveredMovies[indexPath.row].posterPath ?? "")
        }
        let popularCell = UICollectionView.CellRegistration<HomePopularCell, Movie> { cell, indexPath, movie in
            cell.setup(title: self.viewModel?.popularMovies[indexPath.row].title ?? "")
            cell.loadImage(url: self.viewModel?.popularMovies[indexPath.row].posterPath ?? "")
        }
        let latestCell = UICollectionView.CellRegistration<HomeLatestCell, Movie> { cell, indexPath, movie in
            cell.setup(title: self.viewModel?.latestMovie[0].title ?? "")
            cell.loadImage(url: self.viewModel?.latestMovie[0].posterPath ?? "")
        }
        let trendingCell = UICollectionView.CellRegistration<HomeTrendingCell, Movie> { cell, indexPath, movie in
            cell.setup(title: self.viewModel?.trendingMovies[indexPath.row].title ?? "")
            cell.loadImage(url: self.viewModel?.trendingMovies[indexPath.row].posterPath ?? "")
        }
        dataSource = UICollectionViewDiffableDataSource<MovieListSection, Movie>(collectionView: collectionView) {
            (collectionView, indexPath, movie) -> UICollectionViewCell? in
            switch MovieListSection(rawValue: indexPath.section) {
            case .discover:
                return collectionView.dequeueConfiguredReusableCell(using: discoveryCell, for: indexPath, item: movie)
            case .popular:
                return collectionView.dequeueConfiguredReusableCell(using: popularCell, for: indexPath, item: movie)
            case .latest:
                return collectionView.dequeueConfiguredReusableCell(using: latestCell, for: indexPath, item: movie)
            case .trending:
                return collectionView.dequeueConfiguredReusableCell(using: trendingCell, for: indexPath, item: movie)
            case .none:
                return UICollectionViewCell()
            }
        }
        
        // MARK: - HeaderView Registration
        let headerViewRegistration = UICollectionView.SupplementaryRegistration<HomeCollectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
                guard let section = MovieListSection(rawValue: indexPath.section) else { return }
                supplementaryView.setTitle(title: section.description)
            }
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerViewRegistration, for: indexPath)
        }
    }
    // MARK: - Snapshot Apply
    private func applySnapshot(movies: [Movie], section: MovieListSection) {
        DispatchQueue.main.async {
            guard var snapshot = self.dataSource?.snapshot() else { return }
            
            switch section {
            case .discover:
                snapshot.appendItems(movies, toSection: section)
            case .popular:
                snapshot.appendItems(movies, toSection: section)
            case .latest:
                snapshot.appendItems(movies, toSection: section)
            case .trending:
                snapshot.appendItems(movies, toSection: section)
            }
            self.dataSource?.apply(snapshot)
        }
    }
    
    private func createSections() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieListSection, Movie>()
        MovieListSection.allCases.forEach {
            snapshot.appendSections([$0])
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: - Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        viewModel?.coordinator?.detailFlow(with: movie)
        // 이 곳에 movie 넘겨서 따로 네트워킹 하지 않고 넘긴 정보들 가지고 UI Component 채우기
    }
}

// MARK: - Section
enum MovieListSection: Int, CaseIterable {
    case discover, popular, latest, trending
    
    var description: String {
        switch self {
        case .discover:
            return "둘러보기"
        case .popular:
            return "인기 영화"
        case .latest:
            return "최신 개봉"
        case .trending:
            return "지금 뜨는"
        }
    }
}
