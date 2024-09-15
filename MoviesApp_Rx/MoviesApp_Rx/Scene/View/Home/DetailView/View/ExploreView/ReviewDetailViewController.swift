//
//  ReviewDetailViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 9/15/24.
//

import UIKit
import SnapKit

final class ReviewDetailViewController: UIViewController {
    private let review: Review
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    init(review: Review) {
        self.review = review
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        configureContent()
    }
    
    private func setupNavigationBar() {
        self.title = review.authorDetails.userName
        let xmarkImage = UIImage(systemName: "xmark")
        let closeButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureContent() {
        contentLabel.text = review.content
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
