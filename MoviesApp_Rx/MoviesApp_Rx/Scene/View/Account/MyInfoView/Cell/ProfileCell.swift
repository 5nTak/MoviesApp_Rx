//
//  ProfileCell.swift
//  MoviesApp_Rx
//
//  Created by Tak on 7/2/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileCell: UICollectionViewCell {
    static let identifier = "ProfileCell"
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        
        [
            profileImage,
            emailLabel
        ].forEach { contentView.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.width.equalToSuperview().dividedBy(5)
            $0.height.equalTo(profileImage.snp.width)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(10)
        }
        
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func setup(email: String) {
        emailLabel.text = email
    }
}
