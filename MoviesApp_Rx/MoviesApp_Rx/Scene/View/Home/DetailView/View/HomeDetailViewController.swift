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

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
   
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
        label.textColor = .reversedBackgroundColorAsset
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .reversedBackgroundColorAsset
        return label
    }()
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .reversedBackgroundColorAsset
        return label
    }()
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .reversedBackgroundColorAsset
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
        setupLayout()
        bindViewModel()
        spaceBetweenLines()
    }
    
    private func bindViewModel() {
        if viewModel.posterPath == nil {
            setFailedLoadImage()
        }
        else {
            let posterImageUrl = self.loadImage(url: viewModel.posterPath ?? "")
            posterView.setImageCache(with: posterImageUrl)
        }

        overViewLabel.text = "  Introduce : \n \(viewModel.overView)"
        releaseDateLabel.text = "Release Date : \(viewModel.releaseDate.isEmpty ? "Unknowned" : viewModel.releaseDate)"
        voteAverageLabel.text = "Vote : \(viewModel.voteAverage)"
        voteCountLabel.text = "Vote Count : \(viewModel.voteCount)"
        
        viewModel.isFavorite
            .asDriver()
            .drive { [weak self] isFavorite in
                let imageName = isFavorite ? "star.fill" : "star"
                self?.starButton.setImage(UIImage(systemName: imageName), for: .normal)
                self?.starButton.tintColor = isFavorite ? .yellow : .gray
            }
            .disposed(by: disposeBag)
        
        starButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleFavorite()
            }
            .disposed(by: disposeBag)
    }
    
    func loadImage(url: String) -> String {
        let urlString = posterView.imageBaseUrl + posterView.imageSize + url
        
        return urlString
    }
    
    func setFailedLoadImage() {
        posterView.image = UIImage(named: "noImageProvided")
        posterView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        self.title = viewModel.title
        let barButtonItem = UIBarButtonItem(customView: starButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterView)
        contentView.addSubview(overViewLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(voteAverageLabel)
        contentView.addSubview(voteCountLabel)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 20
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.height.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalToSuperview().inset(10)
        }

        posterView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo((UIScreen.main.bounds.height * 3) / 5)
        }

        overViewLabel.snp.makeConstraints {
            $0.top.equalTo(posterView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(15)
        }

        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(overViewLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
        }

        voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
        }

        voteCountLabel.snp.makeConstraints {
            $0.top.equalTo(voteAverageLabel.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalToSuperview().inset(15)
        }
    }
    
    private func spaceBetweenLines() {
        let attrString = NSMutableAttributedString(string: overViewLabel.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        overViewLabel.attributedText = attrString
    }
}
