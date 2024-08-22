//
//  ExpandedCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/20/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ExpandedCell: UICollectionViewCell {
    static let identifier = "ExpandedCell"
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return overlayView
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: UITraitCollection(preferredContentSizeCategory: .large))
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
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
        backgroundImageView.image = nil
        posterView.image = nil
        titleLabel.text = nil
        releasedDateLabel.text = nil
    }
    
    private func setupLayout() {
        [
            titleLabel,
            releasedDateLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
        
        [
            backgroundImageView,
            overlayView,
            posterView,
            labelStackView
        ].forEach { contentView.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        posterView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(posterView.snp.width).multipliedBy(1.5)
        }

        labelStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualTo(posterView.snp.leading).offset(-10)
        }
    }
    
    func setup(title: String, releasedDate: String) {
        titleLabel.text = title
        releasedDateLabel.text = releasedDate
    }
    
    func loadImage(backdropUrl: String, posterUrl: String) {
        let backdropUrlString = backgroundImageView.imageBaseUrl + backgroundImageView.imageSize + backdropUrl
        backgroundImageView.setImageCache(with: backdropUrlString)
        let posterUrlString = posterView.imageBaseUrl + posterView.imageSize + posterUrl
        posterView.setImageCache(with: posterUrlString)
    }
    
    func setFailedLoadImage() {
        backgroundImageView.image = UIImage(named: "noImageProvided")
        backgroundImageView.contentMode = .scaleAspectFill
        posterView.image = UIImage(named: "noImageProvided")
        posterView.contentMode = .scaleAspectFill
    }
}
