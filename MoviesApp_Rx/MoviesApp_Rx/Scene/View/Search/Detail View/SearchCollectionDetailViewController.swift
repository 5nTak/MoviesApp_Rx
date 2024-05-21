//
//  SearchCollectionDetailViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class SearchCollectionDetailViewController: UIViewController {
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<CollectionSectionModel>?
    var viewModel: SearchCollectionDetailViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(CollectionDetailCell.self, forCellWithReuseIdentifier: CollectionDetailCell.identifier)
        return collectionView
    }()
    
    init(viewModel: SearchCollectionDetailViewModel) {
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
        viewModel?.showCollectionContents()
        bind()
        didSelectMovies()
    }
    
    private func bind() {
        if let dataSource = rxDataSource {
            viewModel?.sections
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
        self.title = viewModel?.title
        collectionView.backgroundColor = .secondarySystemBackground
    }
    
    private func didSelectMovies() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let content = self?.rxDataSource?.sectionModels[indexPath.section].items[indexPath.item] else { return }
                let movie = content.toMovie()
                self?.viewModel?.coordinator?.detailFlow(with: movie, title: movie.title)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchCollectionDetailViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(0.4)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        return layout
    }
    
}

extension SearchCollectionDetailViewController {
    private func configureDataSource() {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<CollectionSectionModel>(
            configureCell: { rxDataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionDetailCell.identifier, for: indexPath) as? CollectionDetailCell else { return UICollectionViewCell() }
                cell.configure(
                    title: item.title,
                    mediaType: item.mediaType,
                    popularity: item.popularity,
                    releaseDate: item.releaseDate
                )
                if item.posterPath == nil {
                    cell.setFailedLoadImage()
                } else {
                    cell.loadImage(url: item.posterPath ?? "")
                }
                return cell
        }, configureSupplementaryView: nil
        )
    }
}
