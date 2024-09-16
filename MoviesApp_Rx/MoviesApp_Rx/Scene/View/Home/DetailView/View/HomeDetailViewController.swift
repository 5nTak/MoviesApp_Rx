//
//  HomeDetailViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            return self.createLayout(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TopPosterCell.self, forCellWithReuseIdentifier: TopPosterCell.identifier)
        collectionView.register(MovieTitleCell.self, forCellWithReuseIdentifier: MovieTitleCell.identifier)
        collectionView.register(ExploreMovieCell.self, forCellWithReuseIdentifier: ExploreMovieCell.identifier)
        collectionView.register(MovieInfoCell.self, forCellWithReuseIdentifier: MovieInfoCell.identifier)
        collectionView.register(MovieOverviewCell.self, forCellWithReuseIdentifier: MovieOverviewCell.identifier)
        return collectionView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureHierarchy()
        bind()
        setupStarButton()
        starButtonTapped()
    }
    
    private func configureHierarchy() {
        self.title = "Movie Detail"
        let barButtonItem = UIBarButtonItem(customView: starButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationItem.backButtonDisplayMode = .minimal
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        let dataSource = createDataSource()
        
        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(DetailSectionItem.self)
            .bind { [weak self] item in
                switch item {
                case .explore(let exploreItem):
                    self?.handleExploreSection(exploreItem)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func handleExploreSection(_ item: ExploreItem) {
        switch item {
        case .reviews:
            viewModel.coordinator?.reviewsFlow()
        case .trailers:
            viewModel.coordinator?.trailersFlow()
        case .credits:
            viewModel.coordinator?.creditsFlow()
        case .similarMovies:
            viewModel.coordinator?.similarFlows()
        }
    }
}

// MARK: - Layout
extension DetailViewController {
    private func createLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch sectionIndex {
        case 0:
            return self.createTopPosterSectionLayout()
        case 1:
            return self.createMovieTitleSectionLayout()
        case 2:
            return self.createExploreMovieSectionLayout()
        case 3:
            return self.createMovieInfoSectionLayout()
        case 4:
            return self.createMovieOverviewSectionLayout()
        default:
            return createMovieOverviewSectionLayout()
        }
    }
    
    private func createTopPosterSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createMovieTitleSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createExploreMovieSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createMovieInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createMovieOverviewSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

// MARK: - DataSource
extension DetailViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<DetailSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<DetailSectionModel> { dataSource, collectionView, indexPath, item in
            switch item {
            case .topPoster(let movie):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPosterCell.identifier, for: indexPath) as? TopPosterCell else { return UICollectionViewCell() }
                if movie.backdropPath == nil || movie.posterPath == nil {
                    cell.setFailedLoadImage()
                } else {
                    cell.configureMoviePoster(backdropUrl: movie.backdropPath ?? "", posterUrl: movie.posterPath ?? "")
                }
                return cell
            case .title(let movie):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTitleCell.identifier, for: indexPath) as? MovieTitleCell else { return UICollectionViewCell() }
                cell.setup(title: movie.title, voteAverage: movie.voteAverage ?? 0)
                return cell
            case .explore(let exploreItem):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreMovieCell.identifier, for: indexPath) as? ExploreMovieCell else { return UICollectionViewCell() }
                cell.configure(with: exploreItem)
                return cell
            case .movieInfo(let movie):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCell.identifier, for: indexPath) as? MovieInfoCell else { return UICollectionViewCell() }
                let genreIds = movie.genres?.map { $0.id } ?? []
                let genres = self.viewModel.matchGenreIds(ids: genreIds)
                cell.configure(genres: genres, releaseDate: movie.releaseDate)
                return cell
            case .movieOverview(let movie):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieOverviewCell.identifier, for: indexPath) as? MovieOverviewCell else { return UICollectionViewCell() }
                cell.configure(overview: movie.overview)
                return cell
            }
        }
    }
}

// MARK: - Star
extension DetailViewController {
    private func starButtonTapped() {
        starButton.rx.tap
            .bind { [weak self] in
                guard let self = self else {
                    return
                }
                if Auth.auth().currentUser != nil {
                    setupStarButton()
                    viewModel.toggleFavorite()
                } else {
                    self.showAlert(message: "Login required.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupStarButton() {
        self.viewModel.isFavorite
            .asDriver()
            .drive { [weak self] isFavorite in
                let imageName = isFavorite ? "star.fill" : "star"
                self?.starButton.setImage(UIImage(systemName: imageName), for: .normal)
                self?.starButton.tintColor = isFavorite ? .yellow : .gray
            }
            .disposed(by: disposeBag)
    }
}
