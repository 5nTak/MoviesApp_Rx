//
//  PreviewCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 4/18/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PreviewCell: UICollectionViewCell {
    static let identifier = "PreviewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.layer.borderWidth = 0
        label.sizeToFit()
        label.textAlignment = .center
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
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func setupBorderText() -> NSAttributedString {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.darkGray,
            .foregroundColor: UIColor.systemGray6,
            .strokeWidth: -5.0
        ]
        let attributedText = NSAttributedString(string: titleLabel.text ?? "", attributes: strokeTextAttributes)
        
        return attributedText
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .tertiarySystemFill
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        [
            imageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
        imageView.layer.cornerRadius = 10
    }
    
    func setup(title: String) {
        titleLabel.text = title
        titleLabel.attributedText = self.setupBorderText()
    }
    
    func loadImage(url: String) {
        let urlString = imageView.imageBaseUrl + imageView.imageSize + url
        
        imageView.setImageCache(with: urlString)
    }
}
