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
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
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
        viewModel.isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.reviews
            .skip(1)
            .subscribe(onNext: { [weak self] reviews in
                if reviews.isEmpty {
                    self?.setupEmptyReviewLabel()
                } else {
                    self?.bindReviews()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupEmptyReviewLabel() {
        let noReviewLabel = UILabel()
        noReviewLabel.text = "Reviews don't exist"
        noReviewLabel.textAlignment = .center
        noReviewLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        view.addSubview(noReviewLabel)
        
        noReviewLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindReviews() {
        viewModel.reviews
            .bind(to: tableView.rx.items(cellIdentifier: ReviewsCell.identifier, cellType: ReviewsCell.self)) { (row, review, cell) in
                cell.setup(username: review.authorDetails.userName, content: review.content)
                if let avatarPath = review.authorDetails.avatarPath {
                    cell.loadImage(url: avatarPath)
                }
                cell.didTapCell = { [weak self] in
                    self?.showReviewDetail(for: review)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showReviewDetail(for review: Review) {
        let detailVC = ReviewDetailViewController(review: review)
        detailVC.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
