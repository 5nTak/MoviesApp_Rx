//
//  SearchCollectionCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/22/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchCollectionCell: UICollectionViewCell {
    static let identifier = "SearchCollectionCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleToFill
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 13)
        label.sizeToFit()
        label.numberOfLines = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        nameLabel.text = nil
        overviewLabel.text = nil
    }
    
    private func configureLayout() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        [
            imageView,
            nameLabel,
            overviewLabel
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalTo(contentView.snp.height)
            $0.width.equalTo(imageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10).priority(.init(1000))
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        nameLabel.setContentHuggingPriority(.init(999), for: .vertical)
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10).priority(.init(1000))
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    func configure(name: String, overview: String) {
        nameLabel.text = name
        overviewLabel.text = overview
    }
    
    func loadImage(url: String) {
        let urlString = imageView.imageBaseUrl + imageView.imageSize + url
        
        imageView.setImageCache(with: urlString)
    }
}
