//
//  SearchCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 2024/02/22.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchMovieCell: UICollectionViewCell {
    static let identifier = "SearchMovieCell"
    
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
        label.textAlignment = .center
        label.numberOfLines = 1
        
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
    }
    
    private func configureLayout() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        [
            imageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 50
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func loadImage(url: String) {
        let urlString = imageView.imageBaseUrl + imageView.imageSize + url
        
        imageView.setImageCache(with: urlString)
    }
}
