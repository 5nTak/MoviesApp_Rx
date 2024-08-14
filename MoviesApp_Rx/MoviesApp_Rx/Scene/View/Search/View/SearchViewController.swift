//
//  SearchViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: UIViewController {
    var viewModel: SearchViewModel?
    private let searchBarView = SearchBarView()
    private let disposeBag = DisposeBag()
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<SearchSectionModel>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.identifier)
        collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.identifier)
        collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.identifier)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureDataSource()
        configureLayout()
        viewModel?.showSearchResult()
        bind()
        didSelectItems()
        handleSearchText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarView.searchTextField.becomeFirstResponder()
    }
    
    private func bind() {
        if let dataSource = rxDataSource {
            viewModel?.sections
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    private func didSelectItems() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                guard let sectionModel = self.rxDataSource?.sectionModels[indexPath.section] else { return }
                let item = sectionModel.items[indexPath.item]
                
                if self.viewModel?.isSearchActive.value == true {
                    if let movie = item as? Movie {
                        self.viewModel?.coordinator?.detailMovieFlow(with: movie, title: movie.title, movieId: movie.id)
                    } else if let collection = item as? Collection {
                        self.viewModel?.coordinator?.detailCollectionFlow(with: collection.id, title: collection.name)
                    }
                } else {
                    switch item {
                    case .recentlyItem(let movieTitle):
                        print("Selected Recently Viewed Movie: \(movieTitle)")
                    case .discoverPopular(let movies):
                        self.viewModel?.coordinator?.popularMoviesFlow(page: 1)
                    case .discoverTopRated(let movies):
                        self.viewModel?.coordinator?.topRatedMoviesFlow(page: 1)
                    case .genres(let genre):
                        print("Selected Genre: \(genre)")
                    default:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSearchText() {
        searchBarView.rx.textDidChange
            .map { $0 }
            .bind(to: viewModel?.searchText ?? BehaviorRelay(value: ""))
            .disposed(by: disposeBag)
        
        searchBarView.rx.textDidChange
            .skip(1)
            .filter { !$0.isEmpty }
            .map { _ in () }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        self.title = "Search Movies"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func configureLayout() {
        collectionView.delegate = self
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBarView)
        view.addSubview(collectionView)
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.layer.cornerRadius = 10
    }
}

// MARK: - CompositionalLayout
extension SearchViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionTitle = self.rxDataSource?.sectionModels[sectionIndex].title,
                  let section = SearchSectionKind(rawValue: sectionTitle) else { 
                return nil
            }
            
            switch section {
            case .recentlyMovies:
                return self.createMovieSection()
            case .discover:
                return self.createListSection()
            case .genres:
                return self.createListSection()
            case .movie:
                return self.createMovieSection()
            case .collection:
                return self.createCollectionSection()
            }
        }
        
        return layout
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 50, trailing: 0)
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 30, trailing: 10)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .fractionalHeight(0.6)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createCollectionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
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

// MARK: - RxDataSources
extension SearchViewController {
    private func configureDataSource() {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SearchSectionModel>(
            configureCell: { rxDataSource, collectionView, indexPath, item in
                switch item {
                case .recentlyItem(let movie):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    // dummy
                    cell.setup(title: "Dummy: \(movie)")
                    return cell
                case .discoverPopular(let movies):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    cell.setup(title: movies)
                    return cell
                case .discoverTopRated(let movies):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    cell.setup(title: movies)
                    return cell
                case .genres(let genre):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    cell.setup(title: genre.name)
                    return cell
                case .searchMovies(let movie):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SearchMovieCell.identifier,
                        for: indexPath
                    ) as? SearchMovieCell else { return UICollectionViewCell() }
                    cell.configure(title: movie.title)
                    if movie.posterPath == nil {
                        cell.setFailedLoadImage()
                    } else {
                        cell.loadImage(url: movie.posterPath ?? "")
                    }
                    return cell
                case .searchCollections(let collection):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SearchCollectionCell.identifier,
                        for: indexPath
                    ) as? SearchCollectionCell else { return UICollectionViewCell() }
                    cell.configure(name: collection.name, overview: collection.overview)
                    if collection.posterPath == nil {
                        cell.setFailedLoadImage()
                    } else {
                        cell.loadImage(url: collection.posterPath ?? "")
                    }
                    return cell
                }
            },
            configureSupplementaryView: { rxDataSource, collectionView, kind, indexPath in
                let sectionModel = rxDataSource.sectionModels[indexPath.section]
                guard let section = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SearchHeaderView.identifier,
                    for: indexPath
                ) as? SearchHeaderView else {
                    return UICollectionReusableView()
                }
                section.configure(title: sectionModel.title)
                return section
            }
        )
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

enum SearchSectionKind: String, CaseIterable {
    case recentlyMovies = "Recently Movies"
    case discover = "Discover"
    case genres = "Genres"
    case movie = "Movie"
    case collection = "Collection"
    
    var description: String {
        return self.rawValue
    }
}
