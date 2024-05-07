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
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureLayout()
        viewModel?.showSearchResult()
        bind()
        didSelectMovies()
        handleSearchText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bind() {
        viewModel?.sections
            .bind(to: collectionView.rx.items(dataSource: rxDataSource!))
            .disposed(by: disposeBag)
    }
    
    private func didSelectMovies() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                guard let item = self.rxDataSource?.sectionModels[indexPath.section].items[indexPath.item] else { return }
                if let movie = item as? Movie {
                    self.viewModel?.coordinator?.detailMovieFlow(with: movie, title: movie.title)
                } else if let collection = item as? Collection {
                    self.viewModel?.coordinator?.detailCollectionFlow(with: collection.id, title: collection.name)
                }
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSearchText() {
        searchBarView.rx.textDidChange
            .map { $0 }
            .bind(to: viewModel!.searchText)
            .disposed(by: disposeBag)
        
        searchBarView.rx.textDidChange
            .skip(1)
            .filter { !$0.isEmpty }
            .map { _ in () }
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
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
            guard let section = SearchSectionKind(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .movie:
                return self.createMovieSection()
            case .collection:
                return self.createCollectionSection()
            }
        }
        
        return layout
    }
    
    private func createMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(0.8)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        if let sectionHeader = self.createSectionHeader() {
            section.boundarySupplementaryItems = [sectionHeader]
        }
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
        if let sectionHeader = self.createSectionHeader() {
            section.boundarySupplementaryItems = [sectionHeader]
        }
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem? {
        guard let searchText = searchBarView.searchTextField.text, !searchText.isEmpty else {
            return nil
        }
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

// MARK: - RxDataSources
extension SearchViewController {
    private func configureDataSource() {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SearchSectionModel>(
            configureCell: { rxDataSource, collectionView, indexPath, item in
                switch indexPath.section {
                case 0:
                    guard let movie = item as? Movie,
                          let movieSectionCell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: SearchMovieCell.identifier,
                            for: indexPath
                          ) as? SearchMovieCell else { return UICollectionViewCell() }
                    movieSectionCell.configure(title: movie.title)
                    if movie.posterPath == nil {
                        movieSectionCell.setFailedLoadImage()
                    } else {
                        movieSectionCell.loadImage(url: movie.posterPath ?? "")
                    }
                    return movieSectionCell
                case 1:
                    guard let collection = item as? Collection,
                          let collectionSectionCell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: SearchCollectionCell.identifier,
                            for: indexPath
                          ) as? SearchCollectionCell else { return UICollectionViewCell() }
                    collectionSectionCell.configure(name: collection.name, overview: collection.overview)
                    if collection.posterPath == nil {
                        collectionSectionCell.setFailedLoadImage()
                    } else {
                        collectionSectionCell.loadImage(url: collection.posterPath ?? "")
                    }
                    return collectionSectionCell
                default :
                    return UICollectionViewCell()
                }
            },
            configureSupplementaryView: { rxDataSource, collectionView, kind, indexPath in
                let sectionModel = rxDataSource.sectionModels[indexPath.section]
                guard let section = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SearchHeaderView.identifier,
                    for: indexPath
                ) as? SearchHeaderView else { return UICollectionReusableView() }
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

enum SearchSectionKind: Int, CaseIterable {
    case movie, collection
    
    var description: String {
        switch self {
        case .movie:
            return "Movie"
        case .collection:
            return "Collection"
        }
    }
}
