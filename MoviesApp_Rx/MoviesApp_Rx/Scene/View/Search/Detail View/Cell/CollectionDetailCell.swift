//
//  CollectionDetailCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/24/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CollectionDetailCell: UICollectionViewCell {
    static let identifier = "CollectionDetailCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleToFill
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let mediaTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    private let popularityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.sizeToFit()
        label.textAlignment = .right
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
        titleLabel.text = nil
        mediaTypeLabel.text = nil
        popularityLabel.text = nil
        releaseDateLabel.text = nil
    }
    
    private func configureLayout() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        [
            imageView,
            titleLabel,
            mediaTypeLabel,
            popularityLabel,
            releaseDateLabel,
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        popularityLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        mediaTypeLabel.snp.makeConstraints {
            $0.top.equalTo(popularityLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(mediaTypeLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        imageView.layer.cornerRadius = 20
    }
    
    func configure(title: String, mediaType: String, popularity: Double, releaseDate: String) {
        titleLabel.text = title
        mediaTypeLabel.text = "mediaType : \(mediaType)"
        popularityLabel.text = "Trending score : \(popularity)"
        releaseDateLabel.text = "Release Date : \(releaseDate)"
    }
    
    func loadImage(url: String) {
        let urlString = imageView.imageBaseUrl + imageView.imageSize + url
        
        imageView.setImageCache(with: urlString)
    }
}
