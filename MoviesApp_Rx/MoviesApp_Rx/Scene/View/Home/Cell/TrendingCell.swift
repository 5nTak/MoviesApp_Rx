//
//  TrendingCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/18/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TrendingCell: UICollectionViewCell {
    static let identifier = "TrendingCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .center
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let accessaryView: UIImageView = {
        let accessaryView = UIImageView()
        accessaryView.image = UIImage(systemName: "chevron.forward")
        accessaryView.tintColor = .systemGray2
        accessaryView.contentMode = .center
        return accessaryView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    
    private let popularityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        accessaryView.image = nil
        titleLabel.text = nil
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .tertiarySystemFill
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        contentView.clipsToBounds = true
        
        [
            imageView,
            titleLabel,
            infoStackView,
            accessaryView
        ].forEach { contentView.addSubview($0) }
        
        infoStackView.addArrangedSubview(popularityLabel)
        infoStackView.addArrangedSubview(releaseDateLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalTo(accessaryView.snp.leading)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalTo(accessaryView.snp.leading)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        accessaryView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(10)
        }
        
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
    }
    
    func setup(title: String, popularity: Double, date: String) {
        titleLabel.text = title
        popularityLabel.text = "Trending score: \(popularity)"
        releaseDateLabel.text = date
    }
    
    func loadImage(url: String) {
        let urlString = imageView.imageBaseUrl + imageView.imageSize + url
        
        imageView.setImageCache(with: urlString)
    }
    
    func setFailedLoadImage() {
        imageView.image = UIImage(named: "noImageProvided")
        imageView.contentMode = .scaleAspectFit
    }
}
