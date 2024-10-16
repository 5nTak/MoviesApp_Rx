//
//  GenreDetailViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class GenreDetailViewController: UIViewController {
    let viewModel: GenreDetailViewModel
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(GenreDetailCell.self, forCellReuseIdentifier: GenreDetailCell.identifier)
        return tableView
    }()
    
    init(viewModel: GenreDetailViewModel) {
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
        bindTableView()
        didSelectMoviesAt()
    }
    
    private func setupNavigationBar() {
        self.title = viewModel.genreName
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
    
    private func bindTableView() {
        viewModel.movies
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: GenreDetailCell.identifier, cellType: GenreDetailCell.self)) { index, movie, cell in
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
        let totalRows = viewModel.movies.value.count
        let needsToFetchMore = indexPaths.contains { $0.row >= totalRows - 10 }
        
        if needsToFetchMore {
            viewModel.fetchMovies(page: viewModel.page + 1, id: viewModel.genreId)
        }
    }
    
    private func didSelectMoviesAt() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let movie = viewModel.movies.value[indexPath.row]
                self.viewModel.coordinator?.detailFlow(title: movie.title, movieId: movie.id)
            })
            .disposed(by: disposeBag)
    }
}
