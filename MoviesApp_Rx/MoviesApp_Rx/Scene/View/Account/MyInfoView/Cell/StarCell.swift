//
//  StarCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import SnapKit
import Kingfisher

final class StarCell: UICollectionViewCell {
    static let identifier = "StarCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .reversedBackgroundColorAsset
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
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
        titleLabel.text = nil
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        
        [
            imageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        imageView.layer.masksToBounds = true
    }
    
    func setup(title: String) {
        titleLabel.text = title
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
