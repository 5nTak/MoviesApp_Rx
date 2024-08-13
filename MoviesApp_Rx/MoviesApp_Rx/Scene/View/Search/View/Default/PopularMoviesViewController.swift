//
//  PopularMoviesViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PopularMoviesViewController: UIViewController {
    let viewModel: PopularMoviesViewModel
    
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(PopularMoviesCell.self, forCellReuseIdentifier: PopularMoviesCell.identifier)
        return tableView
    }()
    
    init(viewModel: PopularMoviesViewModel) {
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
        self.title = "Popular Movies"
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
        viewModel.popularMovies
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PopularMoviesCell.identifier, cellType: PopularMoviesCell.self)) { index, movie, cell in
                self.tableView.rowHeight = 147.6
                cell.setup(title: movie.title, genres: movie.genres ?? [], releasedDate: movie.releaseDate, voteAverage: movie.voteAverage)
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
        let totalRows = viewModel.popularMovies.value.count
        let needsToFetchMore = indexPaths.contains { $0.row >= totalRows - 10 }
        
        if needsToFetchMore {
            viewModel.fetchPopularMovies(page: viewModel.page + 1)
        }
    }
    
    private func didSelectMoviesAt() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let movie = viewModel.popularMovies.value[indexPath.row]
                self.viewModel.coordinator?.detailFlow(with: movie, title: movie.title, movieId: movie.id)
            })
            .disposed(by: disposeBag)
    }
}
