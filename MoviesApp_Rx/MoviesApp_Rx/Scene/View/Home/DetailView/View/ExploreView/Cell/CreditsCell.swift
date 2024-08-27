//
//  CreditsCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/25/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CreditsCell: UICollectionViewCell {
    static let identifier = "CreditsCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.contentMode = .scaleAspectFit
        return overlayView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 10
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
        profileImageView.image = nil
        nameLabel.text = nil
        roleLabel.text = nil
    }
    
    private func setupLayout() {
        [
            nameLabel,
            roleLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
        
//        [
//            profileImageView,
//            overlayView,
//            labelStackView
//        ].forEach { contentView.addSubview($0) }
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImageView.addSubview(overlayView)
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(profileImageView.snp.edges)
        }
        
        overlayView.addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func setup(profilePath: String, name: String, role: String) {
        if profilePath == "" {
            profileImageView.image = nil
            profileImageView.backgroundColor = .darkGray
        } else {
            let profileUrlString = profileImageView.imageBaseUrl + profileImageView.imageSize + profilePath
            profileImageView.setImageCache(with: profileUrlString)
        }
        
        nameLabel.text = name
        roleLabel.text = role
    }
}
