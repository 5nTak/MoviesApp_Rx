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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.identifier)
        collectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.identifier)
        
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<SearchSectionModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureDataSource()
        viewModel?.showSearchResult()
        bind()
        didSelectMovies()
        handleSearchText()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarView.searchTextField.delegate = self
    }
    
    private func bind() {
        viewModel?.sections
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: collectionView.rx.items(dataSource: rxDataSource!))
            .disposed(by: disposeBag)
    }
    
    private func didSelectMovies() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let movie = self?.rxDataSource?.sectionModels[indexPath.section].items[indexPath.item] else { return }
                self?.viewModel?.coordinator?.detailFlow(with: movie)
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSearchText() {
        searchBarView.rx.textDidChange
            .map { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: viewModel!.searchText)
            .disposed(by: disposeBag)
        
        searchBarView.rx.textDidChange
            .skip(1)
            .filter { !$0.isEmpty }
            .map { _ in () }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.cancelSearch()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(searchBarView)
        view.addSubview(collectionView)
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).inset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - CompositionalLayout
extension SearchViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(0.5),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(0.4)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5)
            section.orthogonalScrollingBehavior = .continuous
            
            if let sectionHeader = self.createSectionHeader() {
                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }
        
        return layout
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
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchCell.identifier,
                    for: indexPath
                ) as? SearchCell else { return UICollectionViewCell() }
                if let movie = item as? Movie {
                    cell.configure(title: movie.title)
                    cell.loadImage(url: movie.posterPath ?? "")
                } else if let collection = item as? Collection {
                    cell.configure(title: collection.name)
                    cell.loadImage(url: collection.posterPath ?? "")
                }
                return cell
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

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.showSearchResult()
    }
}
