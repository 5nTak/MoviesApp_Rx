//
//  TrailersController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TrailersController: UIViewController {
    private let viewModel: TrailersViewModel
    private let disposeBag = DisposeBag()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(TrailerCell.self, forCellReuseIdentifier: TrailerCell.identifier)
        return tableView
    }()
    
    init(viewModel: TrailersViewModel) {
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
    }
    
    private func setupNavigationBar() {
        self.title = viewModel.movieName
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
        
        viewModel.videos
            .skip(1)
            .subscribe(onNext: { [weak self] videos in
                self?.bindVideos()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindVideos() { // 임시
        viewModel.videos
            .bind(to: tableView.rx.items(cellIdentifier: TrailerCell.identifier, cellType: TrailerCell.self)) { (row, video, cell) in
                cell.setup(title: video.name, videoUrl: video.key) // 임시
            }
            .disposed(by: disposeBag)
    }
}
