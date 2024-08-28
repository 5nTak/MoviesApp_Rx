//
//  ReviewsViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReviewsViewController: UIViewController {
    private let viewModel: ReviewsViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.identifier)
        return tableView
    }()
    
    init(viewModel: ReviewsViewModel) {
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
        viewModel.reviews
            .bind(to: tableView.rx.items(cellIdentifier: ReviewsCell.identifier, cellType: ReviewsCell.self)) { (row, review, cell) in
                cell.setup(username: review.authorDetails.userName, content: review.content)
                if review.authorDetails.avatarPath != nil {
                    cell.loadImage(url: review.authorDetails.avatarPath ?? "")
                }
            }
            .disposed(by: disposeBag)
    }
}
