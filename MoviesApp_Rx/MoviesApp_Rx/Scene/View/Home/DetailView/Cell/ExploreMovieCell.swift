//
//  ExploreMovieCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/22/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ExploreMovieCell: UICollectionViewCell {
    static let identifier = "ExploreMovieCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
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
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func setupLayout() {
        [
            imageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview().inset(5)
        }
    }
    
    func configure(with item: ExploreItem) {
        switch item {
        case .reviews:
            imageView.image = UIImage(systemName: "star.bubble")
            titleLabel.text = "Reviews"
        case .trailers:
            imageView.image = UIImage(systemName: "film")
            titleLabel.text = "Trailers"
        case .credits:
            imageView.image = UIImage(systemName: "person.3")
            titleLabel.text = "Credits"
        case .similarMovies:
            imageView.image = UIImage(systemName: "square.grid.2x2")
            titleLabel.text = "Similar Movies"
        }
    }
}
