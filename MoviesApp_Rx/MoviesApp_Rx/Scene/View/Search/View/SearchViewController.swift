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
    var viewModel: SearchViewModel
    private let searchBarView = SearchBarView()
    private let disposeBag = DisposeBag()
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<SearchSectionModel>?
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(RecentlyMoviesCell.self, forCellWithReuseIdentifier: RecentlyMoviesCell.identifier)
        collectionView.register(SearchMovieCell.self, forCellWithReuseIdentifier: SearchMovieCell.identifier)
        collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.identifier)
        collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.identifier)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        return collectionView
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureDataSource()
        configureLayout()
        viewModel.configureSections()
        bind()
        didSelectItems()
        handleSearchText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarView.searchTextField.becomeFirstResponder()
    }
    
    private func bind() {
        if let dataSource = rxDataSource {
            viewModel.sections
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
        
        viewModel.isDeleteMode
            .subscribe(onNext: { [weak self] isDeleteMode in
                self?.deleteButton.setTitle(isDeleteMode ? "Finish" : "Delete", for: .normal)
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedItems
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func handleDeleteButton() {
        if viewModel.isDeleteMode.value {
            viewModel.deleteSelectedMovies()
        } else {
            viewModel.toggleDeleteMode()
        }
    }
    
    private func didSelectItems() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                guard let sectionModel = self.rxDataSource?.sectionModels[indexPath.section] else { return }
                let item = sectionModel.items[indexPath.item]
                
                switch item {
                case .recentlyItem(let movie):
                    self.viewModel.coordinator?.detailMovieFlow(title: movie.title, movieId: movie.id)
                case .discoverPopular(let movies):
                    self.viewModel.coordinator?.popularMoviesFlow(page: 1)
                case .discoverTopRated(let movies):
                    self.viewModel.coordinator?.topRatedMoviesFlow(page: 1)
                case .genres(let genre):
                    self.viewModel.coordinator?.genreDetailFlow(id: genre.id, name: genre.name)
                case .searchMovies(let movie):
                    self.viewModel.coordinator?.detailMovieFlow(title: movie.title, movieId: movie.id)
                case .searchCollections(let collection):
                    self.viewModel.coordinator?.detailCollectionFlow(with: collection.id, title: collection.name)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSearchText() {
        searchBarView.rx.textDidChange
            .map { $0 }
            .bind(to: viewModel.searchText ?? BehaviorRelay(value: ""))
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
            heightDimension: .estimated(50)
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
                        withReuseIdentifier: RecentlyMoviesCell.identifier,
                        for: indexPath
                    ) as? RecentlyMoviesCell else { return UICollectionViewCell() }
                    cell.configure(title: movie.title)
                    if movie.posterPath == nil {
                        cell.setFailedLoadImage()
                    } else {
                        cell.loadImage(url: movie.posterPath ?? "")
                    }
                    
                    let isDeleteMode = self.viewModel.isDeleteMode.value
                    cell.showCheckBox(isVisible: isDeleteMode)
                    let isSelected = self.viewModel.selectedItems.value.contains(movie.id)
                    cell.updateCheckBox(isSelected: isSelected)
                    
                    cell.bindCheckBoxTap(movieId: movie.id, viewModel: self.viewModel)
                    return cell
                case .discoverPopular(let movies):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    cell.setup(title: movies)
                    cell.changeTextColor(color: .systemBlue)
                    return cell
                case .discoverTopRated(let movies):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    cell.setup(title: movies)
                    cell.changeTextColor(color: .systemBlue)
                    return cell
                case .genres(let genre):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.identifier,
                        for: indexPath
                    ) as? ListCell else { return UICollectionViewCell() }
                    cell.setup(title: genre.name)
                    cell.changeTextColor(color: .black)
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
                ) as? SearchHeaderView else { return UICollectionReusableView() }
                if sectionModel.title == SearchSectionKind.recentlyMovies.description {
                    section.configure(title: sectionModel.title)
                    
                    section.addSubview(self.deleteButton)
                    
                    self.deleteButton.snp.makeConstraints {
                        $0.trailing.equalToSuperview().inset(10)
                        $0.centerY.equalToSuperview()
                    }
                } else {
                    section.configure(title: sectionModel.title)
                }
                
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
