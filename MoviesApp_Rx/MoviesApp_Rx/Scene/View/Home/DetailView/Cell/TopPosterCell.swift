//
//  TopPosterCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/22/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TopPosterCell: UICollectionViewCell {
    static let identifier = "TopPosterCell"
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return overlayView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
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
        backdropImageView.image = nil
        overlayView.layer.mask = nil
        posterImageView.image = nil
    }
    
    private func setupLayout() {
        [
            backdropImageView,
            overlayView,
            posterImageView
        ].forEach { contentView.addSubview($0) }
        
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(backdropImageView.snp.edges)
        }
        
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
        }
        
        posterImageView.layer.shadowRadius = 20
    }
    
    func configureMoviePoster(backdropUrl: String, posterUrl: String) {
        let backdropUrlString = backdropImageView.imageBaseUrl + backdropImageView.imageSize + backdropUrl
        backdropImageView.setImageCache(with: backdropUrlString)
        let posterUrlString = posterImageView.imageBaseUrl + posterImageView.imageSize + posterUrl
        posterImageView.setImageCache(with: posterUrlString)
    }
    
    func setFailedLoadImage() {
        backdropImageView.image = UIImage(named: "noImageProvided")
        backdropImageView.contentMode = .scaleAspectFill
        posterImageView.image = UIImage(named: "noImageProvided")
        posterImageView.contentMode = .scaleAspectFill
    }
}