//
//  HomeDetailViewController.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/01/09.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.icloud")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return label
    }()
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        
        return contentView
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
        setupLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let posterImageUrl = self.loadImage(url: viewModel.posterPath ?? "")
        posterView.setImageCache(with: posterImageUrl)
        
        titleLabel.text = viewModel.title
        overViewLabel.text = " 영화 소개 : \(viewModel.overView)"
        releaseDateLabel.text = "개봉일 : \(viewModel.releaseDate.isEmpty ? "알 수 없음" : viewModel.releaseDate)"
        voteAverageLabel.text = "평점 : \(viewModel.voteAverage)"
        voteCountLabel.text = "평가에 참여한 수 : \(viewModel.voteCount)"
    }
    
    func loadImage(url: String) -> String {
        let urlString = posterView.imageBaseUrl + posterView.imageSize + url
        
        return urlString
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterView)
        contentView.addSubview(overViewLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(voteAverageLabel)
        contentView.addSubview(voteCountLabel)
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.height.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }

        posterView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height * 3) / 5)
        }

        overViewLabel.snp.makeConstraints {
            $0.top.equalTo(posterView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(overViewLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }

        voteCountLabel.snp.makeConstraints {
            $0.top.equalTo(voteAverageLabel.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
