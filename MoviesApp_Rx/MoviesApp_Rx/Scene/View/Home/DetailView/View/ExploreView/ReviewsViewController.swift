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
    private let viewModel: ExploreViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(ReviewsCell.self, forCellReuseIdentifier: ReviewsCell.identifier)
        return tableView
    }()
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        if self.viewModel.reviews.value.isEmpty {
            // Review가 없는 경우 표시할 UI Component 추가
            view.backgroundColor = .red
            tableView.backgroundColor = .blue
        } else {
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
}
