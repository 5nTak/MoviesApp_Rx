//
//  ReviewsCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/24/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ReviewsCell: UITableViewCell {
    static let identifier = "ReviewsCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 5
        return label
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView
        return stackView
    }()
    
    private let avatarIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "person.circle")
        iconView.kf.indicatorType = .activity
        return iconView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarIconView.image = UIImage(systemName: "person.circle")
        nameLabel.text = nil
        contentLabel.text = nil
    }
    
    private func setupLayout() {
        [
            avatarIconView,
            nameLabel
        ].forEach { profileStackView.addArrangedSubview($0)}
        
        [
            profileStackView,
            contentLabel
        ].forEach { contentView.addSubview($0) }
        
        profileStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
        }
        
        avatarIconView.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }
    
    func setup(username: String, content: String) {
        nameLabel.text = username
        contentLabel.text = content
    }
    
    func loadImage(url: String) {
        let urlString = avatarIconView.imageBaseUrl + avatarIconView.imageSize + url
        
        avatarIconView.setImageCache(with: urlString)
    }
}
