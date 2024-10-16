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
    private let isExpandedLayout = BehaviorRelay<Bool>(value: false)
    private var rxDataSource: RxCollectionViewSectionedReloadDataSource<MovieSectionModel>?
    private var viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    private let convertCellButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.and.film"), for: .normal)
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.register(ExpandedCell.self, forCellWithReuseIdentifier: ExpandedCell.identifier)
        return collectionView
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureHierarchy()
        configureDataSource()
        bind()
        didSelectMovies()
        setupPrefetching()
        setupButtonAction()
    }
    
    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        self.title = "Upcoming Movies"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: convertCellButton)
    }
    
    private func setupButtonAction() {
        convertCellButton.addTarget(self, action: #selector(toggleLayout), for: .touchUpInside)
    }
    
    @objc private func toggleLayout() {
        isExpandedLayout.accept(!isExpandedLayout.value)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    private func bind() {
        viewModel.fetchUpcomingMovies()
        
        if let dataSource = rxDataSource {
            viewModel.upcomingMovies
                .bind(to: collectionView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    private func setupPrefetching() {
        collectionView.rx.prefetchItems
            .subscribe(onNext: { [weak self] indexPaths in
                guard let self = self else { return }
                let itemCount = self.collectionView.numberOfItems(inSection: 0)
                
                if indexPaths.contains(where: { $0.item >= itemCount - 5 }) { // 끝에서 5개 전부터 prefetch
                    self.viewModel.loadMoreUpcomingMovies()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func didSelectMovies() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let movie = self?.rxDataSource?.sectionModels[indexPath.section].items[indexPath.item] else { return }
                self?.viewModel.coordinator?.detailFlow(title: movie.title, movieId: movie.id)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        if isExpandedLayout.value {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/4)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return UICollectionViewCompositionalLayout(section: section)
        } else {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/2)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return UICollectionViewCompositionalLayout(section: section)
        }
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
            configureCell: { [weak self] rxDataSource, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                
                let isExpanded = self.isExpandedLayout.value
                
                if isExpanded {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandedCell.identifier, for: indexPath) as? ExpandedCell else { return UICollectionViewCell() }
                    cell.setup(title: item.title, releasedDate: item.releaseDate)
                    if item.posterPath == nil || item.backdropPath == nil {
                        cell.setFailedLoadImage()
                    } else {
                        cell.loadImage(backdropUrl: item.backdropPath ?? "", posterUrl: item.posterPath ?? "")
                    }
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as? PosterCell else { return UICollectionViewCell() }
                    if item.posterPath == nil {
                        cell.setFailedLoadImage()
                    } else {
                        cell.loadImage(url: item.posterPath ?? "")
                    }
                    return cell
                }
            }
        )
        
        isExpandedLayout
            .subscribe { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}
