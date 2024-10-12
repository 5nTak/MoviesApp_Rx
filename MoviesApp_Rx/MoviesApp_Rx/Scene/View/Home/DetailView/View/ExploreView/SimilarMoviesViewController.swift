//
//  SimilarMoviesViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimilarMoviesViewController: UIViewController {
    private var viewModel: SimilarMoviesViewModel
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(SimilarMoviesCell.self, forCellReuseIdentifier: SimilarMoviesCell.identifier)
        return tableView
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: SimilarMoviesViewModel) {
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
        bind()
        didSelectMoviesAt()
    }
    
    private func setupNavigationBar() {
        self.title = "Similar Movies"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.similarMovies
            .subscribe(onNext: { [weak self] movies in
                if movies.isEmpty {
                    self?.setupEmptyReviewLabel()
                } else {
                    self?.bindMovies()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMovies() {
        for subview in view.subviews {
            if let label = subview as? UILabel, label.text == "Not Found!" {
                label.removeFromSuperview()
            }
        }
        
        viewModel.similarMovies
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: SimilarMoviesCell.identifier, cellType: SimilarMoviesCell.self)) { index, movie, cell in
                self.tableView.rowHeight = 147.6
                let genres = self.viewModel.matchGenreIds(ids: movie.genreIds ?? [])
                cell.setup(
                    title: movie.title,
                    genres: genres,
                    releasedDate: movie.releaseDate,
                    voteAverage: movie.voteAverage
                )
                
                if movie.posterPath == nil {
                    cell.setFailedLoadImage()
                } else {
                    cell.loadImage(url: movie.posterPath ?? "")
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .subscribe(onNext: { [weak self] indexPaths in
                self?.prefetchData(indexPaths: indexPaths)
            })
            .disposed(by: disposeBag)
    }
    
    private func prefetchData(indexPaths: [IndexPath]) {
        let totalRows = viewModel.similarMovies.value.count
        let needsToFetchMore = indexPaths.contains { $0.row >= totalRows - 10 }
        
        if needsToFetchMore {
            viewModel.fetchSimilarMovies(id: viewModel.movieId, page: viewModel.page + 1)
        }
    }
    
    private func didSelectMoviesAt() {
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                guard let self = self else { return }
                let movie = viewModel.similarMovies.value[indexPath.row]
                self.viewModel.coordinator?.detailFlow(movieId: movie.id, movieName: movie.title)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupEmptyReviewLabel() {
        let notFoundLabel = UILabel()
        notFoundLabel.text = "Not Found!"
        notFoundLabel.textAlignment = .center
        notFoundLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        view.addSubview(notFoundLabel)
        
        notFoundLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
